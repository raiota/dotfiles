#!/usr/bin/env bash
# Claude Code statusline — Catppuccin Macchiato, Nerd Font icons.
#
# Claude Code pipes session JSON on stdin (see settings.json "statusLine");
# this prints two lines:
#
#   󰧑 Opus 5 [high]      repo  󰘬 branch
#   ctx ◑  42% │ 5h ⣿⣿⣤⣿┃⣿⣿⣿  31% 1h54m │ 7d ⣿⣿⣿⣿⣿┃⣿⣿  68%  1d9h
#
# ctx is a ring (○◔◑◕●) because the context window has no reset window to pace
# against; the rate-limit meters are braille bars carrying a ┃ pace cursor that
# marks how far through the reset window you are. Fill behind the cursor means
# you're consuming slower than the window refills (green); fill past it means
# you're outrunning it (yellow, then red for way over). Absolute floors still
# apply — >= 85% used is always red no matter the pace. The trailing 1h54m is
# time left until that window resets. ctx has no cursor, so it uses plain 60/85
# thresholds.
#
# On line 2 every field that can be absent keeps its width, so the │ separators
# never move as data arrives: percentages are 4 columns, reset times 5, bars 8.
# Missing meters show a dim ⣿⣿⣿⣿⣿⣿⣿⣿ track and a blank time field. rate_limits
# only appear for Pro/Max after the first API response, effort only on models
# supporting it, and context_window.used_percentage may be null early in a
# session. Line 1 is unpadded — it only moves when you switch model or /effort
# yourself. The repo/branch segments drop out entirely outside a git repo, and
# the worktree segment is last so nothing shifts when it appears.
#
# Run it from a terminal (no piped stdin) for a preview of the
# on-track / over-pace / no-data states. Requires jq; git is optional.

# ── Catppuccin Macchiato ──────────────────────────────────────────────────────
GREEN=$'\033[38;2;166;218;149m'    # on pace
YELLOW=$'\033[38;2;238;212;159m'   # slightly ahead of pace
RED=$'\033[38;2;237;135;150m'      # way ahead, or >= 85% used
BLUE=$'\033[38;2;138;173;244m'     # repo
TEAL=$'\033[38;2;139;213;202m'     # branch
LAVENDER=$'\033[38;2;183;189;248m' # worktree
MAUVE=$'\033[38;2;198;160;246m'    # model
TEXT=$'\033[38;2;202;211;245m'     # percentages
SUBTEXT1=$'\033[38;2;184;192;224m' # pace cursor
SUBTEXT0=$'\033[38;2;165;173;203m' # effort level
OVERLAY1=$'\033[38;2;128;135;162m' # field labels, reset times
SURFACE2=$'\033[38;2;91;96;120m'   # separators, brackets
SURFACE1=$'\033[38;2;73;77;100m'   # empty and no-data track
RST=$'\033[0m'

# ── Nerd Font icons ───────────────────────────────────────────────────────────
ICON_MODEL="󰧑"     # U+F09D1 nf-md-brain
ICON_REPO=""      # U+F401  nf-oct-repo
ICON_BRANCH="󰘬"    # U+F062C nf-md-source_branch
ICON_WORKTREE="󰙅"  # U+F0645 nf-md-file_tree
# Gap after an icon. These glyphs are East-Asian-ambiguous width, so terminals
# configured for CJK draw them two columns wide and a single space reads as
# none; two spaces keep the icon and its value visually separate either way.
IGAP="  "

SEP=" ${SURFACE2}│${RST} "
CELLS=8
# Seven fill levels, indexed 1-7: the braille bar shows fractions of a cell, so
# an 8-cell bar reads at ~1.5% granularity instead of 12.5%.
BRAILLE=("⣀" "⣄" "⣤" "⣦" "⣶" "⣷" "⣿")
RINGS=("○" "◔" "◑" "◕" "●")
# Empty cells and the no-data bar: the same glyph as a full cell but drawn in
# SURFACE1, so the gauge reads as one continuous track with the fill on top.
VOID="⣿"
MARK="┃"

# ── Severity: 0 green · 1 yellow · 2 red ──────────────────────────────────────
# $1 usage pct, $2 elapsed pct of the reset window (-1 = no window).
sev_of() {
  local pct=$1 elapsed=$2 sev=0 over
  if (( elapsed >= 0 )); then
    over=$(( pct - elapsed ))
    (( over > 5 )) && sev=1
    (( over > 20 )) && sev=2
    (( pct >= 70 && sev < 1 )) && sev=1
    (( pct >= 85 )) && sev=2
  else
    (( pct >= 60 )) && sev=1
    (( pct >= 85 )) && sev=2
  fi
  printf '%s' "$sev"
}

color_of() {
  case $1 in
    2) printf '%s' "$RED" ;;
    1) printf '%s' "$YELLOW" ;;
    *) printf '%s' "$GREEN" ;;
  esac
}

