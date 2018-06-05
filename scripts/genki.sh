railsPID=`ps aux | grep rails | head -n 1| awk -F " " '{print $2 }'`
gcwmpPID=`ps aux | grep genieacs-cwmp | head -n 1| awk -F " " '{print $2 }'`
gfsPID=`ps aux | grep genieacs-fs | head -n 1| awk -F " " '{print $2 }'`
gnbiPID=`ps aux | grep genieacs-nbi | head -n 1| awk -F " " '{print $2 }'`

echo "killing processess $railsPID $gcwmpPID  $gfsPID $gnbiPID"

kill -9 ${railsPID}
kill -9 ${gcwmpPID}   
kill -9 ${gfsPID}
kill -9 ${gnbiPID}

geniePATH=/home/nejat/genieacs/bin
uiPATH=/home/nejat/genieacs/genieacs-gui-master/

if [ "$1" = "s"  ]
then
    $geniePATH/genieacs-cwmp & #>> /var/log/genieacs-cwmp.log 2>> /var/log/genieacs-cwmp-err.log &
    $geniePATH/genieacs-nbi & #>> /var/log/genieacs-nbi.log 2>> /var/log/genieacs-nbi-err.log &
    $geniePATH/genieacs-fs  & #>> /var/log/genieacs-fs.log 2>> /var/log/genieacs-fs-err.log &
    cd $uiPATH && rails s &
fi

