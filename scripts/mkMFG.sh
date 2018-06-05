mkimage -A arm -O Linux -C none -T script -e 0x00 -a 0x00 -n "Air4920${2} pre-install" -d preinstall_no_tel  prescr_no_tel.img
mkimage -A arm -O Linux -C none -T script -e 0x00 -a 0x00 -n "Air4920${2} pre-install" -d preinstall prescr.img

fwimage -o AirTies_Air4920${2}_FW_${1}_FullImage_NOSIGN.bin -v ${1} -b cfe_brcm-ap.bin -t prescr_no_tel.img -k uImage -r rootfs.img
fwimage -o AirTies_Air4920${2}_FW_${1}_NOSIGN.bin -v ${1} -t prescr.img -k uImage -r rootfs.img

fwsign -k generic_sign.key -i AirTies_Air4920${2}_FW_${1}_FullImage_NOSIGN.bin -o AirTies_Air4920${2}_FW_${1}_Manufacturing_Upgrade.bin
fwsign -k generic_sign.key -i AirTies_Air4920${2}_FW_${1}_NOSIGN.bin -o AirTies_Air4920${2}_FW_${1}_GENERIC_SIGN.bin

rm AirTies_Air4920${2}_FW_${1}_FullImage_NOSIGN.bin
rm AirTies_Air4920${2}_FW_${1}_NOSIGN.bin