# ── Fixed-width plain-text fields ─────────────────────────────────────────────
# Padding is measured on ASCII only: ${#var} counts bytes, not characters, when
# the locale is not UTF-8, and every icon and bar glyph here is multibyte.
pct_txt() { # always 4 columns
  if (( $1 < 0 )); then printf '  --'; else printf '%3d%%' "$1"; fi
}

secs_txt() { # always 5 columns; blank when unknown
  local s=$1 d h m out
  if (( s < 0 )); then printf '     '; return; fi
  d=$(( s / 86400 )); h=$(( (s % 86400) / 3600 )); m=$(( (s % 3600) / 60 ))
  if   (( d > 0 )); then out=$(printf '%dd%dh' "$d" "$h")
  elif (( h > 0 )); then out=$(printf '%dh%02dm' "$h" "$m")
  else                   out=$(printf '%dm' "$m")
  fi
  printf '%5s' "$out"
}

# ── ctx: a ring, deliberately not a bar ───────────────────────────────────────
# No resets_at means no pace to draw, so the shape differs from the rate-limit
# meters on purpose: a ┃ cursor in this statusline always implies a time window.
ring() {
  local pct=$1 idx
  if (( pct < 0 )); then
    printf '%s' "${SURFACE1}${RINGS[0]}${RST} ${SURFACE1}$(pct_txt -1)${RST}"
    return
  fi
  (( pct > 100 )) && pct=100
  idx=$(( (pct * 4 + 50) / 100 ))
  printf '%s' "$(color_of "$(sev_of "$pct" -1)")${RINGS[$idx]}${RST} ${TEXT}$(pct_txt "$pct")${RST}"
}

# ── Rate-limit bar: braille fill + ┃ pace cursor, always CELLS wide ───────────
# $1 usage pct (-1 = no data), $2 elapsed pct of the window (-1 = no window).
bar() {
  local pct=$1 elapsed=$2 color mark=0 i t cp idx out=""
  if (( pct < 0 )); then
    for (( i = 1; i <= CELLS; i++ )); do out+="$VOID"; done
    printf '%s' "${SURFACE1}${out}${RST}"
    return
  fi
  (( pct > 100 )) && pct=100
  color=$(color_of "$(sev_of "$pct" "$elapsed")")

  if (( elapsed >= 0 )); then
    mark=$(( (elapsed * CELLS + 50) / 100 ))
    (( mark < 1 )) && mark=1
    (( mark > CELLS )) && mark=CELLS
  fi

  t=$(( pct * CELLS ))
  for (( i = 0; i < CELLS; i++ )); do
    if (( i + 1 == mark )); then out+="${SUBTEXT1}${MARK}${color}"; continue; fi
    cp=$(( t - i * 100 ))  # how far into cell i the fill reaches, 0-100
    if (( cp <= 0 )); then out+="${SURFACE1}${VOID}${color}"; continue; fi
    if (( cp >= 100 )); then
      idx=7
    else
      # any fill at all rounds up to the lowest level, so a cell that has
      # started filling never reads as empty track
      idx=$(( cp * 7 / 100 )); (( idx < 1 )) && idx=1
    fi
    out+="${BRAILLE[$(( idx - 1 ))]}"
  done
  printf '%s' "${color}${out}${RST}"
}

# ── Elapsed % of a reset window ───────────────────────────────────────────────
# $1 seconds remaining (-1 = unknown), $2 window length in seconds.
elapsed_pct() {
  local remaining=$1 window=$2
  if (( remaining < 0 )); then printf '%s' -1; return; fi
  (( remaining > window )) && remaining=$window
  printf '%s' $(( (window - remaining) * 100 / window ))
}

# ── Seconds until a resets_at epoch, or -1 ────────────────────────────────────
secs_left() {
  local resets_at=$1 now=${EPOCHSECONDS:-$(date +%s)} s
  (( resets_at <= 0 )) && { printf '%s' -1; return; }
  s=$(( resets_at - now ))
  (( s < 0 )) && s=0
  printf '%s' "$s"
}

# ── One rate-limit segment: "5h ⣿⣿⣤ ┃    31% 1h54m" ──────────────────────────
rl_seg() {
  local label=$1 pct=$2 secs=$3 window=$4
  printf '%s' "${OVERLAY1}${label}${RST} $(bar "$pct" "$(elapsed_pct "$secs" "$window")") ${TEXT}$(pct_txt "$pct")${RST} ${OVERLAY1}$(secs_txt "$secs")${RST}"
}

join_line() {
  local line="" part
  for part in "$@"; do
    [[ -n "$line" ]] && line+="$SEP"
    line+="$part"
  done
  printf '%s\n' "$line"
}

