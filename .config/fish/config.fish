set fish_greeting ""

# path
fish_add_path $HOME/.local/bin


# aliases

if type -q eza
  alias ll "eza -al --git --icons --time-style relative"
  alias lla "ll -a"
end

if type -q lazygit
  alias lg "lazygit"
end

function cd
  builtin cd $argv

  if type -q eza
    lla
  else
    ls -al
  end
end

if type -q starship
    starship init fish | source
    set -gx STARSHIP_CONFIG ~/.config/starship.toml
end

# rtx
rtx activate fish | source
rtx hook-env -s fish | source  # プラグインのパスを追加する
rtx complete -s fish | source  # rtxの補完を追加

fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --processes=\cp