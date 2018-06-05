#insmod airbus releated modules
# insmod ./kernel/event/airbus-event.ko
# insmod ./kernel/command/airbus-command.ko


# manager complile
# AIR_BUS_DIR=/${PWD}/../../air-bus make MY_CFLAGS=-I/${PWD}/../ MY_LDFLAGS=-L/${PWD}/../client all install V=1
#if [ $1 ]
#then
#    `AIR_BUS_DIR=/${PWD}/../../air-bus make MY_CFLAGS=-I/${PWD}/../ MY_LDFLAGS=-L/${PWD}/../client all install V=1`
#fi



# for i in `ps aux | grep air-bus | cut -d " " -f6`
# do
#     sudo kill -9 $i
# done
#
# for i in `ps aux | grep cdf-daemon | cut -d " " -f6`
# do
#     sudo kill -9 $i
# done

cp /home/nejat/Development/projects/PROFILES/09_08_16-13.52.14_Air4920/tools/cwmp-xml-tools/airties-data.c /home/nejat/Development/projects/TEMP_WORK/cdf/manager-1.27_cdf/src/manager/source/
cp /home/nejat/Development/projects/PROFILES/09_08_16-13.52.14_Air4920/tools/cwmp-xml-tools/airties-data.h /home/nejat/Development/projects/TEMP_WORK/cdf/manager-1.27_cdf/src/include/
cp /home/nejat/Development/projects/PROFILES/09_08_16-13.52.14_Air4920/tools/cwmp-xml-tools/Air4920.xml /home/nejat/Development/projects/TEMP_WORK/cdf/test/data/xml/ro/Air4920.xml

if [ "$1" = "run" ]
then
    sudo /home/nejat/Development/projects/TEMP_WORK/cdf/air-bus/test/kernel/client -e 0 -s com.airties &
    sudo /home/nejat/Development/projects/TEMP_WORK/cdf/daemon/cdf-daemon --parser.path_ro /home/nejat/Development/projects/TEMP_WORK/cdf/test/data/xml/ro/Air4920.xml --parser.path_wr /home/nejat/Development/projects/TEMP_WORK/cdf/test/data/xml/wr/wr-Air4920.xml &

    #RUN manager
    cd manager-1.27_cdf/
    sudo LD_PRELOAD=../libwrapper-0.1-initial/libwrapper.so LD_LIBRARY_PATH='../client:_install/lib' ./src/manager/source/mngr
fi
