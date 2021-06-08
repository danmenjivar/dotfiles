# bash.rc by Dan Menjivar

# Custom PS1 using bashrcgenerator.com
export PS1="\[\033[38;5;208m\]\u\[$(tput sgr0)\]:\[$(tput sgr0)\]\[\033[38;5;6m\][\[$(tput sgr0)\]\[\033[38;5;202m\]\w\[$(tput sgr0)\]\[\033[38;5;6m\]]\[$(tput sgr0)\]\\$ \[$(tput sgr0)\]"

## Aliases
alias ga="git add "
alias ..="cd .."
alias cddk="cd ~/Desktop/"
alias firefox="firefox &"
alias grep='grep --color=auto'
alias vi="vim"
alias lsl="ls -lh"
alias lst="ls -lht"
alias lss="ls -lhS"

