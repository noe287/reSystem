#if [ ! $1 ]
#then
	echo "Usage:sudo /sbin/sysctl -w vm.drop_caches=[1,2,4]"
	echo "Release memory used by the Linux kernel on caches"
	echo "1 --> to free pagecache"
	echo "2 --> to free dentries and inodes"
	echo "3 --> to free pagecache, dentries and inodes"
#	exit
#fi

sudo /sbin/sysctl -w vm.drop_caches=3
#ref:http://www.commandlinefu.com/commands/view/10446/clear-cached-memory-on-ubuntu
