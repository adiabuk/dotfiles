platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
fi

alias vi='vim'
if [[ $platform == 'mac' ]]; then
  alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs -nw';
else
	[[ -f `which gvim 2>/dev/null` ]] && alias vim='gvim -v'
  alias emacs='emacs -nw'
fi

[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && \
	source /usr/share/doc/pkgfile/command-not-found.bash
eval $(dircolors)
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -l'
alias grep='grep --color'
alias ssh='ssh -Y'
alias json='python -mjson.tool'
alias xml='xmllint --format'
alias cdtmp='cd `mktemp -d /tmp/$USER-XXXXXX`'
alias webserver='python2 -mSimpleHTTPServer'
alias clipboard='xsel -i -b'
alias pastebin='~/bin/paste'
export LANG=en_US.UTF-8
export HISTFILESIZE=-1
export HISTSIZE=130000
export HISTCONTROL=ignoredups
export VISUAL=vim
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n"
export TERM=xterm-256color
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export vi='vim'
export PATH=$PATH:~/bin

export PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
eval "$(rbenv init -)"
source ~/git-completion.bash

function wt() {
        [ `which $1` ] && while true; do "$1"; done
}

## Powerline Shell 
## https://github.com/milkbikis/powerline-shell
function _update_ps1() {
    PS1="$(~/powerline-shell.py $? 2> /dev/null)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
##################################################
