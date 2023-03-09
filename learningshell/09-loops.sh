x= ' '
for color in white red blue;do
x=$color$x
done
echo $x


# while
 t=10
 while [ $t -lt 15 ]; do
 echo $t
 t=$((t+1))
 done