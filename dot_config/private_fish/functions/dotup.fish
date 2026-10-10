function dotup --description 'Update the mise tools, then commit and push the lock'
    # 公開から 3 日たっていない版は、mise の config.toml（minimum_release_age）が自動で避ける。
    # 更新するのは 1 台だけにする。ほかのマシンは chezmoi update で同じ版を入れる。
    set -l src (chezmoi source-path); or return
    set -l dir dot_config/mise
    set -l branch (git -C $src branch --show-current)
    if test "$branch" != main
        echo "dotup: the chezmoi source is on '$branch', not main" >&2
        return 1
    end

    # ほかのマシンや Dependabot の変更を取り込み、ソースの config.toml と lock をホームに書く
    git -C $src pull --ff-only; or return
    chezmoi apply ~/.config/mise; or return

    # mise は今いる場所のプロジェクト設定も拾うので、ホームで動かす
    mise -C ~ install; or return
    if not mise -C ~ upgrade --dry-run-code
        # 上がるものがあるので、上の一覧を見てから進める
        if isatty stdin
            read -l -P 'dotup: upgrade, commit and push? [Y/n] ' answer; or return 1
            string match -qir '^n' -- $answer; and return 0
        end
        mise -C ~ upgrade; or return
    end
    # 新しい版の、ほかのプラットフォーム（WSL の linux-x64 など）の分も埋める
    mise -C ~ lock --global; or return

    chezmoi re-add ~/.config/mise/mise.lock; or return
    # npm などの依存グラフ（sidecar）を mise が書くようになったら、それも配る
    if test -d ~/.config/mise/locks
        chezmoi add ~/.config/mise/locks; or return
    end

    git -C $src add -A -- $dir; or return
    if git -C $src diff --cached --quiet -- $dir
        echo 'dotup: nothing to commit'
        return 0
    end
    set -l changes (__dotup_version_changes $src $dir/private_mise.lock)
    test -n "$changes"; or set changes '- refresh the lock entries'
    printf '%s\n' $changes
    # ( ) で受けると改行ごとに別の引数に分かれるので、メッセージは標準入力で渡す
    printf '%s\n' 'chore: [mise] update tools' '' $changes | git -C $src commit -q -F - -- $dir; or return
    git -C $src push
end

# HEAD と作業ツリーの mise.lock を比べて、版が変わったツールを 1 行ずつ出す
function __dotup_version_changes --argument-names src lock
    git -C $src show HEAD:$lock | awk '
        FNR == 1 { file++ }
        /^\[\[tools\./ {
            name = $0
            sub(/^\[\[tools\./, "", name); sub(/\]\]$/, "", name); gsub(/"/, "", name)
            next
        }
        /^version = / && name != "" {
            v = $3; gsub(/"/, "", v)
            if (file == 1) old[name] = v; else new[name] = v
            name = ""
        }
        END {
            for (n in new) {
                if (!(n in old)) printf "- %s: added %s\n", n, new[n]
                else if (old[n] != new[n]) printf "- %s: %s -> %s\n", n, old[n], new[n]
            }
            for (n in old) if (!(n in new)) printf "- %s: removed\n", n
        }
    ' - $src/$lock | sort
end
