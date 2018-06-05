i=1
j=$#

for ((i=1;i<=$j;i++));
do
   # your-unix-command-here

   a=`echo "$"$i`
   echo $a

#   make -C "$"$i/ clean all
done


for i in {1..${j}}
do
	echo $i
done



while [ $i -le "$#" ]
do


((i++)) 

done
