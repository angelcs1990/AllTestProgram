#!/bin/bash
#code by cs
logFile="log.txt"
#工作区域sub文件夹
workSpace="/workSpace"
#工作区域ipa存放地址
workSpaceIpaFile=""
#工作区域ProvisionFile存放地址
workSpaceProvisionFile=""
#输出文件夹
outputFile=""
#是否隐藏工作目录
hiddenWorkspace=1
#是否删除工作目录 非debug模式删除工作目录以及隐藏工作目录
Debug=0

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
function createWorkSpace()
{
    currentFile=`pwd`
    workSpaceFile=$currentFile$workSpace"/"
    outputFile=`pwd`"/output"

    #判断工作文件夹是否存在  存在就删除
    if ([ -d $currentFile$workSpace ]); then
        rm -rf $currentFile$workSpace
    fi

    (mkdir  $currentFile$workSpace)&& {
        if [ $hiddenWorkspace == 1 ]
        then
            if [ $Debug == 0 ]
            then
                # chflags nohidden 显示指定隐藏文件
                chflags hidden $currentFile$workSpace
            fi
        fi
    }

    #判断输出文件夹是否存在 不存在就创建
    if ! ([ -d ${outputFile} ]); then
        mkdir  $outputFile
    fi
    
    workSpaceIpaFile=$workSpaceFile"resign.ipa"
    workSpaceProvisionFile=$workSpaceFile"resign.mobileprovision"
    cp $1 $workSpaceIpaFile
    cp $2 $workSpaceProvisionFile
}

function quitProgram()
{
    if ! [ -z $1 ]
    then
        msgErrorShow $1
    fi
    
    if [ $Debug == 0 ]
    then
        rm -rf $workSpaceFile
    fi
    exit
}

