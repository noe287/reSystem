PRODUCT_NAME=`cat .config | sed -ne 's/.*PRODUCT_NAME="\(.*\)"/\1/p'`
ARCH="MIPS"
BIN_DIR="$BSPROOT/tools/bin"
BOOTLOADER="$BSPROOT/release/image/u-boot.air"
UIMAGE="$BSPROOT/release/image/uImage.jumbo"
SCR="$BSPROOT/tools/scripts/pre-install/$PRODUCT_NAME/$1.scr"
VERSION="$2"
UNSIGNED_IMAGE_NAME="$3"
SIGNED_NAME="$UNSIGNED_IMAGE_NAME_MUS.bin"
FWSIGN="$BSPROOT/tools/bin/fwsign"
SIGNE_KEY="$BSPROOT/tools/fwsign/keys/$PRODUCT_NAME/sign.key"


if [ ! $1 ]; then
	echo "[USAGE example]:"
	echo " "
	echo "./mus_create.sh /home/noe287/Development/projects/Air4641_44019/tools/bin MIPS /home/noe287/Development/projects/Air4641_44019/release/image/u-boot.air  /home/noe287/Development/projects/Air4641_44019/release/image/uImage.jumbo /home/noe287/Development/projects/Air4641_44019/tools/scripts/pre-install/Air4641/1.3.0.9.scr 1.3.0.13 unsigned_mus_image.bin"
	echo " "
	echo "tools/bin/fwsign -i AirTies_Air4611_FW_1.3.0.13_unsigned_MUS.bin -o AirTies_Air4611_FW_1.3.0.13_MUS.bin -k tools/fwsign/keys/Air4641/sign.key"
else
	mus_create.sh $BIN_DIR $ARCH $BOOTLOADER $UIMAGE $SCR $VERSION $UNSIGNED_IMAGE_NAME
	$FWSIGN -i $UNSIGNED_IMAGE_NAME -o $SIGNED_NAME -k $SIGN_KEY
fi

