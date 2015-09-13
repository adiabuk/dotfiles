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
  alias emacs='emacs -nw'
fi

alias ll='ls -l'
alias json='python -mjson.tool'
alias xml='xmllint --format'
alias cdtmp='cd `mktemp -d /tmp/$USER-XXXXXX`'

export LANG=en_US.UTF-3
export HISTFILESIZE=-1
export HISTSIZE=130000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n"
export TERM=xterm-256color
ex[prt vi='vim'
