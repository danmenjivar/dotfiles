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
# set -o vi # use `esc` to trigger

# set vim as default editor
export VISUAL=vim 
export EDITOR="$VISUAL"
alias vi="vim" # set vi to default to vim

# git status colors
COLOR_RED="\033[01;38;5;160m"
COLOR_YELLOW="\033[01;38;5;220m"
COLOR_GREEN="\033[01;38;5;40m"
# see PS1 for how to setup colors

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
		STAT=`parse_git_dirty`
		echo -e "(${BRANCH}${STAT})"
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
# for more info: https://www.howtogeek.com/307899/how-to-change-the-colors-of-directories-and-files-in-the-ls-command/
# and https://gist.github.com/thomd/7667642 
# LS_COLORS="fi=:" 		# file 						- 
LS_COLORS="di=1:" 		# directory     			- bold
LS_COLORS+="ln=4;35:" 	# symbolic link 			- underlined magenta
LS_COLORS+="so=36:"		# socket        			- cyan
LS_COLORS+="pi=33:"  	# named pipe (PIPO) 		- orange/yellow
LS_COLORS+="ex=32:"		# executable 				- green
LS_COLORS+="bd=34;46:"	# block device 				- blue with cyan background
LS_COLORS+="cd=34;43:"	# character device 			- blue with orange background
LS_COLORS+="su=30;41:"	# set uid 					- black with red background
LS_COLORS+="sg=30;46:"	# set gid 					- black with cyan background
LS_COLORS+="tw=30;42:"	# sticky other writable 	- black with green background
LS_COLORS+="ow=30;43:"	# other writable 			- black with orange background
# LS_COLORS+="*.jpg=30;43"	# JPGs (example for adding other file extensions)
export LS_COLORS
alias="ls --color"

# custom PS1
COLOR_BLUE="\033[01;38;5;39m"
COLOR_ORANGE="\033[01;38;5;208m"
COLOR_WHITE="\033[01;38;5;15m"
# template for colors: \[\033[COLORm\]
# 01 = bold, 38;5 = foreground, 48;5 = background
# colors chart: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors 

PS1="\[$COLOR_ORANGE\]\@ \[$COLOR_WHITE\]% " 	# time (opt, add/remove + on next line)
PS1="\[$COLOR_ORANGE\]\u"   					# current user [orange foreground, bold]
PS1+="\[$COLOR_WHITE\]:"    					# colon [white foreground, bold]
PS1+="\[$COLOR_BLUE\]["    						# `[`
PS1+="\[$COLOR_WHITE\]\W"   					# pwd [white foreground, bold]
PS1+="\[$COLOR_BLUE\]]"    						# `]`
PS1+="\[\$(parse_git_color)\]"					# colorize git status
PS1+="\`parse_git_branch\`"     				# git status
PS1+="\[$COLOR_BLUE\]$ "   						# $ with space []
PS1+="\[$(tput sgr0)\]"         				# reset stylings
export PS1

# git completion
if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash 
fi
# source: https://pagepro.co/blog/autocomplete-git-commands-and-branch-names-in-terminal/

# aliases
alias ga="git add "
alias ..="cd .."
alias cddk="cd ~/Desktop/"
alias firefox="firefox &"
alias grep='grep --color=auto'
alias ls="ls --color=auto"
alias lst="ls -lht"
