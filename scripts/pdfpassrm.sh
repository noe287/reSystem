if [ $2 ]
then
    pdftk $1 input_pw $2 output $1
    exit
fi

echo "You must provide filename and the password."

