#!/bin/bash

export PATH="/Users/$USER/.asdf/installs/nodejs/22.19.0/bin:$PATH"

ITEMS=(ccusage_tokens)
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

# Extract tokens for the current month.
# Uses totalTokens if present (ccusage), otherwise sums fields (ccusage-pi).
extract_monthly() {
  echo "$1" | jq -r --arg m "$CURRENT_MONTH" '
    .monthly[] | select(.month == $m) |
    (.totalTokens // ((.inputTokens//0)+(.outputTokens//0)+(.cacheCreationTokens//0)+(.cacheReadTokens//0)))'
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

total_tokens=$(extract_monthly "$monthly_json")
total_tokens=${total_tokens:-0}

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
    pi_tokens=$(extract_monthly "$pi_json")
    [ -n "$pi_tokens" ] && total_tokens=$((total_tokens + pi_tokens))
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
formatted_tokens="$formatted_today / $formatted_monthly"

# --- Update sketchybar ---

sketchybar --set ccusage_tokens drawing=on label="$formatted_tokens"