# ── Render both lines from a JSON payload ─────────────────────────────────────
render() {
  local json="$1"
  local fields model effort dir wt repo ctx five wk five_at wk_at branch
  local w5=$(( 5 * 3600 )) w7=$(( 7 * 86400 )) s5 s7 seg

  fields=$(printf '%s' "$json" | jq -r '[
    (.model.display_name? // .model.id? // "claude"),
    (.effort.level? // ""),
    (.workspace.current_dir? // .cwd? // ""),
    (.workspace.git_worktree? // ""),
    (.workspace.repo.name? // ""),
    ((.context_window.used_percentage? // -1) | round),
    ((.rate_limits.five_hour.used_percentage? // -1) | round),
    ((.rate_limits.seven_day.used_percentage? // -1) | round),
    ((.rate_limits.five_hour.resets_at? // -1) | round),
    ((.rate_limits.seven_day.resets_at? // -1) | round)
  ] | map(tostring) | join("\u001f")' 2>/dev/null) \
    || { printf '%s\n' "${SURFACE1}claude${RST}"; return; }

  # unit separator, not tab: tab is IFS whitespace, so empty fields (e.g. no
  # worktree) would collapse and shift every field after them
  IFS=$'\x1f' read -r model effort dir wt repo ctx five wk five_at wk_at <<< "$fields"

  branch=""
  if [[ -n "$dir" ]]; then
    branch=$(command git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null) \
      || branch=$(command git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  fi

  if [[ -n "$branch" ]]; then
    local git_dir common_dir
    git_dir=$(command git -C "$dir" rev-parse --absolute-git-dir 2>/dev/null)
    common_dir=$(command git -C "$dir" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    # workspace.repo.name is parsed from the origin remote, so it is absent on
    # repos with no remote; the common dir is <repo>/.git even inside a
    # worktree, so its parent names the repo either way
    if [[ -z "$repo" && -n "$common_dir" ]]; then
      repo=$(basename "$(dirname "$common_dir")")
    fi
    # Claude Code fills workspace.git_worktree for linked worktrees, but only
    # once it knows about them; comparing git dirs catches the rest
    if [[ -z "$wt" && -n "$git_dir" && "$git_dir" != "$common_dir" ]]; then
      wt=$(basename "$(command git -C "$dir" rev-parse --show-toplevel 2>/dev/null)")
    fi
  fi

  # ── line 1: model │ repo │ branch │ worktree ────────────────────────────────
  local -a ident=()
  # No padding here: line 1 only shifts when you actively switch model or
  # /effort, so a fixed width would cost dead space on every render to hold a
  # column that never moves on its own.
  seg="${MAUVE}${ICON_MODEL}${RST}${IGAP}${MAUVE}${model}${RST}"
  [[ -n "$effort" ]] && seg+=" ${SURFACE2}[${SUBTEXT0}${effort}${SURFACE2}]${RST}"
  ident+=("$seg")
  [[ -n "$repo"   ]] && ident+=("${BLUE}${ICON_REPO}${RST}${IGAP}${BLUE}${repo}${RST}")
  [[ -n "$branch" ]] && ident+=("${TEAL}${ICON_BRANCH}${RST}${IGAP}${TEAL}${branch}${RST}")
  [[ -n "$wt"     ]] && ident+=("${LAVENDER}${ICON_WORKTREE}${RST}${IGAP}${LAVENDER}${wt}${RST}")

  # ── line 2: ctx │ 5h │ 7d ───────────────────────────────────────────────────
  local -a meters=()
  s5=$(secs_left "$five_at"); s7=$(secs_left "$wk_at")
  meters+=("${OVERLAY1}ctx${RST} $(ring "$ctx")")
  meters+=("$(rl_seg 5h "$five" "$s5" $w5)")
  meters+=("$(rl_seg 7d "$wk" "$s7" $w7)")

  join_line "${ident[@]}"
  join_line "${meters[@]}"
}

# ── Preview mode: sample states, using the real repo for branch info ─────────
preview() {
  local base now=${EPOCHSECONDS:-$(date +%s)}
  base=$(printf '{"model":{"display_name":"Opus 5"},"effort":{"level":"high"},"workspace":{"current_dir":"%s"}}' "$PWD")

  # 5h at 31% used with 1h54m left (62% elapsed), weekly 68% used / 80% elapsed
  printf 'on track\n'
  render "$(printf '%s' "$base" | jq --argjson now "$now" '. + {
    context_window:{used_percentage:42},
    rate_limits:{five_hour:{used_percentage:31, resets_at:($now + 6840)},
                 seven_day:{used_percentage:68, resets_at:($now + 118800)}}}')"
  # 5h at 91% used / 40% elapsed, weekly 76% used / 50% elapsed
  printf 'over pace\n'
  render "$(printf '%s' "$base" | jq --argjson now "$now" '.effort.level="xhigh"
    | .workspace.git_worktree="sl-work" | . + {
    context_window:{used_percentage:74},
    rate_limits:{five_hour:{used_percentage:91, resets_at:($now + 10800)},
                 seven_day:{used_percentage:76, resets_at:($now + 302400)}}}')"
  printf 'no data\n'
  render "$(printf '%s' "$base" | jq 'del(.effort)')"
}

if [[ "${1:-}" == "--test" || -t 0 ]]; then
  preview
  exit 0
fi

render "$(cat)"
