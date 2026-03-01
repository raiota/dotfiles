#!/usr/bin/env bash
# Claude Code - Stop hook
#
# stdin JSON shape:
#   { "hook_event_name": "Stop", "stop_hook_active": true }

OS="$(uname -s)"

case "$OS" in
  Darwin)
    osascript -e 'display notification "作業が完了しました" with title "Claude Code"'
    afplay /System/Library/Sounds/Hero.aiff
    ;;
  Linux)
    # TODO: implement with notify-send + paplay
    echo "[Claude Code] Stop hook: Linux not implemented" >&2
    ;;
  MINGW* | MSYS* | CYGWIN* | Windows_NT)
    # TODO: implement with PowerShell
    echo "[Claude Code] Stop hook: Windows not implemented" >&2
    ;;
  *)
    echo "[Claude Code] Stop hook: Unknown OS ($OS)" >&2
    ;;
esac
