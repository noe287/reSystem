
cp $BSPROOT/tools/bin/{fwsign,fwimage} .
cp $BSPROOT/tools/bin/{mkmus,mkimage,mkmus.arc} .
cp $BSPROOT/release/image/uImage.jumbo .


function mus_fw()
{

#Pre-install script:
echo "setenv f_rootfs_addr 0x90830000" > mus-pre.scr
echo "setenv f_rootfs_end 0x90FFFFFF" >> mus-pre.scr
echo "saveenv" >> mus-pre.scr

#Post-install script:
echo "setenv PRODUCT_ID Air4820TR-RT" > mus-post.scr
echo "setenv f_rootfs_size 0x004a71c0" >> mus-post.scr
echo "setenv f_kernel_size 0x004a71c0" >> mus-post.scr
echo "setenv f_kernel2_size 0x004a71c0" >> mus-post.scr
echo "saveenv" >> mus-post.scr
echo "spi_flash erase 0x50000 0x10000" >> mus-post.scr
echo "spi_flash erase 0x60000 0x10000" >> mus-post.scr

mkmus.arc -a ARC -b $BSPPATH/release/image/bootloader.bin -s mus-pre.scr -p mus-post.scr -k $BSPPATH/profiles/$1/sign.key -v 1.0.0.1 -o $BSPPATH/release/image/AirTies_${1}_FW_${2}_MUS.bin

}


function generic_fw() 
{

mkimage.arc -A ARC -O Linux -C none -T script -e 0x00 -a 0x00 -n ""$1" pre-install" -d profiles/"$1"/preinstall  release/image/prescr.img
fwimage -o NOSIGN.bin -v 1.0.0.1 -t release/image/prescr.img -k release/image/uImage.jumbo
fwsign -k profiles/"Air4820"/sign.key -i NOSIGN.bin -o release/image/AirTies_"${1}"_FW_"${2}"_GENERIC_SIGN.bin
}

if [ "$3" = "m" ]
then
	#########################################################################################################
	#create MUS firmware
	mus_fw $1 $2
elif [ "$3" = "g" ]
then
	#########################################################################################################
	#create generic image
	generic_fw $1 $2
else

	mus_fw $1 $2
	generic_fw $1 $2

fi

rm fwsign fwimage mkmus mkimage mkmus.arc mus-post.scr mus-pre.scr uImage.jumbo NOSIGN*

