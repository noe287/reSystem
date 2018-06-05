
if [ "$1" = "B" ]
then
	echo "BOOSTER"
	echo "f 192.168.2.77:bcmEXTENDER_fs_kernel"
	echo "f 192.168.2.77:bcmEXTENDER_fs_kernel_local_build"
	exit	
fi



if [ "$1" = "V" ]
then
	echo "VIPER"
	echo "f 192.168.2.77:bcmBSKYB_VIPER_fs_kernel"
	exit	
fi



if [ "$1" = "M" ]
then
echo "MRBOX"
echo "tftp 40000000 192.168.2.77:uImage;mmc write 40000000 0 14000; reset"
	exit	
fi

if [ "$1" = "F" ]
then
echo "FALCON"
echo "ifconfig eth0 -addr=192.168.2.7 -mask=255.255.255.0 -gw=192.168.2.77 -dns=192.168.2.77;flash 192.168.2.77:zImage emmcflash0.kernel;reboot;"
	exit	
fi

if [ "$1" = "X" ]
then
echo "XWING"
echo "tftp 40000000 192.168.2.77:uImage; mmc write 40000000 0 14000; reset"
	exit	
fi
