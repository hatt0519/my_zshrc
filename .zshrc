RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"

autoload -Uz vcs_info
autoload -U compinit
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'
cdls () { \cd "$@" && ls }

alias cd="cdls"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'

setopt share_history
setopt auto_cd

export PATH=/usr/local:$PATH
fpath=(/usr/local/share/zsh-completions $fpath)
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH" 
eval "$(rbenv init - zsh)"
export PATH=/usr/local/mecab/bin:$PATH
export ANDROID_HOME=/Users/kazuki.hattori/Library/Android/sdk
export PATH=$PATH:${ANDROID_HOME}/platforms:${ANDROID_HOME}/tools
export PATH=$PATH:${ANDROID_HOME}/platform-tools

export LANG=ja_JP.UTF-8

HISTSIZE=100000
SAVEHIST=100000
