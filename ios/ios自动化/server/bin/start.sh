#!/bin/bash
#code by cs

function msgActionShow()
{
    echo -e "\033[42;37m[执行]$1\033[0m"
}
function msgErrorShow()
{
    echo -e "\033[31m[出错]$1\033[0m"
}
function msgSucessShow()
{
    echo -e "\033[32m[成功]$1\033[0m"
}
function msgWarningShow()
{
    echo -e "\033[31m[提示]$1\033[0m"
}
function msgSig()
{
    echo -e "\033[36m[签名]$1\033[0m"
}
msgSig "======================================="
msgSig "|            ___     ___              |"
msgSig "|           /   \\\\   /   \\\\             |"
msgSig "|          ｜       \\\\___              |"
msgSig "|          ｜           \\\\             |"
msgSig "|           \\\\___/   \\\\___/             |"
msgSig "======================================="

currpath=$(dirname $0)
nodeApp=$currpath'/node'
servApp=$currpath'/iOS_AutoServer.js'

msgActionShow "开始启动服务器"
if [ -f $nodeApp ]
then
	if [ -f $servApp ]
	then
		$nodeApp $servApp
	else
		msgErrorShow $servApp'不存在'
		exit 1
	fi
else
	msgErrorShow $nodeApp'不存在'
	exit 1
fi

