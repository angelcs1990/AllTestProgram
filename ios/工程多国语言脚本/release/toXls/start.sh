#!/bin/bash
#code by cs

function msgActionShow()
{
	echo -e "\033[42;37m[执行]$1\033[0m"
}
function msgSig()
{
    echo -e "\033[36m[签名]$1\033[0m"
}
function msgWarningShow()
{
    echo -e "\033[31m[提示]$1\033[0m"
}
function msgErrorShow()
{
	echo -e "\033[31m[出错]$1\033[0m"
}
msgSig "======================================="
msgSig "|            ___     ___              |"
msgSig "|           /   \\\\   /   \\\\             |"
msgSig "|          ｜       \\\\___              |"
msgSig "|          ｜           \\\\             |"
msgSig "|           \\\\___/   \\\\___/             |"
msgSig "======================================="

msgWarningShow "请输入好参数"
msgWarningShow "key:要以此作为语言模板"
msgWarningShow "output:输出目录"
msgWarningShow "ignoreKyes:不需要翻译的语言没有请填（'ignoreKeys':[]）"
read -n1 -p "按任意键继续。。。"
echo ""

fullpath=$(dirname $0)
cd $fullpath

msgActionShow "转换开始"
python i8n_2_xlsV3.cs "/Users/chensi/project/svn/GameGuess_CN/GameGuess_CN/Supporting Files/Language(国际化)" "{'key':'en', 'output':'output.xls', 'ignoreKeys':['vi']}"
if [ $? == 1 ]
then
	msgErrorShow '杯具了，出错了，快联系攻城狮解决吧。。。'
	exit 1
fi
msgActionShow "转换结束"
open .