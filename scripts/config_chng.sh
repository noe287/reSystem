chng_point=$1
chng_text=$2
#sed -i 's/^\(CONFIG_bootloader_PATH="\).*"/\1u-boot-air-binaries"/g' .config


sed -i 's/^\(\$chng_point="\).*"/\1\$chng_text"/g' .config





