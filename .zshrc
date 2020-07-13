# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=500
SAVEHIST=500
setopt notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# alias ccol=$HOME/.scripts/change_color_temp
# alias cr='cargo run'
alias lsc="ls --color=auto"
alias tmux='TERM=screen-256color tmux' # Make truecolor play nice with Alacritty and Tmux

fpath=($fpath "/home/smolck/.zfunctions")
fpath+=$HOME/.zsh/typewritten

autoload -U promptinit; promptinit
prompt typewritten

(go run personal-projects/biblegateway-verse-of-day &) &> /dev/null
export VERSEOFDAY=$(cat .verse-of-day)
