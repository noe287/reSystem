cd $HOME/.vim
cp ../.viminfo viminfo
cp ../.vimrc vimrc

git add *
git commit -a -m $'\n\n--\n\nIssue:VIM \n\n'
git push

cd $HOME/DataDrive/reSystem
git add *
git commit -a -m $'\n\n--\n\nIssue:RESYS \n\n'
git push

