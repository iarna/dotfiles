alias dir='ls -l'
alias jeo=joe
alias vm=mv
alias mf=mv
alias grpe=grep
alias cpanm='cpanm -nS --skip-installed'
alias less='less -ReX'
alias pear='sudo `which pear`'
alias pyrus='sudo `which pyrus`'
alias co='git checkout'
alias rebase='git rebase'
alias branch='git branch'
alias add='git add'
alias commit='git commit'
alias reset='git reset'
alias del-branch='git del-branch'
alias publish-branch='git publish-branch'

open="$(which gnome-open)"
if [ -x "$open" ]; then
	alias open="$open"
fi
if [ -d "/Applications/GIMP.app" ]; then
	alias gimp="open -a /Applications/GIMP.app"
fi

if [ -x "$(which dircolors)" ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

function total () {
        unset $_total
        while read num; do
		if [ ."$num" != "." ]; then
	                _total=$[$_total+$num]
		fi
        done
        echo $_total
        unset _total
}

function usephp () {
	eval $(sudo /home/turner/bin/usephp $@)
}
