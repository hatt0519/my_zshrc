RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
PROMPT="%{${fg[magenta]}%}%n$ %{${reset_color}%}"
autoload -U compinit
setopt prompt_subst
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

bindkey -v

setopt AUTO_CD

cdls () { \cd "$@" && ls }

alias ls='ls -GF'
alias cd="cdls"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias t='tmux'
alias ks='t kill-session'
alias list='t list-session'

setopt share_history

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

function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}
tmux_automatically_attach_session

HISTSIZE=100000
SAVEHIST=100000

export PATH=$HOME/.nodebrew/current/bin:$PATH
