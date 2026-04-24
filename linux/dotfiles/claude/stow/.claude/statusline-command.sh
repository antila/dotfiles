#!/usr/bin/env bash
# Claude Code status line script

input=$(cat)

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# --- Context window ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

build_bar() {
  local pct="$1" width=10 filled bar=""
  filled=$(printf '%.0f' "$(echo "$pct $width 100" | awk '{printf "%f", $1 * $2 / $3}')")
  local empty=$(( width - filled ))
  for ((i=0; i<filled; i++)); do bar="${bar}█"; done
  for ((i=0; i<empty; i++)); do bar="${bar}░"; done
  echo "$bar"
}

if [ -n "$used_pct" ]; then
  bar=$(build_bar "$used_pct")
  ctx_str="Context $(printf '%.0f' "$used_pct")% [${bar}]"
else
  ctx_str=""
fi

# --- Rate limits (Claude.ai subscription) ---
fmt_reset() {
  local epoch="$1"
  if [ -z "$epoch" ] || [ "$epoch" = "null" ]; then echo ""; return; fi
  local now diff
  now=$(date +%s)
  diff=$(( epoch - now ))
  if [ "$diff" -le 0 ]; then echo ""; return; fi
  local h=$(( diff / 3600 ))
  local m=$(( (diff % 3600) / 60 ))
  if [ "$h" -gt 0 ]; then printf " resets %dh%dm" "$h" "$m"
  else printf " resets %dm" "$m"; fi
}

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

if [ -n "$five_pct" ]; then
  five_bar=$(build_bar "$five_pct")
  five_str="Session $(printf '%.0f' "$five_pct")% [${five_bar}]$(fmt_reset "$five_reset")"
else
  five_str=""
fi

if [ -n "$week_pct" ]; then
  week_bar=$(build_bar "$week_pct")
  week_str="Week $(printf '%.0f' "$week_pct")% [${week_bar}]$(fmt_reset "$week_reset")"
else
  week_str=""
fi

# --- Assemble ---
parts=("$model")
[ -n "$ctx_str" ]  && parts+=("$ctx_str")
[ -n "$five_str" ] && parts+=("$five_str")
[ -n "$week_str" ] && parts+=("$week_str")

out=""
for part in "${parts[@]}"; do
  out="${out:+$out  |  }$part"
done
printf "%s" "$out"
