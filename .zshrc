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

# alias dotnet='$HOME/dotnet/dotnet'
alias rice='clear && neofetch'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# alias ccol=$HOME/.scripts/change_color_temp
# alias cr='cargo run'
alias lsc="ls --color=auto"
alias tmux='TERM=screen-256color tmux' # Make truecolor play nice with Alacritty and Tmux
alias icat='kitty +kitten icat'

fpath=($fpath "$HOME/.zfunctions")
fpath+=$HOME/.zsh/typewritten

autoload -U promptinit; promptinit
prompt typewritten

(go run personal-projects/biblegateway-verse-of-day &) &> /dev/null
export VERSEOFDAY=$(cat ~/.verse-of-day)
fpath=($fpath "$HOME/.zfunctions")

  # Set Spaceship ZSH as a prompt
  autoload -U promptinit; promptinit
  prompt spaceship

# opam configuration
test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fpath=($fpath "$HOME/.zfunctions")
fpath=($fpath "$HOME/.zfunctions")

# . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# export ZSH_AUTOSUGGEST_STRATEGY=completion
# export ZSH_AUTOSUGGEST_USE_ASYNC=
# export ZSH_AUTOSUGGEST_MANUAL_REBIND=
# . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
