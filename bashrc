
# Determine if Mac or Linux
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
else
	platform='unknown'
fi

# How to start vim
alias vi='vim'
if [[ $platform == 'mac' ]]; then
  alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs -nw';
else
	# only alias if gvim exists
	[[ -f $(which gvim 2>/dev/null) ]] && alias vim='gvim -v'
  alias emacs='emacs -nw'
fi

# command completion
[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && \
	source /usr/share/doc/pkgfile/command-not-found.bash
source ~/git-completion.bash # git completion

eval "$(dircolors)" # show files and directories with std colors

# aliases
alias ls='ls --color=auto --group-directories-first' # use color and group dirs
alias ll='ls -l'
alias grep='grep --color' # use color in grep
alias ssh='ssh -Y' # X11 forwarding for vim yank to clipboard
[[ $platform == "Linux" ]] && alias open='xdg-open' # don't do on mac
alias json='python -mjson.tool' # pretty print json from stdin
alias xml='xmllint --format' # pretty print xml from stdin
alias cdtmp='cd `mktemp -d /tmp/$USER-XXXXXX`' # create and enter new tmp dir
alias webserver='python2 -mSimpleHTTPServer' # start a weberver (port as arg)
alias clipboard='xsel -i -b' # send stdin to clipboard
alias pastebin='~/bin/paste' # send stdin to pastebin

# bash history
export HISTFILESIZE=-1 # Number of lines on disk ~/.bash_history
export HISTSIZE=130000 # Number of lines in memory
export HISTCONTROL=ignoredups
export PROMPT_COMMAND="history -a; history -n"
shopt -s histappend

export VISUAL=vim
export LANG=en_US.UTF-8
export TERM=xterm-256color

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

setxkbmap -option terminate:ctrl_alt_bksp # alt+ctl+backsp to kill X11

# for ruby
export PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
eval "$(rbenv init -)"


# functions
function wt() {
	# loop command until interrupted
	[ "$(which "$1")" ] && while true; do "$1"; done
}

## Powerline Shell 
## https://github.com/milkbikis/powerline-shell
function _update_ps1() {
	# update PS1 for powerline
	PS1="$(~/powerline-shell.py $? 2> /dev/null)"
}

if [ "$TERM" != "linux" ]; then
	PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
else
# fallback PS1
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]
\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

fi
##################################################
