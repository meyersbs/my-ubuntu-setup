# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then

    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias devsplat="~/Code/SPLAT/splat/splat"
alias search="ls -R ${PWD} | grep"
alias myip="hostname -I"
eval "$(thefuck --alias fuck)"

fileToClipboard() {
	cat $1 | xclip -selection clipboard
}

cd() { builtin cd "$@" && ls; }

loop() { for i in $(seq $1); do $2; done }

clean(){
	sudo apt update
	sudo apt upgrade
	sudo apt autoremove
}

ritrdp(){
	xfreerdp /rfx /d:main.ad.rit.edu /u:bsmeec /cert-ignore /v:$1
}

uploadToPyPi(){
	python3 setup.py register -r https://pypi.python.org/pypi
	python3 setup.py sdist upload
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# For every command that takes longer than five seconds to execute, create a pop-up notification upon completion.
trap '_start=$SECONDS' DEBUG
PROMPT_COMMAND='(if (( SECONDS - _start > 5 )); then hist1=$(echo $(history 1) | cut -d " " -f1); hist2=$(echo $(history 1) | cut -d " " -f2-); notify-send --icon=/usr/share/icons/Numix-Circle/48/apps/terminal-tango.svg "$(echo -e Finished!\\nPID: ${hist1}\\nCommand: ${hist2})"; fi)'

#red="\033[1;31m";
green="\e[1;32m";
norm="\033[0;39m";
cyan="\033[1;36m";
white="\e[1;37m";
if [ "$PS1" ]; then
#PS1="\$ "
   PS1="\[$green\]\u\[$white\]@\[$cyan\]\h:\[$norm\]\w\$ "
   PS1="\t \[$green\]\u\[$white\]@\[$cyan\]\H:\[$norm\]\w \\$\[$(tput sgr0)\] "
   #export PROMPT_COMMAND="echo -n \[\$(date +%H:%M:%S)\]\ "
   #export PS1=" "$PS1"\[\e]30;\u@\h\a\]"
fi

export PATH="$PATH:$HOME/.rvm/archives/rvm-1.27.0/scripts/bin" # Add RVM to PATH for scripting
