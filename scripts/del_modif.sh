PACKETS_USED=`release/revision $BSPROOT/. .config | sed -ne 's/^.*][[:space:]]\(.*\)[[:space:]](.*/\1/p' | grep -vie filesystem_product -e filesystem_base -e filesystem_platform -e kernel -e asp_xmls -e device_tables -e buildsys -e libverify_keys -e bcm9535x -e bcm947xx`

BEST_CHAN_VER=`cat $BSPROOT/.config | sed -ne 's/^CONFIG_bestchan_PATH=\"\(.*\)\".*/\1/p'`

for i in $PACKETS_USED;do sed -i '/}_foss/,+6d'  $BSPROOT/$i/Makefile > /dev/null 2>&1;sed -i '/foss_content.sh/,+6d' $BSPROOT/$i/Makefile > /dev/null 2>&1;done

