#$1 being the name of the interface
sudo restart avahi-daemon
sudo avahi-autoipd $1
sudo avahi-autoipd --refresh $1

