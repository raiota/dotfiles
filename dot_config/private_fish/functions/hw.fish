function hw --description 'Open a ghq repository as a herdr workspace, or focus it if it is already open'
    # herdr のサーバーが動いていなければ、herdr のエラーを出してここで終わる
    set -l workspaces (herdr workspace list)
    or return

    # 引数は fzf の初期クエリ。候補が 1 件に絞れるときは、選択画面を出さずに開く（例: hw dotfiles）
    set -l repo (ghq list --full-path | fzf --select-1 --exit-0 --query "$argv" --prompt 'workspace> ')
    or return

    # workspace の名前はリポジトリ名にして、同じ名前のものが既にあればそこへ移動する
    set -l name (basename $repo)
    set -l id (printf '%s\n' $workspaces | jq -r --arg name $name 'first(.result.workspaces[] | select(.label == $name) | .workspace_id) // empty')

    if test -n "$id"
        herdr workspace focus $id >/dev/null
    else
        herdr workspace create --cwd $repo --label $name --focus >/dev/null
    end
end
