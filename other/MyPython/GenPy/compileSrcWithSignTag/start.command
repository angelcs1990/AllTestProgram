#!/bin/bash
#code by cs

# cd ..

tmpLef=`echo ~`
tmpRight=`pwd`

if [ "$tmpLef" == "$tmpRight" ]
then
    fullpath=$(dirname $0)
    cd $fullpath
fi

path=`pwd`
# basename $path
srcFolder=`dirname $path`
desFolder="$srcFolder"/release_sign

python "$path/compilePy.py" "$srcFolder" "$desFolder"

echo '========================'
echo '编译完成'