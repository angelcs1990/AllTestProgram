#!/bin/bash
#code by cs

# appPath='/Users/chensi/Desktop/'
# echo $appPath'build'
# cd $(dirname $1)
# echo '=========='
# pwd
# echo '==========='
# xcodebuild clean
# xcodebuild -workspace GameGuess_CN.xcworkspace -scheme GameGuess_CN -sdk iphoneos9.3 -configuration Release -arch arm64 -arch armv7 -arch armv7s CODE_SIGN_IDENTITY="iPhone Distribution: HuaHaiLeYing Network Technology Co.,Ltd (QDH66RGJXX)" -derivedDataPath $appPath
# xcrun -sdk iphoneos PackageApplication -v /Users/chensi/Desktop/Build/Products/Release-iphoneos/GameGuess_CN.app -o /Users/chensi/Desktop/ipa/GameGuess_CN.ipa --sign "iPhone Distribution: HuaHaiLeYing Network Technology Co.,Ltd (QDH66RGJXX)"

##############################
function msgActionShow()
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
# msgSig "======================================="
# msgSig "|            ___     ___              |"
# msgSig "|           /   \\\\   /   \\\\             |"
# msgSig "|          ｜       \\\\___              |"
# msgSig "|          ｜           \\\\             |"
# msgSig "|           \\\\___/   \\\\___/             |"
# msgSig "======================================="

