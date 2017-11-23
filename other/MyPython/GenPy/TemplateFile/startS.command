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


python "$path/__s_@_s__mainEntry"
