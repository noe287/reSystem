selectname=`date +%F_%H`"_installed-packages"
#sudo apt-get install dselect
sudo dpkg --get-selections > ~/System_Backups/installed/$selectname"_dpkg"
aptitude search '~i!~M' > ~/System_Backups/installed/$selectname"_aptitude"