######################
function replaceString(){
	local inputString=$1
	result=${inputString//\\/}
	echo $result
}

function dirCheckOrCreate(){
	local folder=$1
	if [ -d "$folder" ]
	then
		msgWarningShow $folder'已经存在'
	else
		msgActionShow '创建'$folder'目录'
		mkdir -pv $folder
	fi
}
function getBundleIdentifier(){
    local project_pbxprojPath=$1"/project.pbxproj"

    # LINE=`cat $project_pbxprojPath`

    local paths=$(grep -rn "PRODUCT_BUNDLE_IDENTIFIER" $project_pbxprojPath)

    if [ paths ]; then
        local path=$paths
        local bundle_identifier=${path##*"PRODUCT_BUNDLE_IDENTIFIER = "}
        local last=${bundle_identifier//";"/}
        echo $last
    fi
}
######################项目参数配置
if [ $# -le 1 ]
then
    msgErrorShow "请输入参数，如果不知道参数，要么看代码，要么联系cs"
    exit 1
elif [ $# == 2 ]
then
    # config path
    if [ -d "$2" ]
    then
        buildConfig="$1"
        projectDir="$2"
        projectName=`basename "$2"`
        # distributionCer="$2"
        isWorkSpace=true
    else
        msgErrorShow "你输入的文件目录不存在呀，你逗我玩吧。。。"
        exit 1
    fi
    
elif [ $# == 3 ]
then
    # config path cer
    if [ -d "$2" ]
    then
        buildConfig="$1"
        projectDir="$2"
        projectName=`basename "$2"`
        distributionCer="$3"
        isWorkSpace=true
        # read helsss
        # exit 1
    else
        msgErrorShow "你输入的文件目录不存在呀，你逗我玩吧。。。"
        exit 1
    fi
elif [ $# == 4 ]
then
    # config path cer provision
    if [ -d "$2" ]
    then
        buildConfig="$1"
        projectDir="$2"
        projectName=`basename "$2"`
        distributionCer="$3"
        isWorkSpace=true
        provisitionFile=`pwd`"/provision/$4"
        provisitionUUID=`/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i ${provisitionFile})`
        # d0fe123d-0a46-4900-aee0-1108968b57d2.mobileprovision
        if [ -z "$provisitionUUID" ]
        then
            msgErrorShow "找不到证书(provision file error)"
            exit 1
        fi
        if [ -f "$HOME/Library/MobileDevice/Provisioning Profiles/${provisitionUUID}.mobileprovision" ]
        then
            echo "已经存在了"
        else
            cp ${provisitionFile} "$HOME/Library/MobileDevice/Provisioning Profiles/${provisitionUUID}.mobileprovision"
        fi
        echo $provisitionUUID
    else
        msgErrorShow "你输入的文件目录不存在呀，你逗我玩吧。。。"
        exit 1
    fi
else
    msgErrorShow "你输入的东西太多了"
    exit 1
fi


# 项目目录
# projectDir='/Users/chensi/Project/svn/游戏竞猜/Trunk(最新代码)/src(代码库)/GameGuess_CN'
# 项目名称
# projectName='GameGuess_CN'
# 是workspace还是project
# isWorkSpace=true
# 证书
# distributionCer='iPhone Distribution: HuaHaiLeYing Network Technology Co.,Ltd (QDH66RGJXX)'
# 编译参数


######################
rm -rf ./build
# 文件存放目录
buildAppToDir=`pwd`'/output/build'
# 文件输出目录
finishDir=`pwd`'/output/ipa'

rm -rf ./output
dirCheckOrCreate $buildAppToDir
######################获取相关信息
infoPlist=$(replaceString "${projectDir}/${projectName}/Info.plist")

bundleDisplayName=`/usr/libexec/PlistBuddy -c "Print CFBundleDisplayName" $infoPlist`
bundleVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $infoPlist`
# bundleIdentifier=`/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $infoPlist`
bundleIdentifier=`getBundleIdentifier ${projectDir}/${projectName}.xcodeproj`
bundleBuildVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $infoPlist`
# echo "输入bundleDisplayName："

# echo "输入bundleIdentifier："
# read bundleIdentifier
# echo $bundleIdentifier
appName=$bundleDisplayName
####################开始编译app
# -sdk iphoneos9.3 -arch arm64 -arch armv7 -arch armv7s 
# PROVISIONING_PROFILE_GameGuess_CN="$provisitionFile"
PROVISIONING_PROFILE=PROVISIONING_PROFILE_$projectName

if [ $isWorkSpace == true ]
then
	msgActionShow '开始'$projectName.xcworkspace'工程编译'
    if [ $# == 2 ]; then
        xcodebuild -workspace "${projectDir}/$projectName.xcworkspace" -scheme "$projectName"  -configuration "$buildConfig" clean build SYMROOT="$buildAppToDir"
    elif [ $# == 3 ]; then
        xcodebuild -workspace "${projectDir}/$projectName.xcworkspace" -scheme "$projectName"  CODE_SIGN_IDENTITY="$distributionCer" -configuration "$buildConfig" clean build SYMROOT="$buildAppToDir"
    elif [ $# == 4 ]; then
        xcodebuild -workspace "${projectDir}/$projectName.xcworkspace" -scheme "$projectName"  CODE_SIGN_IDENTITY="$distributionCer" ${PROVISIONING_PROFILE}="$provisitionUUID" -configuration "$buildConfig" clean build SYMROOT="$buildAppToDir"
    fi
    
else
	# msgActionShow '开始'$projectName'target编译'
    msgWarningShow "这里没有测试，可能有问题"
    exit 1
	cd ${projectDir}
	xcodebuild -target $projectName -configuration $buildConfig clean build SYMROOT=$buildAppToDir
fi

if [ $? == 0 ]
then
	msgSucessShow "一不小心就编译成功了"
    # 测试用，正式调用可去掉
    # read -n1 -p "按任意键继续。。。"
    # echo ""
else
	msgErrorShow "出错喽,赶快检查哪里有问题"
	exit 1
fi
# iphoneos/ResourceRules.plist
####################打包ipa
ipaName=$projectName
appDir="$buildAppToDir/$buildConfig"'-iphoneos'
 # --embed "${provisitionFile}"
xcrun -sdk iphoneos PackageApplication -v "$appDir/$projectName.app" -o "$appDir/$ipaName.ipa"
echo $appDir

####################收尾工作
msgActionShow "检查"$ipaName.ipa"文件是否存在"
if [ -f "$appDir/$ipaName.ipa" ]
then
	msgSucessShow $ipaName.ipa"文件正常"
else
	msgErrorShow "出错喽,赶快检查哪里有问题"
	exit 1
fi

# 最终的输出目录

dirCheckOrCreate $finishDir
plistDir=$finishDir/$ipaName.plist
msgActionShow "拷贝"$ipaName.ipa"文件到"$finishDir/$ipaName.ipa
cp -f -p  "$appDir/$ipaName.ipa" "$finishDir/$ipaName.ipa"

#plist文件生成
msgActionShow "生成plist文件"
cat << EOF > $plistDir
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>items</key>
        <array>
            <dict>
                <key>assets</key>
                <array>
                    <dict>
                        <key>kind</key>
                        <string>software-package</string>
                        <key>url</key>
              			<string>@_cs_@</string>
                    </dict>
                </array>
                <key>metadata</key>
                <dict>
                    <key>bundle-identifier</key>
            		<string>$bundleIdentifier</string>
                    <key>bundle-version</key>
                    <string>$bundleVersion</string>
                    <key>kind</key>
                    <string>software</string>
                    <key>title</key>
                    <string>$appName</string>
                </dict>
            </dict>
        </array>
    </dict>
</plist>
EOF
