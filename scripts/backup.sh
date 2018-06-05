dumpdate=`date +%F_%H`

echo -e "\e[32m ------->Backing up Firefox browser bookmarks"
echo -e "\e[39m"

#backup firefox bookmarks
cp $(find /home/nejat/.mozilla/firefox/wmwsdsfp.default-1460979249580/bookmarkbackups/| sort | tail -n1) ~/System_Backups/bookmarks_firefox/       #$dumpname

#Backup scripts folder
echo -e "\e[32m ------->Backing up ~/scripts folder"
echo -e "\e[39m"
tar -czvf  ~/System_Backups/scripts/$dumpdate"_scripts.tar.gz" ~/scripts/

#installed programs on aptitude
echo -e "\e[32m ------->Backing up aptitude selections"
echo -e "\e[39m"
./getselections.sh

#vim packages and vim configs
echo -e "\e[32m ------->Backing up vim releated packages"
echo -e "\e[39m"

mkdir -p ~/System_Backups/vim/$dumpdate
cp ~/.vimrc ~/System_Backups/vim/$dumpdate/"_.vimrc"

tar -czvf  ~/System_Backups/vim/$dumpdate/"_vim.tar.gz" ~/.vim 
tar -czvf  ~/System_Backups/vim/$dumpdate/"_vimgit.tar.gz" ~/vimgit 
tar -czvf  ~/System_Backups/vim/$dumpdate/"_.vimpkg.tar.gz" ~/.vimpkg

echo -e "\e[32m ------->Backing up system config files .bashrc .agignore, .gitconfig etc..."
echo -e "\e[39m"

mkdir -p ~/System_Backups/system_configs/$dumpdate
cp ~/.agignore ~/System_Backups/system_configs/$dumpdate/"_.agignore"
cp ~/.bashrc ~/System_Backups/system_configs/$dumpdate/"_.bashrc"
cp ~/.ctags ~/System_Backups/system_configs/$dumpdate/"_.ctags"
cp ~/.gitconfig ~/System_Backups/system_configs/$dumpdate/"_.gitconfig"
cp ~/.git_log_template ~/System_Backups/system_configs/$dumpdate/"_.git_log_template"
cp -r ~/.bundler ~/System_Backups/system_configs/$dumpdate/"_bundler"


echo -e "\e[32m -------> Backing up of config files and scripts are completed"
echo -e "\e[34m -------> You can find these files under ~/Systems_Backup folder"
echo -e "\e[39m"
