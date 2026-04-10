#!/bin/bash

export PATH="/Users/$USER/.asdf/installs/nodejs/22.19.0/bin:$PATH"

ITEMS=(ccusage_tokens ccusage_cost ccusage_remaining)
CURRENT_MONTH=$(date +"%Y-%m")

# --- Helpers ---

hide_all_and_exit() {
  for item in "${ITEMS[@]}"; do
    sketchybar --set "$item" drawing=off
  done
  exit 0
}

# Kanso Ink palette
COLOR_GREEN="0xff8a9a7b"
COLOR_YELLOW="0xffe6c384"
COLOR_RED="0xffe46876"
COLOR_FG="0xffc5c9c7"

color_for_cost() {
  local cost_int=${1%.*}
  : "${cost_int:=0}"
  if [ "$cost_int" -ge 300 ]; then echo "$COLOR_RED"
  elif [ "$cost_int" -ge 100 ]; then echo "$COLOR_YELLOW"
  else echo "$COLOR_GREEN"; fi
}

color_for_remaining() {
  local mins=$1
  if [ "$mins" -lt 60 ]; then echo "$COLOR_RED"
  elif [ "$mins" -lt 120 ]; then echo "$COLOR_YELLOW"
  else echo "$COLOR_GREEN"; fi
}

# Extract tokens and cost as TSV for the current month.
# Uses totalTokens if present (ccusage), otherwise sums fields (ccusage-pi).
extract_monthly() {
  echo "$1" | jq -r --arg m "$CURRENT_MONTH" '
    .monthly[] | select(.month == $m) |
    [ (.totalTokens // ((.inputTokens//0)+(.outputTokens//0)+(.cacheCreationTokens//0)+(.cacheReadTokens//0))),
      (.totalCost // 0) ] | @tsv'
}

# --- Guard ---

command -v ccusage &>/dev/null || hide_all_and_exit

# --- Fetch monthly data ---

monthly_json=$(ccusage monthly --json 2>/dev/null) || hide_all_and_exit
[ -n "$monthly_json" ] || hide_all_and_exit

read -r total_tokens total_cost <<< "$(extract_monthly "$monthly_json")"
total_tokens=${total_tokens:-0}
total_cost=${total_cost:-0}

if command -v ccusage-pi &>/dev/null; then
  pi_json=$(ccusage-pi monthly --json 2>/dev/null)
  if [ $? -eq 0 ] && [ -n "$pi_json" ]; then
    read -r pi_tokens pi_cost <<< "$(extract_monthly "$pi_json")"
    [ -n "$pi_tokens" ] && total_tokens=$((total_tokens + pi_tokens))
    [ -n "$pi_cost" ]   && total_cost=$(echo "$total_cost + $pi_cost" | bc)
  fi
fi

# --- Format labels ---

if [ "$total_tokens" -le 1 ]; then
  formatted_tokens=$(printf "%'d token" "$total_tokens")
else
  formatted_tokens=$(printf "%'d tokens" "$total_tokens")
fi
formatted_cost=$(printf "$%.2f" "$total_cost")
cost_color=$(color_for_cost "$total_cost")

# --- Active block remaining time ---

has_active=false
remaining_label=""
remaining_color="$COLOR_FG"

blocks_json=$(ccusage blocks --active --json 2>/dev/null)
if [ $? -eq 0 ] && [ -n "$blocks_json" ]; then
  remaining_minutes=$(echo "$blocks_json" | jq -r \
    '.blocks[] | select(.isActive == true) | .projection.remainingMinutes // empty' | head -1)

  if [ -n "$remaining_minutes" ]; then
    has_active=true
    remaining_int=${remaining_minutes%.*}
    remaining_label=$(printf "%02d:%02d left" $((remaining_int / 60)) $((remaining_int % 60)))
    remaining_color=$(color_for_remaining "$remaining_int")
  fi
fi

# --- Update sketchybar ---

sketchybar --set ccusage_tokens drawing=on label="$formatted_tokens" \
           --set ccusage_cost drawing=on label="$formatted_cost" label.color="$cost_color"

if [ "$has_active" = true ]; then
  sketchybar --set ccusage_remaining drawing=on label="$remaining_label" \
             label.color="$remaining_color" icon.color="$remaining_color"
else
  sketchybar --set ccusage_remaining drawing=off
fi
