[[ -f ~/.zshrc ]] && . ~/.zshrc

export GOPATH=$HOME/.local/go
export PATH=$PATH:$HOME/.scripts:$GOPATH/bin:$HOME/.local/share/gem/ruby/3.0.0/bin:$HOME/.local/bin
export TERMINAL="urxvt"
export EDITOR="vim"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
ssh-add

if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep i3 || startx
fi

# complete gnome-keyring init (for nextcloud client etc)
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
fi

# set hotkeys -> i3 config
#xbindkeys

