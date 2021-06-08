#  ________  ________  ________  ___  ___  ________  ________     
# |\   __  \|\   __  \|\   ____\|\  \|\  \|\   __  \|\   ____\    
# \ \  \|\ /\ \  \|\  \ \  \___|\ \  \\\  \ \  \|\  \ \  \___|    
#  \ \   __  \ \   __  \ \_____  \ \   __  \ \   _  _\ \  \       
#   \ \  \|\  \ \  \ \  \|____|\  \ \  \ \  \ \  \\  \\ \  \____  
#    \ \_______\ \__\ \__\____\_\  \ \__\ \__\ \__\\ _\\ \_______\
#     \|_______|\|__|\|__|\_________\|__|\|__|\|__|\|__|\|_______|
#                        \|_________|                             
# by Dan Menjivar

# disable ctrl-s and ctrl-1
stty -ixon

# cd into directory without needing to type cd
shopt -s autocd 

# enable vim mode
set -o vi # use `esc` to trigger

# set vim as default editor
export VISUAL=vim 
export EDITOR="$VISUAL"
alias vi="vim" # set vi to default to vim

# git status colors
COLOR_RED="\033[01;38;5;124m"
COLOR_YELLOW="\033[01;38;5;220m"
COLOR_GREEN="\033[01;38;5;40m"

function parse_git_color {
    local git_status="$(git status 2> /dev/null)"
    
    if [[ $git_status =~ "working directory clean" ]]; then
        echo -e $COLOR_GREEN
    elif [[ $git_status =~ "working tree clean" ]]; then
        echo -e $COLOR_GREEN
    elif [[ $git_status =~ "Changes to be committed" ]]; then
        echo -e $COLOR_YELLOW
    else
        echo -e $COLOR_RED
    fi
}

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
        COLOR=`parse_git_color`
		STAT=`parse_git_dirty`
		echo -e "$COLOR(${BRANCH}${STAT})"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# ls colors
# LS_COLORS=""
# export LS_COLORS
# alias="ls --color"

# custom PS1
# template for colors: \[\033[COLORm\]
# 01 = bold, 38;5 = foreground, 48;5 = background
# PS1="\[\033[01;38;5;39m\]\@ \[\033[01;38;5;15m\]% " # time (opt, add/remove + on next line) [blue foreground, bold]
PS1="\[\033[01;38;5;214m\]\u"   # current user [orange foreground, bold]
PS1+="\[\033[01;38;5;15m\]:"    # colon [white foreground, bold]
PS1+="\[\033[01;38;5;39m\]["    # `[` [blue foreground, bold]
PS1+="\[\033[01;38;5;15m\]\w"   # pwd [white foreground, bold]
PS1+="\[\033[01;38;5;39m\]]"    # `]` [blue foreground, bold]
PS1+="\`parse_git_branch\`"     # git status
PS1+="\[\033[01;38;5;39m\]$ "   # $ with space []
PS1+="\[$(tput sgr0)\]"         # reset stylings
export PS1

# aliases
alias ga="git add "
alias ..="cd .."
alias cddk="cd ~/Desktop/"
alias firefox="firefox &"
alias grep='grep --color=auto'
alias ls="ls --color=auto"
alias lst="ls -lht"