#!/bin/bash

#scr line
mkimage -A arm -O Linux -C none -T script -e 0x0 -a 0x0 -n "Air4920FR-OR pre-install" -d mus-preinstall mus-prescr.img
mkimage -A arm -O Linux -C none -T script -e 0x0 -a 0x0 -n "Air4920FR-OR post-install" -d mus-postinstall mus-postscr.img

#musline
fwimage -o AirTies_Air4920FR-OR_FW_1.25.4.2.354_MUS_NOSIGN.bin -v 1.25.4.2.354 -b cfe_brcm-ap.bin -k uImage -r rootfs.img -y mus-postscr.img -t mus-prescr.img
fwsign -k 4920-gen.key -i AirTies_Air4920FR-OR_FW_1.25.4.2.354_MUS_NOSIGN.bin -o AirTies_Air4920FR-OR_FW_1.25.4.2.354_MUS.bin
