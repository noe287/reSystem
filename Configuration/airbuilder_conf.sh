#Following this http://wiki.corp.airties.com/index.php?title=Air-builder


#Docker Installation
#Install docker from https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
sudo apt-get update

#Install the latest version of Docker CE, or go to the next step to install a specific version:

sudo apt-get install docker-ce
sudo apt-cache madison docker-ce

#WARNING: If you set proxy for docker daemon, you should add docker.corp.airties.com to NO_PROXY.
# You may need executed below lines manually
#https://docs.docker.com/config/daemon/systemd/
#sudo mkdir -p /etc/systemd/system/docker.service.d/
#sudo echo "[Service]" >  /etc/systemd/system/docker.service.d/http-proxy.conf
#sudo echo "Environment="HTTPS_PROXY=https://proxy.corp.airties.com:3128/" "NO_PROXY=localhost,127.0.0.1,docker.corp.airties.com"" >> /etc/systemd/system/docker.service.d/http-proxy.conf

#Flush changes:
sudo systemctl daemon-reload
#Restart Docker:
sudo systemctl restart docker
#Verify that the configuration has been loaded:
systemctl show --property=Environment docker
#Environment=HTTP_PROXY=http://proxy.example.com:80/
#Or, if you are behind an HTTPS proxy server:
#sudo docker run hello-world

#-----------------------------------------------------------------
#AirTies configuration


sudo apt-get install ccache
mkdir ~/.ccache

# Edit global GIT configuration
#   git config --global user.name "Airties Anonymous Users"
#   git config --global user.email anonymous@airties.com
git config --global references.path /opt/GIT_REFERENCE_REPOSITORIES
# Make sure you have read and write permissions for the GIT_REFERENCE_REPOSITORIES directory
sudo chown $USER:$USER /opt/GIT_REFERENCE_REPOSITORIES && cd /opt/GIT_REFERENCE_REPOSITORIES
git clone --mirror git://git.corp.airties.com/buildsys.git
git clone --mirror git://git.corp.airties.com/profiles.git

#We have to use https while using docker pull and we can have only self-signed certificate internal server, we should copy public key to local manually.
wget --no-check-certificate --no-proxy https://docker.corp.airties.com/trustme.sh
chmod a+x trustme.sh && sudo ./trustme.sh && rm trustme.sh

cd /opt
sudo git clone git://git.corp.airties.com/air_toolchains air_toolchains
sudo git clone git://git.corp.airties.com/opt-toolchains toolchains


git clone git://git.corp.airties.com/buildsys
cd buildsys
source environment
bake init

