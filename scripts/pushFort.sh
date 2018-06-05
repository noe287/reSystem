#input package name for $1
git remote -v
git remote set-url --push origin ssh://nejatonay.erkose@git.corp.airties.com:29418/$1
git push origin HEAD:$1
