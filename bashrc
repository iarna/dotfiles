[ -z "$PS1" ] && return

if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
elif [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -d ~/.bashrcd ]; then
	for a in ~/.bashrcd/*[^~]; do
		. "$a"
	done
fi

if [ -d ~/.bash_aliasesd ]; then
	for a in ~/.bash_aliasesd/*[^~]; do
		. "$a"
	done
fi
