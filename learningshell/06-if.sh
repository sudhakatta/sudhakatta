#declare -i,a
a=11
if [ $a -gt 10 ] 
then 
echo "$a gt than 10"
else if [ $a -lt 10]

echo "$a lt than 10"
else
echo "$a ls than 10"
fi