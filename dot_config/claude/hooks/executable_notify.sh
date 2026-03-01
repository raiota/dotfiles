#!/usr/bin/env bash
# Claude Code - Notification hook
#
# stdin JSON shape:
#   { "type": "notification", "message": "...", "hook_event_name": "Notification" }
# Matchers: permission_prompt | idle_prompt | auth_success | elicitation_dialog

OS="$(uname -s)"

case "$OS" in
  Darwin)
    osascript -e 'display notification "通知があります" with title "Claude Code"'
    afplay /System/Library/Sounds/Ping.aiff
    ;;
  Linux)
    # TODO: implement with notify-send + paplay
    echo "[Claude Code] Notification hook: Linux not implemented" >&2
    ;;
  MINGW* | MSYS* | CYGWIN* | Windows_NT)
    # TODO: implement with PowerShell
    echo "[Claude Code] Notification hook: Windows not implemented" >&2
    ;;
  *)
    echo "[Claude Code] Notification hook: Unknown OS ($OS)" >&2
    ;;
esac
