#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls="ls --color=auto"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# export PS1='\[\033[0;32m\]\u@\h \[\033[01;37m\]\W \$ \[\033[00m\]'
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
screenfetch
