echo ""
echo "############################APT PACKET#########################################"
echo ""
sudo apt-cache policy $1
sudo apt-cache madison $1
echo ""
echo "############################DPKG LOCATION INFO#################################"
echo ""
dpkg -L $1
