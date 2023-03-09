function ADD(){
add=$(($1+$2))
echo $add
}
a=10
b=89
ADD $a $b

echo SWAP FUNC
a=7
b=9
function swap()
{
    var1=$(($a+$b))
    a=$(($var1-$a))
    echo $a 
    b=$(($var1-$b))
    echo $b
}

swap $a $b
