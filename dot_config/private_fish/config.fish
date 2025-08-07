# Alias
alias ll "eza -al --git --icons --time-style relative"
alias lla "ll -a"
alias lg "lazygit"

function cd
  builtin cd $argv
  if type -q eza
    lla
  else
    ls -al
  end
end

# Setup Tools
command -v starship > /dev/null; and starship init fish | source
if type -q fzf_configure_bindings
    fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --processes=\cp
end

# Paths
#   * uv
fish_add_path "/Users/toa34886/.local/bin"

# Environment Variables
set -g theme_color_scheme "Catppuccin Mocha"
set -gx XDG_CONFIG_HOME ~/.config
set fzf_preview_dir_cmd lla --color=always
set fzf_fd_opts --no-ignore
set fzf_diff_highlighter delta --paging=never --width=20
set fzf_history_time_format %a %Y-%m-%d %H:%M
set -g GHQ_SELECTOR fzf
set -g EZA_CONFIG_DIR ~/.config/eza

