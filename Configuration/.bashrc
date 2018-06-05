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
HISTSIZE=-1
HISTFILESIZE=-1

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
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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


########################## MY EXTENSIONS STARTED #####################################################################
#source ~/.git-completion.bash

# https_proxy=https://proxyws.corp.airties.com:3128
https_proxy=https://proxy.corp.airties.com:3128
export https_proxy
# http_proxy=http://proxyws.corp.airties.com:3128
http_proxy=http://proxy.corp.airties.com:3128
export http_proxy
# ftp_proxy=ftp://proxyws.corp.airties.com:3128
ftp_proxy=ftp://proxy.corp.airties.com:3128
export ftp_proxy

export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/home/noe/.vimpkg/bin:/home/noe/scripts:/home/noe/systemscr/:/usr/local/bin/:.

export difs="~/DataDrive/DEVEL/Patches"
export SVN_EDITOR=vim
export SCRIPTS_DIR="/home/noe/scripts"

alias lscr='ls -CF /home/noe/scripts/'
alias lsp='ls -CF ~/DataDrive/DEVEL/Patches'

alias gdbmips='mips-linux-gdb'

alias mw='make write_enp6s0'
alias mca='bake clean all -C'
alias mco='bake checkout -C'
alias mr='bake release'
alias mdir='bake directories install release'
alias ma='bake all'
alias bam='bake menuconfig'
alias mac='bake all -C'

alias op='gnome-open .&'
alias sbash='source /home/noe/.bashrc'
alias dalek='ssh nejatonay.erkose@dalek'
alias _dalek='nejatsonay.erkose@dalek:~/'

alias scr='cd /usr/bin/scripts'
alias prf='cd  ~/DataDrive/DEVEL/PROFILES'
alias tftpb='cd /srv/tftpboot/'
alias ..='cd ..'
alias .='cd -'
alias ~='cd ~'
alias d='cd /home/noe/Downloads'

alias net='cd /home/noe/DataDrive/DEVEL/PROFILES/mrbox-May-16_12.10.55-2018-Çrş_release/2.1.382/Obj/debug/project_build_arm/bskyb-mr412/linux-3.10.27/net'

alias co="checkout"
alias chp="cherry-pick"
alias gitc='git-cola dag &'
alias gitt='gitk . &'

alias eco='rdesktop -g 1280x1024 -r clipboard:CLIPBOARD -u nejatonay.erkose -d AIRTIES terminal2.corp.airties.com'

# FOR SKY
alias bs='./tools/bake shell'
alias ball='./tools/bake all'
alias bak='./tools/bake'
alias bakv='USE_LOCAL_TOOLCHAINS=y BUILD_TYPE=debug ./tools/bake'

alias cext='cp 4.14L.04-SkyHybridRouting/bcm963xx/targets/EXTENDER/bcmEXTENDER_fs_kernel /tftpboot/'
alias cvip='cp 4.14L.04-SkyHybridRouting/bcm963xx/targets/BSKYB_VIPER/bcmBSKYB_VIPER_fs_kernel /tftpboot/'
alias cmr='cp 2.1.97/Obj/debug/binaries/bskyb-mr412/uImage /tftpboot/'
alias cfal='cp 2.1.97/Obj/debug/binaries/bskyb-falcon-d1/zImage /tftpboot/ '

alias x='exit'

# folder name notation: eg. <device-name>-<issue-number>-<version-no>
get-bsky(){
    git clone -b master ssh://nejatonay.erkose@git.corp.airties.com:29418/bskyb-shr-builder $1
}

cmd-mrbox(){
    echo "tftp 40000000 192.168.2.200:uImage"
    echo "mmc write 40000000 0 14000"
}

cmd-falcon(){
    echo "ifconfig eth0 -addr=192.168.2.6 -mask=255.255.255.0 -gw=192.168.2.1 -dns=192.168.2.1"
    echo "flash 192.168.2.200:zImage emmcflash0.kernel"
    echo "setenv -p STARTUP \"boot emmcflash0.kernel:zImage 'console=ttyS0,115200 ip=udhcp vmalloc=300M brcm_cma_kern_rsv=450M'\""
}

cmd-viper(){
	echo "f 192.168.2.200:bcmBSKYB_VIPER_fs_kernel"
}

########################## MY EXTENSIONS ENDED #####################################################################

alias ag='ag --path-to-agignore=~/.agignore'
alias py="/usr/bin/python"

########################## Added by alias add  #####################################################################

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
