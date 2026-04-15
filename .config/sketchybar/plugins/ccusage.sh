#!/bin/bash

export PATH="/Users/$USER/.asdf/installs/nodejs/22.19.0/bin:$PATH"

ITEMS=(ccusage_tokens ccusage_cost)
CURRENT_MONTH=$(date +"%Y-%m")
TODAY=$(date +"%Y%m%d")
TODAY_ISO=$(date +"%Y-%m-%d")

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

# Extract tokens and cost as TSV for the current month.
# Uses totalTokens if present (ccusage), otherwise sums fields (ccusage-pi).
extract_monthly() {
  echo "$1" | jq -r --arg m "$CURRENT_MONTH" '
    .monthly[] | select(.month == $m) |
    [ (.totalTokens // ((.inputTokens//0)+(.outputTokens//0)+(.cacheCreationTokens//0)+(.cacheReadTokens//0))),
      (.totalCost // 0) ] | @tsv'
}

# Extract tokens for today from daily data.
extract_daily() {
  echo "$1" | jq -r --arg d "$TODAY_ISO" '
    .daily[] | select(.date == $d) |
    (.totalTokens // ((.inputTokens//0)+(.outputTokens//0)+(.cacheCreationTokens//0)+(.cacheReadTokens//0)))'
}

# --- Guard ---

command -v ccusage &>/dev/null || hide_all_and_exit

# --- Fetch monthly data ---

monthly_json=$(ccusage monthly --json 2>/dev/null) || hide_all_and_exit
[ -n "$monthly_json" ] || hide_all_and_exit

read -r total_tokens total_cost <<< "$(extract_monthly "$monthly_json")"
total_tokens=${total_tokens:-0}
total_cost=${total_cost:-0}

# --- Fetch daily data ---

daily_json=$(ccusage daily --json --since "$TODAY" --until "$TODAY" 2>/dev/null)
today_tokens=0
if [ -n "$daily_json" ]; then
  cc_today=$(extract_daily "$daily_json")
  [ -n "$cc_today" ] && today_tokens=$((today_tokens + cc_today))
fi

if command -v ccusage-pi &>/dev/null; then
  pi_json=$(ccusage-pi monthly --json 2>/dev/null)
  if [ $? -eq 0 ] && [ -n "$pi_json" ]; then
    read -r pi_tokens pi_cost <<< "$(extract_monthly "$pi_json")"
    [ -n "$pi_tokens" ] && total_tokens=$((total_tokens + pi_tokens))
    [ -n "$pi_cost" ]   && total_cost=$(echo "$total_cost + $pi_cost" | bc)
  fi

  pi_daily_json=$(ccusage-pi daily --json --since "$TODAY_ISO" --until "$TODAY_ISO" 2>/dev/null)
  if [ $? -eq 0 ] && [ -n "$pi_daily_json" ]; then
    pi_today=$(extract_daily "$pi_daily_json")
    [ -n "$pi_today" ] && today_tokens=$((today_tokens + pi_today))
  fi
fi

# --- Format labels ---

formatted_today=$(printf "%'d" "$today_tokens")
formatted_monthly=$(printf "%'d" "$total_tokens")
if [ "$total_tokens" -le 1 ]; then
  formatted_tokens="$formatted_today / $formatted_monthly token this month"
else
  formatted_tokens="$formatted_today / $formatted_monthly tokens this month"
fi
formatted_cost=$(printf "$%.2f" "$total_cost")
cost_color=$(color_for_cost "$total_cost")

# --- Update sketchybar ---

sketchybar --set ccusage_tokens drawing=on label="$formatted_tokens" \
           --set ccusage_cost drawing=on label="$formatted_cost" label.color="$cost_color"
