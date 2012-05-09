# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"$PATH"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f ~/.bashrc ]; then
	. ~/.bashrc
    fi

    if [ -d ~/.bash_profiled ]; then
            for a in ~/.bash_profiled/*[^~]; do
                    . $a
            done
    fi
fi
