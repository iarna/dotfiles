[ -z "$PS1" ] && return

source /etc/bash.bashrc

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    # Store some color related variables for use later
    COLOR_RESET=$(tput sgr0)
    COLOR_LIGHT_GREEN=$(tput setaf 2 && tput bold)
    COLOR_LIGHT_WHITE=$(tput setaf 7 && tput bold)
    COLOR_LIGHT_YELLOW=$(tput setaf 3 && tput bold)
    COLOR_LIGHT_BLUE=$(tput setaf 4 && tput bold)
else
    color_prompt=
fi

GIT_PS1_SHOWDIRTYSTATE=1

# A function that returns the current git branch, suitable for embedding in a prompt
function current_branch {
    branch_prompt=`__git_ps1 "[%s] "`
    branch_color=
    branch_reset=
    local w
    local i
    if [ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
        if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ]; then
            if [ "$(git config --bool bash.showDirtyState)" != "false" ]; then
                git diff --no-ext-diff --quiet --exit-code || w="*"
                if git rev-parse --quiet --verify HEAD >/dev/null; then
                    git diff-index --cached --quiet HEAD -- || i="+"
                else
                    i="#"
                fi
            fi
        fi
	if [ -n "$w" ]; then
            branch_color=$COLOR_LIGHT_YELLOW
            branch_reset=$COLOR_RESET
	elif [ -n "$i" ]; then
            branch_color=$COLOR_LIGHT_WHITE
            branch_reset=$COLOR_RESET
	fi
    fi
}

export PROMPT_COMMAND=current_branch

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\['$COLOR_LIGHT_GREEN'\]\u@\h\['$COLOR_RESET'\]:\['$COLOR_LIGHT_BLUE'\]\w\['$COLOR_RESET'\]\$ \[${branch_color}\]${branch_prompt}\[${branch_reset}\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ ${branch_prompt}'
fi
unset force_color_prompt 

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
screen )
    PS1="\[\e]1;\h\a\e]2;[$SCREEN_NAME] \u@\h (\w) {\j}\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR="joe"
export VISUAL="joe"
export CVS_RSH=ssh
export CPAN=ftp://ftp.cpan.org/CPAN

if [ -d "~/.bashrcd" ]; then
	for a in .bashrcd/*[^~]; do
		. "$a"
	done
fi

if [ -d "~/.bash_aliasesd" ]; then
	for a in .bash_aliasesd/*[^~]; do
		. "$a"
	done
fi
