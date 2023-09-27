set fish_greeting ""

# path
fish_add_path $HOME/.local/bin


# aliases

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

function cd
  builtin cd $argv

  if type -q exa
    lla
  end

  if type -q poetry; and test -e pyproject.toml
    poetry shell
  end
end


if type -q nvim
  alias vim "nvim"
end


if type -q starship
    starship init fish | source
    set -gx STARSHIP_CONFIG ~/.config/starship.toml
end

# rtx
rtx activate fish | source
rtx hook-env -s fish | source  # プラグインのパスを追加する
rtx complete -s fish | source  # rtxの補完を追加