function getFileSum()
{
    resFile=`basename $1`
    arr=(${resFile// / })
    length=${#arr[@]}
    return $length
}
clear
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
limitSysVersion="10.10.0"
limitSysVersion=${limitSysVersion//./}

if [ $curSysVersion -lt $limitSysVersion ]; then
    msgWarningShow "此程序最好在10.10.0以上使用"
    read -n1 -p "按任意键继续。。。"
    echo ""
fi

echo "===================="`date +%Y年%m月%d日`"====================" >> "$logFile"
######################项目参数配置
# if [ $# == 2 ]
# then
#     distributionCer="$1"
#     bundleId="$2"
# elif [ $# == 1 ]
# then
#     # provisitionFile=`pwd`"/$2".mobileprovision
#     bundleId="$1"
# else
#     msgErrorShow "输入示例：本程序 '证书' 'mobileprovision文件' '修改BundleID'"
#     exit 1
# fi

inputFlag=1
while [ $inputFlag == 1 ]
do
    echo "证书如下，请选择一个（输入序号如：1）即可"
    /usr/bin/security find-identity -v -p codesigning
    cerList=`/usr/bin/security find-identity -v -p codesigning`
    read -p "Enter your choice:"
    #如果输入小于证书count&&大于0就是ok的，否则继续
    distributionCer=`/usr/bin/security find-identity -v -p codesigning|grep $REPLY\)|cut -d \" -f2`
    if [ -z "$distributionCer" ] 
    then
        clear
        inputFlag=1
    else
        msgWarningShow "您选择的证书为:""$distributionCer"
        inputFlag=0
    fi
done

# 获取当前目录
ipaFile=`pwd`/*.ipa
getFileSum "$ipaFile"
if [ $? -gt 1 ]
then
    quitProgram "该文件夹中包含多个ipa，请只放置一个需重签名的ipa"
fi

provisitionFile=`pwd`/*.mobileprovision
getFileSum "$provisitionFile"
if [ $? -gt 1 ]
then
    quitProgram "该文件夹中包含多个provisitionFile，请只放置一个需重签名的provisitionFile"
fi

# 1.文件验证
msgActionShow "文件验证开始"
fileCheck $ipaFile
fileCheck $provisitionFile
msgActionShow "文件验证结束"

#配置工作空间
createWorkSpace $ipaFile $provisitionFile

# 2.解析成需要的entitlements.plist
entitlementsPlist=$workSpaceFile"entitlements.plist"

# defaults write ${entitlementsPlist} ${tmpDict}
# /usr/libexec/PlistBuddy -c "Set :dict ${tmpDict}" $entitlementsPlist
(/usr/libexec/PlistBuddy -x -c "print :Entitlements " /dev/stdin <<< $(security cms -D -i ${workSpaceProvisionFile}) > $entitlementsPlist) || {
    quitProgram "Entitlements处理失败"
}
msgActionShow "Entitlements处理结束"

# 3.提取bundleId
if [ -z $bundleId ]
then
    msgActionShow "提取bundleId开始"
    applicationIdentifier=`/usr/libexec/PlistBuddy -c "Print :application-identifier " ${entitlementsPlist}`
    bundleId=${applicationIdentifier#*.}
    msgActionShow "提取bundleId结束; BundleId: $bundleId "
fi

# 4.匹配provisionfile与证书
msgActionShow "开始验证provisionfile与证书是否匹配"
provisionFileTeamId=${applicationIdentifier%%.*}
cerTeamId=${distributionCer##*\(}
test $cerTeamId = "$provisionFileTeamId"\)""
if [ $? == 1 ] 
then
    msgWarningShow "所选证书与provisionfile的group不匹配，是否继续？继续请按1"
    read -p "Enter your choice:"
    if [ $REPLY != 1 ]; then
        quitProgram "所选证书与provisionfile的group不匹配"
    fi
fi

# 5.解压
msgActionShow "解包开始"
(unzip -d ${workSpaceFile} ${workSpaceIpaFile} >> "$logFile" 2>&1 ) || {
    quitProgram \"${workSpaceIpaFile}\"解压失败
}
msgActionShow "解包结束"

# 6.拷贝provisitionFile
msgActionShow "拷贝"${workSpaceProvisionFile}"-->"$workSpaceFile"Payload/*.app/embedded.mobileprovision开始"
#rm -rf Payload/*.app/_CodeSignature/
(cp ${workSpaceProvisionFile} "$workSpaceFile"Payload/*.app/embedded.mobileprovision >> "$logFile" 2>&1) || {
    quitProgram \"${workSpaceProvisionFile}\"拷贝失败
}
msgActionShow "拷贝结束"

# 7.修改info.plist
msgActionShow "修改info.plist开始"
infoPlist=$workSpaceFile"Payload/*.app/info.plist"

if ! ([ -f ${infoPlist} ]); then
    quitProgram \"${infoPlist}\"文件不存在
fi

`/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${bundleId}" $infoPlist`
msgActionShow "修改info.plist结束"

# 8.开始签名
msgActionShow "签名开始"
appPath=$workSpaceFile"Payload/"*.app

# codesign --preserve-metadata=identifier,entitlements,resource-rules -f -s "${distributionCer}" "${appPath}"
#codesign --force --entitlements "entitlements.plis" -s "${distributionCer}" "${appPath}"
(codesign -fs "${distributionCer}" --no-strict --entitlements=${entitlementsPlist} $appPath >> "$logFile" 2>&1) || {
    quitProgram "签名失败"
}
msgActionShow "签名结束"

# 9.验证文件是否签名完整
appName=`basename $appPath`
appPath=$workSpaceFile"Payload/"$appName
codesign -v $appPath

# 10.压缩app文件
msgActionShow "压缩开始"
 
zipIpaFile=$outputFile"/resign_new.ipa"
cd $workSpaceFile
(zip -r $zipIpaFile Payload/ > /dev/null) || {
    cd ..
    quitProgram "压缩失败"
}
cd ..

msgActionShow "压缩结束"
msgSucessShow "文件重签名ok了，赶快去试试吧"

# 11.删除工作目录
quitProgram 

# 10.10以后需要设置xcode的$(SDKROOT)/ResourceRules.plist，才可以用地下的大包
# (codesign --preserve-metadata=identifier,entitlements,resource-rules -f -s ${distributionCer} ${appPath}) || {
# ## if code sign error, will to here
#     msgErrorShow "失败了"
#     rm -rf Payload/
#     exit
# }

