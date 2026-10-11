function hdl --description 'herdr dev layout: editor on the left, agents on the right, a small shell below'
    # Omarchy の hdl（https://github.com/basecamp/omarchy default/bash/fns/herdr）を fish に移したもの。
    # 比率も同じで、下 15% がシェル、残りの右 30% がエージェント。
    #   hdl              右に claude
    #   hdl claude agy   右を上下に割って、2 つ目のエージェントも起動する
    if not set -q HERDR_PANE_ID
        echo 'hdl: run this inside a herdr pane' >&2
        return 1
    end

    set -l ai $argv[1]
    test -n "$ai"; or set ai claude
    set -l ai2 $argv[2]
    set -l dir $PWD
    set -l editor_pane $HERDR_PANE_ID

    herdr tab rename $HERDR_TAB_ID (basename $dir) >/dev/null

    herdr pane split $editor_pane --direction down --ratio 0.85 --cwd $dir --no-focus >/dev/null
    or return
    set -l ai_pane (herdr pane split $editor_pane --direction right --ratio 0.7 --cwd $dir --no-focus | jq -r '.result.pane.pane_id')
    test -n "$ai_pane"; or return 1

    if test -n "$ai2"
        set -l ai2_pane (herdr pane split $ai_pane --direction down --ratio 0.5 --cwd $dir --no-focus | jq -r '.result.pane.pane_id')
        test -n "$ai2_pane"; and herdr pane run $ai2_pane $ai2 >/dev/null
    end
    herdr pane run $ai_pane $ai >/dev/null

    # このペインがエディタになる
    nvim .
end
