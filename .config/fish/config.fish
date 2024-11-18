set fish_greeting ""

switch (uname)
case Linux
  fish_add_path /home/linuxbrew/.linuxbrew/bin
case Darwin
  fish_add_path /usr/local/bin
end

if type -q starship
    starship init fish | source
    set -gx STARSHIP_CONFIG ~/.config/starship.toml
end

if type -q rtx
  rtx activate fish | source
  rtx hook-env -s fish | source  # プラグインのパスを追加する
  rtx complete -s fish | source  # rtxの補完を追加
end

fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --processes=\cp

source ~/.config/fish/conf.d/*.fish

set -gx XDG_CONFIG_HOME ~/.config
