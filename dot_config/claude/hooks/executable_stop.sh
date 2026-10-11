#!/usr/bin/env bash
# Claude Code - Stop hook
#
# stdin JSON shape:
#   { "hook_event_name": "Stop", "stop_hook_active": true }

# herdr のペインの中では、エージェントが止まった・終わったことを herdr が知らせる
# （~/.config/herdr/config.toml の [ui.toast] と音）ので、二重に鳴らさない
[ "${HERDR_ENV:-}" = "1" ] && exit 0

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
