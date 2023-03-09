#declare -i,a
a=11
if [ $a -gt 10 ] 
then 
echo $a gt than 10
elif [ $a -lt 10 ]
then
echo $a ls than 10

else

echo $a eq than 10
fi