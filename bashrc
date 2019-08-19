[ -z "$PS1" ] && return
if [ -z "$BASHRCLOADED" ]; then
	# Support both Debian/Ubuntu and OSX bashrc naming conventions
	if [ -f /etc/bash.bashrc ]; then
		. /etc/bash.bashrc
	elif [ -f /etc/bashrc ]; then
		. /etc/bashrc
	fi

	if [ -z "$BASH_COMPLETION" ]; then
		if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
			. /etc/bash_completion
		elif [ -d /etc/bash_completion.d ]; then
			. ~/.base_bash_completion
		fi
	fi

	export NVS_HOME="$HOME/.nvs"
	if [ -s "$NVS_HOME/nvs.sh" ]; then
		. "$NVS_HOME/nvs.sh"
		nvs use latest
	fi

	if [ -d ~/.bashrcd ]; then
		for a in ~/.bashrcd/*[^~]; do
			. "$a"
		done
	fi

	export BASHRCLOADED=1
fi

if [ -d ~/.bash_aliasesd ]; then
	for a in ~/.bash_aliasesd/*[^~]; do
		. "$a"
	done
fi
