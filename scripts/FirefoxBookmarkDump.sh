#dumpname=`date +%F_%H`"_bookmarks.json"             
cp $(find /home/nejat/.mozilla/firefox/wmwsdsfp.default-1460979249580/bookmarkbackups/| sort | tail -n1) ~/System_Backups/bookmarks_firefox/       #$dumpname

