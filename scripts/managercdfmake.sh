if [ $1 ]
then
    AIR_BUS_DIR=/${PWD}/../../air-bus make -C $1 MY_CFLAGS=-I/${PWD}/../ MY_LDFLAGS=-L/${PWD}/../client all install V=1
else
    AIR_BUS_DIR=/${PWD}/../../air-bus make  MY_CFLAGS=-I/${PWD}/../ MY_LDFLAGS=-L/${PWD}/../client clean all install V=1
fi

