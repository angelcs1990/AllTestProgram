#!/bin/bash
#code by cs

# cd ..

#要加防护的python脚本路劲
destPythonPath=‘/xxxx/MyPython/AutoSign/python/autoSign.py'
# 算法
algo='AlgoAES'
# 要加密脚本的入口函数
entryFun='main'

tmpLef=`echo ~`
tmpRight=`pwd`

if [ "$tmpLef" == "$tmpRight" ]
then
    fullpath=$(dirname $0)
    cd $fullpath
fi

path=`pwd`


python "$path/SGenPy.py" $destPythonPath $algo $entryFun
