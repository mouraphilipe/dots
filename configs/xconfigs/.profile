
export PATH="$PATH:$(du "$HOME/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//;s|/$||')"
export PRINTER=HP-LaserJet-Pro-MFP-M127fn
export MPD_HOST="$HOME/.config/mpd/socket"
export SCRIPTSFOLDER="$HOME/bin"
export SUDO_ASKPASS=$SCRIPTSFOLDER/askPass
export ALTERNATE_EDITOR="emacsclient -t"
export TERMINAL="st"
export EDITOR="nvim"
export VISUAL="st -e nvim"
export EDITOR="emacs -nw"
export VISUAL="emacs"

export OLDPWD=$HOME

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


notify-send "Loading Org Folder from Dropbox"
rclone -l copy dbox:org ~/org -P &
notify-send "Loading These Folder from Dropbox"
rclone -l copy dbox:these ~/these -P &

echo "$0" | grep "zsh$" >/dev/null && [ -f ~/.zshrc ] && source "$HOME/.zshrc"

# echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx

# sudo -n loadkeys ~/.scripts/ttymaps.kmap 2>/dev/null
