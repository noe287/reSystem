sudo -E apt-get upgrade
sudo -E apt-get update

#How to install GIT ?

#Install via apt-get repository
sudo apt-get install git gitk

#Customize GIT

#Edit global GIT configuration
git config --global user.name "nejatonay.erkose"
git config --global user.email nejatonay.erkose@airties.com
git config --global references.path /opt/GIT_REFERENCE_REPOSITORIES
#Make sure you have read and write permissions for the GIT_REFERENCE_REPOSITORIES directory
sudo chown $USER:$USER /opt/GIT_REFERENCE_REPOSITORIES && cd /opt/GIT_REFERENCE_REPOSITORIES
git clone --mirror git://git.corp.airties.com/buildsys.git
git clone --mirror git://git.corp.airties.com/profiles.git

#Developer System
sudo -E apt-get -y install yakuake vim subversion meld guake indicator-multiload goldendict aptitude shutter unity-tweak-tool minicom wireshark cscope vifm rdesktop
ssh openssl clang tftpd-hpa silversearcher-ag apt-transport-https ca-certificates exuberant-ctags

sudo -E apt install -y libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev
sudo apt install dia
#For 32bit binaries to be able to run on 64bit system.
sudo dpkg --add-architecture i386
sudo -E apt-get -y install  libc6:i386 libncurses5:i386 libstdc++6:i386

#For keepnote
sudo -E apt-get install python python-gtk2 python-glade2 libgtk2.0-dev libsqlite3-0 -y
#Spell checking is enabled with an optional package:
sudo -E apt-get install python-gnome2-extras aspell aspell-en aspell-XX -y

#kscope
sudo add-apt-repository ppa:fbirlik/kscope
sudo apt-get update
sudo apt-get install kscope-trinity


#fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


#sudo vim /etc/rc.local
#/home/noe/conface.sh 3


#For docker
# sudo -E apt-get -y install ccache
#
# sudo -E apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# sudo -E apt-get purge lxc-docker
# sudo -E apt-cache policy docker-engine
# sudo -E apt-get -y install linux-image-extra-$(uname -r)
# sudo -E apt-get -y install apparmor
# sudo -E apt-get update
# sudo -E apt-get -y install docker-engine
# sudo -E service docker start
# #sudo -E docker run hello-world
# sudo -E groupadd docker
# sudo -E usermod -aG docker nejat
#docker run hello-world

#apt-get proxy settings in addition to system proxy configuration...
#if [ ! -f /etc/apt/apt.conf ]; then
#sudo -E echo "Acquire::http::proxy "http://proxy.corp.airties.com:3128";" > /etc/apt/apt.conf
#sudo -E echo "Acquire::https::proxy "http://proxy.corp.airties.com:3128";" >> /etc/apt/apt.conf
#sudo -E echo "Acquire::ftp::proxy "http://proxy.corp.airties.com:3128";"  >> /etc/apt/apt.conf
#fi

# Acquire::http::proxy "http://nejatonay.erkose:Shoemaker287@proxyws.corp.airties.com:3128";                                                                                                    
# Acquire::https::proxy "http://nejatonay.erkose:Shoemaker287@proxyws.corp.airties.com:3128";
# Acquire::ftp::proxy "http://nejatonay.erkose:Shoemaker287@proxyws.corp.airties.com:3128";

# [user]                                                                                                                                                                                        
#         name = \"Nejat Onay Erköse\"
#         email = nejatonay.erkose@airties.com
# [core]
#         editor = vim 
# [commit]
#         template = /home/systems/.git_log_template
# [references]
#         path = /opt/GIT_REFERENCE_REPOSITORIES
# [alias]
#          pub = "!f() { git push -u ${1:-origin} --no-thin HEAD:`git config branch.$(git name-rev --name-only HEAD).merge | sed -e 's@refs/heads/@refs/for/@'`;  }; f"
# [http]
#         proxy = http://nejatonay.erkose:Shoemaker287@proxyws.corp.airties.com:3128
#         sslVerify = false
# [https]
#         proxy = http://nejatonay.erkose:Shoemaker287@proxyws.corp.airties.com:3128
#         sslVerify = false

#Create your public key
ssh-keygen -t rsa
