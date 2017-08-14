xrdb -merge ~/.Xresources
xset +fp /usr/share/fonts/artwiz-fonts
xset fp rehash
xcalib ~/w530.icm &
xsetroot -cursor_name left_ptr &
feh --bg-scale ~/Downloads/GoingHome.jpg
wicd-client -t&
xscreensaver -no-splash &
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
         --expand true --width 10 --transparent true --height 14 &
 
exec dbus-launch xmonad
