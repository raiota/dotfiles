#====================#
# default config     #
#====================#

# cd + ls
function cd
  builtin cd $argv
  ls -la
end

#====================#
# path setting       #
#====================#
set -U fish_user_paths /usr/local/bin $fish_user_paths

#====================#
# bobthefish config  #
#====================#

# ブランチ名の表示
set -g theme_display_git_master_branch yes

# ディレクトリを非省略
set -g fish_prompt_pwd_dir_length 0

# promptを改行
#set -g theme_newline_cursor yes

#====================#
# peco config        #
#====================#
# peco's layout to bottom-up
function peco
  command peco --layout=bottom-up $argv
end

# oh-my-fish/plugin-pecoの設定
function fish_user_key_bindings
  bind \cr peco_select_history    # Bind for prco history to Ctrl+r
end

#====================#
# ghq config         #
#====================#
# decors/fish-ghqの設定
set GHQ_SELECTOR peco