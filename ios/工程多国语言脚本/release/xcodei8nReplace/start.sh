#!/bin/bash
#code by cs


function msgTipShow()
{
	echo -e "\033[42;37m[执行] $1\033[0m"
}
function msgErrorShow()
{
	echo -e "\033[31m[出错] $1\033[0m"
}
function msgSucessShow()
{
	echo -e "\033[32m[成功] $1\033[0m"
}
function msgWarningShow()
{
	echo -e "\033[31m[提示] $1\033[0m"
}
function msgSig()
{
	echo -e "\033[36m[签名] $1\033[0m"
}
msgSig "======================================="
msgSig "|            ___     ___              |"
msgSig "|           /   \\\\   /   \\\\             |"
msgSig "|          ｜       \\\\___              |"
msgSig "|          ｜           \\\\             |"
msgSig "|           \\\\___/   \\\\___/             |"
msgSig "======================================="


msgTipShow "开始文件替换"
python xcodei8nReplace.cs '/Users/chensi/project/Export/GameGuess_CN2/GameGuess_CN' '/Users/chensi/project/svn/GameGuess_CN2/GameGuess_CN/Supporting Files/Language(国际化)/zh-Hans.lproj/Localizable.strings' "%s" '["WebSocket", "SWebViewController", "Http", "SRouter2", "STableView", "STabView", "SPopView", "CS"]' ''
msgTipShow "结束文件替换"