newsvndir=http://svn.corp.airties.com/svn/atlantis/release/development/$1/$2
#newsvndir=http://svn.corp.airties.com/svn/atlantis/users/Nejat/$1/$2
svn mkdir $newsvndir

svn co $newsvndir
cp * $2/
cd $2
ls -al

svn add *
svn ci
