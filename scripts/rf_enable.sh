sudo rfkill unblock wifi
sudo rfkill unblock all
sudo rfkill list
sudo ifconfig $1 up
sudo lshw -class network
