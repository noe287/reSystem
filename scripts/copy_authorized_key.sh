rsa_path="/home/noe287/.ssh/id_rsa.pub"

if [ $1 == "1" ]
then
   if [ ! -e "/home/noe287/.ssh/id_rsa.pub" ]
   then
       ssh-keygen -t rsa   
   fi
fi

#$2 is path to id_rsa.pub on this machine
#$3 is the username on the remote machine
#$4 is the ip address of the remote machine
ssh-copy-id -i $rsa_path $2@$3
