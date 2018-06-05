#for D in Air4742v2SW Air4641SW SE301 Air5650TT Air4400 Air4310 Air4340 RT-206v4TT SC201 Air5453 Air5343 Air5443 Air5444TT Air5650; do bsys_dep.sh $D > $D.dep; done

newb="newbuild"
if [ ! -d $newb ]
then
	mkdir newbuild	
fi


for D in Air4742v2SW Air4641SW SB601 Air5650TT Air4443; do bsys_dep.sh $D > $newb/$D.dep; done

#all.dep'i yaratmak için gereken komut:
cat $newb/*.dep | sort | uniq -c > $newb/all.dep
cat $newb/all.dep | cut -d " " -f8 > $newb/deps.all
#rm *.dep
