# vi:syntax=sh
#  ________  ________  ________  ___  ___  ________  ________     
# |\   __  \|\   __  \|\   ____\|\  \|\  \|\   __  \|\   ____\    
# \ \  \|\ /\ \  \|\  \ \  \___|\ \  \\\  \ \  \|\  \ \  \___|    
#  \ \   __  \ \   __  \ \_____  \ \   __  \ \   _  _\ \  \       
#   \ \  \|\  \ \  \ \  \|____|\  \ \  \ \  \ \  \\  \\ \  \____  
#    \ \_______\ \__\ \__\____\_\  \ \__\ \__\ \__\\ _\\ \_______\
#     \|_______|\|__|\|__|\_________\|__|\|__|\|__|\|__|\|_______|
#                        \|_________|                             
# By Dan Menjivar
# Must have bash v.4 or higher
# Inspired in part by: https://github.com/mrzool/bash-sensible/blob/master/sensible.bash

############################
#     GENERAL OPTIONS      #
############################

# Disable ctrl-s and ctrl-1
stty -ixon

# Enable vim mode
# set -o vi # use `esc` to trigger

# Set vim as default editor
export VISUAL=vim 
export EDITOR="$VISUAL"
alias vi="vim"

# Load external aliases
if [ -f ~/.aliases ]; then
	source ~/.aliases
fi

# Prevent overwriting file on stdout redirection
# Use `>|` to force redirection to an existing file
shopt -qo noclobber 

# Update window size after every command
shopt -s checkwinsize

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Turn on recursive globbing (enables ** to recurse all directories)
# shopt -s globstar 2> /dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;


############################
#      TAB COMPLETION      #
############################

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

# Perform tab completion for Git
if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash 
fi
# Source: https://pagepro.co/blog/autocomplete-git-commands-and-branch-names-in-terminal/


############################
#   DIRECTORY NAVIGATION   #
############################

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null

# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
CDPATH="."

# This allows you to bookmark your favorite places across the file system
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
shopt -s cdable_vars
# Examples:
export dotfiles="$HOME/.dotfiles"
export projects="$HOME/the_odin_project"
# export documents="$HOME/Documents"
# export dropbox="$HOME/Dropbox"


############################
#      HISTORY OPTIONS     #
############################
# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Record each line as it gets issued
PROMPT_COMMAND='history -a'

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:refresh"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'


############################
#        GIT ON PS1        #
############################

function parse_git_color() {
    local git_status="$(git status 2> /dev/null)"
	COLOR_RED="\033[01;38;5;160m"
	COLOR_YELLOW="\033[01;38;5;220m"
	COLOR_GREEN="\033[01;38;5;40m"
    
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

function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_status`
		DIST=`parse_origin_dist`
		echo -e "(${BRANCH}${DIST}${STAT})"
	else
		echo ""
	fi
}

function parse_git_status() {
	status=$(git status -s 2> /dev/null)
	add=$(echo "$status" | grep '??' | wc -l | tr -d '[[:space:]]')
	del=$(echo "$status" | grep 'D' | wc -l | tr -d '[[:space:]]')
	mod=$(echo "$status" | grep 'M' | wc -l | tr -d '[[:space:]]')
	stats=''

	# untracked files count 
	if [ $add != 0 ]; then
		stats="${add}U "
	fi

	# removed files count 
	if [ $del != 0 ]; then
		stats="${stats}${del}D "
	fi
	
	# mod files count 
	if [ $mod != 0 ]; then
		stats="${stats}${mod}M"
	fi
	
	if [ ! -z "$stats" ]; then
		stats="|${stats}"
	fi

	echo "$stats"
}

function parse_origin_dist() {
	status="$(git status 2> /dev/null)"
	dist=""

	is_ahead=$(echo -n "$status" | grep "ahead")
	is_behind=$(echo -n "$status" | grep "behind")

	if [ ! -z "$is_ahead"  ]; then
		dist_val=$(echo "$is_ahead" | sed 's/[^0-9]*//g')
		dist="↑${dist_val}"
	fi

	if [ ! -z "$is_behind" ]; then
		dist_val=$(echo "$is_behind" | sed 's/[^0-9]*//g')
		dist="↓${dist_val}"	
	fi

	if [ ! -z "$dist" ]; then
		echo "${dist}"
	fi
}


############################
#      CUSTOM LS COLORS    #
############################
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    LS_COLORS="fi=:" 		# file 			- 
    LS_COLORS+="di=1;33:" 	# directory     	- bold, yellow/orange
    LS_COLORS+="ln=4;35:" 	# symbolic link 	- underlined magenta
    LS_COLORS+="so=36:"		# socket        	- cyan
    LS_COLORS+="pi=4;33:"  	# named pipe (PIPO) 	- underlined orange/yellow
    LS_COLORS+="ex=32:"		# executable 		- green
    LS_COLORS+="bd=34;46:"	# block device 		- blue with cyan background
    LS_COLORS+="cd=34;43:"	# character device 	- blue with orange background
    LS_COLORS+="su=30;41:"	# set uid 		- black with red background
    LS_COLORS+="sg=30;46:"	# set gid 		- black with cyan background
    LS_COLORS+="tw=30;42:"	# sticky other writable - black with green background
    LS_COLORS+="ow=30;43:"	# other writable 	- black with orange background
    # LS_COLORS+="*.jpg=30;43"	# JPGs (example for adding other file extensions)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    LS_COLORS="exfxcxdxbxegedabagacad"
fi
export LS_COLORS
# For more info: https://www.howtogeek.com/307899/how-to-change-the-colors-of-directories-and-files-in-the-ls-command/
# & https://gist.github.com/thomd/7667642 


############################
#         CUSTOM PS1       #
############################

COLOR_BLUE="\033[01;38;5;39m"
COLOR_ORANGE="\033[01;38;5;208m"
COLOR_WHITE="\033[01;38;5;15m"
# Template for colors: \[\033[COLORm\]
# 01 = bold, 38;5 = foreground, 48;5 = background
# Colors chart: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors 

PS1="\n"										# newline
# PS1="\[$COLOR_ORANGE\]\@ \[$COLOR_WHITE\]% " 	# time (opt, add/remove + on next line)
PS1+="\[$COLOR_ORANGE\]\u"   					# current user [orange foreground, bold]
PS1+="\[$COLOR_WHITE\]:"    					# colon [white foreground, bold]
PS1+="\[$COLOR_BLUE\]["    						# `[`
PS1+="\[$COLOR_WHITE\]\w"   					# full working path [white foreground, bold] (Note: `PROMPT_DIRTRIM=2` will trim these)
# PS1+="\[$COLOR_WHITE\]\W"   					# pwd [white foreground, bold]
PS1+="\[$COLOR_BLUE\]]"    						# `]`
PS1+="\[\$(parse_git_color)\]"					# colorize git status
PS1+="\`parse_git_branch\`"     				# git status
PS1+="\[$COLOR_BLUE\]$ "   						# $ with space []
PS1+="\[$(tput sgr0)\]"         				# reset stylings
export PS1
