#declare -i,a
a=-1
if [ $a -gt 10 ] 
then 
echo $a gt than 10
elif [ $a -lt 10 ]
then
echo $a ls than 10

else

echo $a eq than 10
fi
r="Rbc"
if [ $r == "abc" ]
then
echo both are same strings
else
echo not same
fi

file=/tmp/newfile
if [ -f $file ]
then 
ehco exits
else
echo not exists
fi