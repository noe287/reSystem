tools/bin/mkimage.arc -A ARC -O Linux -C none -T script -e 0x00 -a 0x00 -n $1 pre-install -d profiles/$1/preinstall  release/image/prescr.img
tools/bin/fwimage -o NOSIGN.bin -v 1.0.0.1 -t release/image/prescr.img -k release/image/uImage.jumbo
tools/bin/fwsign -k profiles/"Air4820"/sign.key -i NOSIGN.bin -o release/image/AirTies_${1}_FW_${2}_GENERIC_SIGN.bin

