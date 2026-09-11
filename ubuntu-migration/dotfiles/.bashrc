#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"
. /home/nplong/.cargo/env

# Created by `pipx` on 2026-07-24 12:19:15
export PATH="$PATH:/home/nplong/.local/bin"
. /home/nplong/export-esp.sh

# Qwen Code PATH block begin
export PATH='/home/nplong/.local/bin':$PATH
# Qwen Code PATH block end


# Added by Antigravity CLI installer
export PATH="/home/nplong/.local/bin:$PATH"
