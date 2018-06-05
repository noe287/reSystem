#!/bin/bash

function result_check {
        if [ $? ]; then
                echo ""
                echo "dual-copy-image-creator: $1 image created."
                echo ""
        else
                echo ""
                echo "dual-copy-image-creator: $1 image creation failed."
                echo ""
                exit 1
        fi
}

function sizeof {
	
echo `ls -la $1 | awk '{print $5}'`
}

function hex2dec {
	echo "ibase=16; $1" | bc
}

function dec2hex {
	echo "ibase=10; obase=16; $1" | bc
}

size_uImageJumbo=0

if [ -z "$7" ]; then
        echo "dual-copy-image-creator usage:"
        echo "dual-copy-image-creator <tools_path> <arch> <bootloader_image> \
<uImage.jumbo> <preinstall_script> <version_name> <dual-copy-image_name>"
        echo "example: ./dual-copy-image-creator ~/buildsys/tools/bin MIPS ~/4742/release/image/cfe-brcm.bin \
~/4742/release/image/uImage.jumbo ~/4742/tools/scripts/pre-install/Air4742SW/1.0.0.0.scr \
"1.0.0.0" Airties4742-1.0.0.0-dual-copy-image.bin "
        echo ""
        exit 1
fi

if [ ! -x $1/fwimage ]; then
        echo "dual-copy-image-creator: $1/fwimage don't exist or don't have execution permission"
        echo ""
        exit 1
fi

if [ ! -x $1/mkimage ]; then
        echo "dual-copy-image-creator: $1/mkimage don't exist or don't have execution permission"
        echo ""
        exit 1
fi

$1/mkimage -A $2 -O Linux -C none -T script -e 0x00 -a 0x00 -n "pre-install" -d $5 prescr.img;
result_check "preinstall"
$1/mkimage -A $2 -O Linux -C none -T filesystem -e 0x00 -a 0x00 -n "rootfs" -d $4 uImage.jumbo.rootfs;
result_check "uImage.jumbo"

size_uImageJumbo=$(sizeof $4)
echo $size_uImageJumbo
echo $size_uImageJumbo
echo $size_uImageJumbo
echo $size_uImageJumbo
echo $size_uImageJumbo
img_size=$(dec2hex $size_uImageJumbo)
echo "setenv f_kernel_size 0x90$img_size" > $6'_post.scr'
echo "setenv f_kernel2_size 0x90$img_size" >> $6'_post.scr'
echo "setenv f_rootfs_size 0x90$img_size" >> $6'_post.scr'
echo "run reset_config" >> $6'_post.scr'
echo "run reset_asd" >> $6'_post.scr'
echo "saveenv" >> $6'_post.scr'

$1/mkimage -A $2 -O Linux -C none -T script -e 0x00 -a 0x00 -n "post-install" -d $6'_post.scr' postscr.img;
result_check "postinstall"

$1/fwimage -o $7 -v $6 -b $3 -t prescr.img -y postscr.img -k $4  -r uImage.jumbo.rootfs;
result_check $7


exit 0
