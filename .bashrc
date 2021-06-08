#     | |__   __ _ ___| |__  _ __ ___ 
#     | '_ \ / _` / __| '_ \| '__/ __|
#     | |_) | (_| \__ \ | | | | | (__ 
#     |_.__/ \__,_|___/_| |_|_|  \___|
# by Dan Menjivar


# cd into directory without needing to type cd
shopt -s autocd 

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "(${BRANCH}${STAT})"
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


# Custom PS1
PS1="\[\033[01;38;5;214m\]\u"   # current user [orange foreground, bold]
PS1+="\[\033[01;38;5;15m\]:"    # colon [white foreground, bold]
PS1+="\[\033[01;38;5;39m\]["    # `[` [blue foreground, bold]
PS1+="\[\033[01;38;5;15m\]\w"   # pwd [white foreground, bold]
PS1+="\[\033[01;38;5;39m\]]"    # `]` [blue foreground, bold]
PS1+="\[\033[01;38;5;39m\]$ "   # $ with space []
PS1+="\[$(tput sgr0)\]"         # reset stylings

# PS1+="\`parse_git_branch\`"                         # git status
export PS1

# ls file bolder
LS_COLORS=$LS_COLORS:"di:1;"
export LS_COLORS


## Aliases
alias ga="git add "
alias ..="cd .."
alias cddk="cd ~/Desktop/"
alias firefox="firefox &"
alias grep='grep --color=auto'
alias vi="vim"
alias lst="ls -lht"