cd $HOME/.vim
cp ../.viminfo viminfo
cp ../.vimrc vimrc

git add *
git status
git commit -a -m $'\n\n--\n\nIssue:VIM \n\n'
git push

cd /home/noe/DataDrive/reSystem/

git add *
git status
git commit -a -m $'\n\n--\n\nIssue:RESYS \n\n'
git push

