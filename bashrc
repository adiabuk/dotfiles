#!/bin/bash
# vim: fdm=marker
# shellcheck disable=SC1091,SC1090

# {{{ Determine if Mac or Linux
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
else
  platform='unknown'
fi
# }}}

# {{{ Autostart ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-thing)"
fi
# }}}

#{{{ How to start vim
alias vi='vim'
if [[ $platform == 'mac' ]]; then
  alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs -nw';
else
  # only alias if gvim exists
  [[ -f $(which gvim 2>/dev/null) ]] && alias vim='gvim -v'
  alias emacs='emacs -nw'

fi
# }}}

#{{{ command completion
[[ -f "$HOME"/bin/git-completion.bash ]] && \
  source "$HOME"/bin/git-completion.bash # git completion
# }}}

# {{{ aliases
alias cls='clear'
alias vim100='vim -c "set colorcolumn=101"'
alias xemacs='emacs-25.2 '
alias lists='xemacs ~/repos/personal/org-mode/remember.org ~/repos/personal/org-mode/todo.org &'
alias progress="watch -n1 '~/repos/personal/org-mode/progress.sh'"

# use color and group dirs
alias ls="ls --color=auto --group-directories-first --ignore=*.pyc"
alias ll="ls -l"
alias grep="grep --color" # use color in grep
alias ssh="ssh -Y" # X11 forwarding for vim yank to clipboard
[[ $platform == "linux" ]] && alias open="xdg-open" # don"t do on mac
alias json="python -mjson.tool" # pretty print json from stdin
alias json2="jq"  # another json formatter
alias xml="xmllint --format" # pretty print xml from stdin
alias cdtmp="cd $(mktemp -d /tmp/"$USER"-XXXXXX)" # create and enter new tmp dir
alias webserver="python2 -mSimpleHTTPServer" # start a weberver (port as arg)
alias clipboard="xsel -i -b" # send stdin to clipboard
alias pastebin="~/bin/paste" # send stdin to pastebin
alias hdmi_on="xrandr --output HDMI1 --mode 1920x1080 --right-of eDP1"
alias hdmi_off="xrandr --output HDMI1 --off"
alias sudo="sudo "
alias pacman="pacwait"
alias col_sum="awk '{s+=\$NF} END {print s}" # FIXME - read in arg for col num
alias df="df -t ext3 -t ext4 --total"
alias which="which_function"
alias pip26="sudo python2.6 /usr/bin/pip2"
alias per="cd ~/repos/personal"
alias eq="cd ~/repos/equinix"
alias less="less -R"  # parse control characters
alias f5vpn-login="ut f5vpn-login"
alias tidy="tidy -config ~/tidy_config.txt"
# }}}

# {{{ bash history
export HISTFILESIZE=-1 # Number of lines on disk ~/.bash_history
export HISTSIZE=130000 # Number of lines in memory
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:cd:exit:clear"
export PROMPT_COMMAND="history -a; history -r; history -n"
PROMPT_COMMAND="history -a;history -c; history -r;$PROMPT_COMMAND"
shopt -s cmdhist
shopt -s histappend
shopt -s checkwinsize
# }}}

# {{{ vars
export VISUAL=vim
export LANG=en_GB.UTF-8
eval "$(dircolors)" # show files and directories with std colors

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -f /usr/bin/setxkbmap ]; then
  setxkbmap -option terminate:ctrl_alt_bksp # alt+ctl+backsp to kill X11
fi
# }}}

# {{{for ruby
#export PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH:$HOME/.gem/ruby/2.3.0/bin
export PATH=$HOME/.rbenv/versions/2.1.8/bin:$PATH
if [ -f /usr/bin/rbenv ]; then
  eval "$(rbenv init -)" &> /dev/null
fi
# }}}

# {{{ functions

