
export PATH="$PATH:$(du "$HOME/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//;s|/$||')"
export PRINTER=HP-LaserJet-Pro-MFP-M127fn
export MPD_HOST="/home/accacio/.config/mpd/socket"
export SCRIPTSFOLDER="$HOME/bin"
export SUDO_ASKPASS=$SCRIPTSFOLDER/askPass
export ALTERNATE_EDITOR="emacsclient -t"
export TERMINAL="st"
export EDITOR="nvim"
export VISUAL="st -e nvim"
# export EDITOR="emacsclient -t"
# export VISUAL="emacsclient -c"

export OLDPWD=$HOME

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

echo "$0" | grep "zsh$" >/dev/null && [ -f ~/.zshrc ] && source "$HOME/.zshrc"

# echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"
xmodmap -e "keysym oe = Super_L"
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx

# sudo -n loadkeys ~/.scripts/ttymaps.kmap 2>/dev/null
