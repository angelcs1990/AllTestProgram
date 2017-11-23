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

# 拉取
msgWarningShow "请你自己先去更新svn或是git的代码，否则可能打包失败"
read -n1 -p "按任意键继续。。。"
echo ""

fullpath=$(dirname $0)
cd $fullpath
# 编译
msgActionShow "文件编译开始"
chmod +x autoPack_iOS.sh
./autoPack_iOS.sh "Release" '/Users/GameGuess_CN'  'iPhone Distribution: xxxxxxxxxxxxxxx' 'GameGuess_Adhoc.mobileprovision'
if [ $? == 1 ]
then
	msgErrorShow '出大事啦，打包出错啦，出错啦。。。'
	exit 1
fi
msgActionShow "文件编译结束"
# 上传服务器
msgActionShow "文件上传开始"
python uploadFiles.py "https://192.168.31.70:9998/file_upload" "{'file1':'output/ipa/GameGuess_CN.ipa', 'file2':'output/ipa/GameGuess_CN.plist'}"
if [ $? == 1 ]
then
	msgErrorShow '上传出错啦，出错啦。。。，请手动上传呗。'
	exit 1
fi
msgActionShow "文件上传结束"
msgSucessShow "好险，终于上传成功啦"

# 上传svn
msgActionShow "文件svn上传开始"
chmod +x ipaSvnBackup.sh
./ipaSvnBackup.sh 'https://xxxxxxx/svn/11GameGuessAPP/03Release/iOS/测试/' 'output/ipa/GameGuess_CN.ipa' 'username' 'password'
if [ $? == 1 ]
then
	msgErrorShow "svn上传失败了,别气馁，再来一次"
	exit 1
fi
msgActionShow "文件svn上传结束"