# {{{ command-not-found override function
command_not_found_handle ()
{
    local pkgs cmd=$1;
    local FUNCNEST=10;
    set +o verbose;
    mapfile -t pkgs < <(pkgfile -bv -- "$cmd" 2>/dev/null);
    if [[ ${#pkgs[*]} -eq 1 && -n $PKGFILE_PROMPT_INSTALL_MISSING ]]; then
        local pkg=${pkgs[0]%% *};
        local response;
        read -r -p "Install $pkg? [Y/n] " response;
        [[ -z $response || $response = [Yy] ]] || return 0;
        printf '\n';
        sudo pacman -S --noconfirm -- "$pkg";
        return 0;
    fi;
    if (( ${#pkgs[*]} )); then
        printf '%s may be found in the following packages:\n' "$cmd";
        printf '  %s\n' "${pkgs[@]}";
        return 0;
    fi
    aur_pkgs=$(aur_hook.py $cmd);
    if  (( ${#aur_pkgs[*]} )); then
      printf '%s might be found in the following AUR packages:\n' "$cmd";
      printf '  %s\n' "${aur_pkgs[@]}";
      return 0;
    else
        printf "bash: %s: command not found\n" "$cmd" 1>&2;
        return 127;
    fi
}

# }}}

# {{{ remove_symlink

function remove_symlink(){
  # Turn link into a file
  if [[ -z $1 ]]; then
    echo "specifify symlink to turn into file"
  elif [[ ! -h $1 ]] || [[ ! -a $1 ]]; then
    echo "$1 is not a valid symlink"
  else
    cp --remove-destination `readlink $1` $1
  fi
}

# }}}

# {{{ 'which' function
function which_function(){
  # use with alias of which to also resolve functions
  # and aliases as well as  files
  shopt -s extdebug
  if [[ -z $1 ]]; then
    /bin/which
  else
      declare -F $1 && type -a "$1" || alias "$1" 2>/dev/null || /bin/which "$1"
  fi
}
# }}}

# {{{ until true
function ut() {
  # run command until it succeeds
  # eg. ut git push
  until "$@"; do
    echo "trying again" >&2
    sleep 5
  done
}
# }}}

# {{{ retry ping if failed
function ping() { 
  # Retry ping if failed
  if [[ -z $1 ]]; then
    /bin/ping;
  else
    ut /bin/ping "$@";
  fi
}
# }}}

# {{{ llwhich

function llwhich() {
    which=$(/bin/which $1)
    if [[ -L $which ]]; then
      ls -l $which
    elif [[ -f $which ]]; then
      echo $which
    else
      echo $which
    fi
}
# }}}

# {{{ find and install function
function find_and_install() {
  # parses output from command-not-found-hook and installs last reccommended
  # package (arch linux)
  command=$1
  package=$($command 2>/dev/null|tail -1 | awk "{print $1}")
  echo "$package"
  if [[ -z $package ]]; then
    echo "unable to find $command"
  else
    sudo /bin/pacman -S "$package"
  fi

}
# }}}

# {{{ volume function
function volume() {
  amixer set Master "${1}"%
}
# }}}

# {{{ coundown function 
function countdown() {
  # countdown number of seconds

  seconds="$1"
  date1=$(($(date +%s) + seconds -1));
  while [ "$date1" -ge "$(date +%s)" ]; do
    echo -ne "$(date -u --date @$(("$date1" - $(date +%s) )) +%H:%M:%S)\r";
  done
}
# }}}

# {{{ loop command until interrupted
function wt() {
  [ "$(which "$1")" ] && while true; do "$@"; done
}
# }}}

# {{{ update PS1 for powerline
function _update_ps1() {
  ## Powerline Shell
  ## https://github.com/milkbikis/powerline-shell
  PS1="$(~/powerline-shell.py --cwd-mode fancy --mode compatible --colorize-hostname --shell bash $? 2> /dev/null)"
}

if [ "$TERM" != "linux" ] && [ "$TERM" != "vt100" ] && [ -L "$HOME/powerline-shell.py" ]; then
  export TERM=xterm-256color
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
else
  # fallback PS1
  export TERM=xterm
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ '
fi
#}}}
# }}}

dbus-update-activation-environment --all
