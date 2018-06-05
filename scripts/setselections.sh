#sudo apt-get install dselect
sudo dpkg --set-selections < $1
sudo dselect
