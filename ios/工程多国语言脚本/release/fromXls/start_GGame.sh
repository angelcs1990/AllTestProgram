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
msgWarningShow "使用注意："
msgWarningShow "--------------------------------------------------------------------"
msgWarningShow "| 请确保i8n_create_GGame.py,i8n_file_replace.py跟本文件在同文件夹下|"
msgWarningShow "| 其次，请参考source.xlsx具体写法，输入xlsx必须命名为source.xlsx   |"  
msgWarningShow "| 最后，别忘了修改i8n_file_replace.py中的dest_dir跟src_dir路径     |"
msgWarningShow "--------------------------------------------------------------------"
msgWarningShow "|      code by cs    |"
msgWarningShow "----------------------"
read -n1 -p "按任意键继续。。。"
echo ""

msgTipShow "开始多国语言生成"
python i8n_create_GGame.cs "{'key':'', 'notesKey':'', 'sourceFile':'', 'headerFileType':'', 'headerFileTemplate':'', 'outputFolder':''}"
msgTipShow "结束多国语言生成"
msgWarningShow "=========================="
exit 0
msgTipShow "开始文件替换"
python i8n_file_replace.cs
msgTipShow "结束文件替换"