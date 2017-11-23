#!/bin/bash
#code by cs
logFile="log.txt"
function msgActionShow()
{
	echo -e "\033[42;37m[执行]$1\033[0m"
    echo `date +%H:%M:%S.%s`"[执行]$1" >> "$logFile"
}
function msgErrorShow()
{

	echo -e "\033[31m[出错]$1\033[0m"
    echo `date +%H:%M:%S.%s`"[出错]$1" >> "$logFile"
}
function msgSucessShow()
{
    echo -e "\033[32m[成功]$1\033[0m"
    echo `date +%H:%M:%S.%s`"[成功]$1" >> "$logFile"
}
function msgWarningShow()
{
    
    echo -e "\033[31m[提示]$1\033[0m"
    echo `date +%H:%M:%S.%s`"[提示]$1" >> "$logFile"
}
function msgSig()
{
    echo -e "\033[36m[签名]$1\033[0m"
}
function fileCheck()
{
    if ! ([ -f "$1" ]); then
        msgErrorShow \""$1"\"文件不存在
        exit
    fi
}

# ================================================
msgSig "======================================="
msgSig "|            ___     ___              |"
msgSig "|           /   \\\\   /   \\\\             |"
msgSig "|          ｜       \\\\___              |"
msgSig "|          ｜           \\\\             |"
msgSig "|           \\\\___/   \\\\___/             |"
msgSig "======================================="

curSysVersion=`sw_vers|grep ProductVersion|cut -d: -f2`
curSysVersion=${curSysVersion//./}
limitSysVersion="10.12.0"
limitSysVersion=${limitSysVersion//./}

if [ $curSysVersion -lt $limitSysVersion ]; then
    msgWarningShow "此程序最好在10.10.0以上使用"
    read -n1 -p "按任意键继续。。。"
    echo ""
fi
inputFlag=0
echo "证书如下，请选择一个（输入序号如：1）即可"
    /usr/bin/security find-identity -v -p codesigning
    read -p "Enter your choice:"
    #如果输入小于证书count&&大于0就是ok的，否则继续

while [ $inputFlag == 1 ]
do
    echo "证书如下，请选择一个（输入序号如：1）即可"
    /usr/bin/security find-identity -v -p codesigning
    read tmpInput
    #如果输入小于证书count&&大于0就是ok的，否则继续
    inputFlag=1
done
echo $REPLY
eee=`/usr/bin/security find-identity -v -p codesigning|grep $REPLY\)|cut -d \" -f2`
echo $eee
exit
echo "===================="`date +%Y年%m月%d日`"====================" >> "$logFile"
######################项目参数配置
if [ $# == 3 ]
then
    provisitionFile=`pwd`"/$2"
    distributionCer="$1"
    bundleId="$3"
elif [ $# == 2 ]
then
    provisitionFile=`pwd`"/$2"
    distributionCer="$1"
else
    msgErrorShow "输入示例：本程序 '证书' 'mobileprovision文件' '修改BundleID'"
    exit 1
fi

msgWarningShow "输入mobileprovision文件为：$provisitionFile"
msgWarningShow "输入证书为：$distributionCer"

# 获取当前目录
ipaFile=`pwd`/*.ipa


# 1.文件验证
msgActionShow "文件验证开始"
fileCheck $ipaFile
fileCheck $provisitionFile
msgActionShow "文件验证结束"


# 2.解析成需要的entitlements.plist
entitlementsPlist="entitlements.plist"
(/usr/libexec/PlistBuddy -x -c "print :Entitlements " /dev/stdin <<< $(security cms -D -i ${provisitionFile}) > $entitlementsPlist) || {
    msgErrorShow "Entitlements处理失败"
    exit
}
msgActionShow "Entitlements处理结束"

if [ -z $bundleId ]
then
# 3.提取bundleId
    msgActionShow "提取bundleId开始"
    applicationIdentifier=`/usr/libexec/PlistBuddy -c "Print :application-identifier " ${entitlementsPlist}`
    bundleId=${applicationIdentifier#*.}
    msgActionShow "提取bundleId结束; BundleId: $bundleId "
fi

# 4.解压
msgActionShow "解包开始"
(unzip ${ipaFile} >> "$logFile" 2>&1 ) || {
    msgErrorShow \"${ipaFile}\"解压失败
    exit
}
msgActionShow "解包结束"

# 5.拷贝provisitionFile
msgActionShow "拷贝"${provisitionFile}"-->"Payload/*.app/embedded.mobileprovision"开始"
#rm -rf Payload/*.app/_CodeSignature/
cp ${provisitionFile} Payload/*.app/embedded.mobileprovision
msgActionShow "拷贝结束"

## 6.修改info.plist
msgActionShow "修改info.plist开始"
infoPlist='Payload/*.app/info.plist'

if ! ([ -f ${infoPlist} ]); then
    msgErrorShow \"${infoPlist}\"文件不存在
    exit
fi

`/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${bundleId}" $infoPlist`
msgActionShow "修改info.plist结束"

## 7.开始签名
msgActionShow "签名开始"
ipaName=`basename ${ipaFile} .ipa`
appPath=`pwd`/Payload/${ipaName}.app
ipaNewPath=`pwd`/${ipaName}_new.ipa

# codesign --preserve-metadata=identifier,entitlements,resource-rules -f -s "${distributionCer}" "${appPath}"
#codesign --force --entitlements "entitlements.plis" -s "${distributionCer}" "${appPath}"
(codesign -fs "${distributionCer}" --no-strict --entitlements=${entitlementsPlist} "${appPath}" >> "$logFile") || {
    msgErrorShow "签名失败"
    exit
}
msgActionShow "签名结束"

## 8.压缩文件
msgActionShow "压缩开始"
zip -r ${ipaName}_new.ipa Payload/ >> "$logFile"
rm -rf Payload/
rm -rf iTunesMetadata.plist
msgActionShow "压缩结束"
msgSucessShow "文件重签名ok了，赶快去试试吧"
# 10.10以后需要设置xcode的$(SDKROOT)/ResourceRules.plist，才可以用地下的大包
# (codesign --preserve-metadata=identifier,entitlements,resource-rules -f -s ${distributionCer} ${appPath}) || {
# ## if code sign error, will to here
#     msgErrorShow "失败了"
#     rm -rf Payload/
#     exit
# }

