#!/bin/sh
# すべての workspace について、作業中のタブでフォーカスしているペイン（なければそのタブの最初のペイン）の
# 場所のブランチを調べ、ブランチアイコン（Nerd Font の U+E0A0）付きの名前を $git_branch として送る。git の管理下でなければ消す
set -eu
herdr=${HERDR_BIN_PATH:-herdr}
icon=$(printf "\356\202\240") # U+E0A0 を UTF-8 のバイトで書く

panes=$("$herdr" pane list)

"$herdr" workspace list | jq -r '.result.workspaces[] | [.workspace_id, .active_tab_id] | @tsv' |
  while IFS="$(printf '\t')" read -r ws tab; do
    cwd=$(printf '%s' "$panes" | jq -r --arg tab "$tab" '
      [.result.panes[] | select(.tab_id == $tab)] | (map(select(.focused)) + .)[0].foreground_cwd // empty')
    branch=$(git -C "${cwd:-/}" branch --show-current 2>/dev/null || true)
    if [ -n "$branch" ]; then
      "$herdr" workspace report-metadata "$ws" --source git-branch --token "git_branch=$icon $branch" >/dev/null
    else
      "$herdr" workspace report-metadata "$ws" --source git-branch --clear-token git_branch >/dev/null
    fi
  done
