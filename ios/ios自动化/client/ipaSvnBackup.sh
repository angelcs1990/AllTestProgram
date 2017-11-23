#! /bin/bash
#code by gaoqi

function xrsh_arrhasitem()
{
  local _xrsh_tmp
  local _xrsh_array=`echo "$1"`
  for _xrsh_tmp in ${_xrsh_array[*]}; do
    if "$2" == "$_xrsh_tmp"; then
      echo yes
      return
    fi
  done
  echo no
}

function deleteFile()
{
	svn delete "$1" -m "delete repeat file"
}

function GetLastObject(){
	arr=$1
	leanth=${#arr[@]}
	echo ${arr[$leanth-1]}
}

# updatePath="https://gaoqi@192.168.10.245:800/svn/11GameGuessAPP/03Release/iOS/测试/"


# echo "请拖入您的ipa文件"
# read ipa_path


if [ $# == 4 ]
then
	updatePath="$1"
	ipa_path=$(pwd)"/$2"
	username="$3"
	password="$4"
	if [ -f "$ipa_path" ]
	then
		echo "文件检测通过"
	else
		echo "文件不存在"
		exit 1
	fi

fi
paths=$(svn --username "$username"  --password "$password" list $updatePath)
resFile=`basename $ipa_path`
arr=(${resFile// / })
currentPath=$(GetLastObject $arr)

if [ "$paths" ]; 
then
	exitPath=$(xrsh_arrhasitem $paths $currentPath)
	if [ $exitPath ]
	then
		# echo "该ipa文件已经存在，请确认是否上传  输入0退出  任意继续上传"
		# read update
		# if [ $update == 0 ]
		# then
		# 	exit 1
		# else
			deleteFilePath=$updatePath$currentPath
			deleteFile $deleteFilePath
		# fi
	fi
fi

svn import "$ipa_path" $updatePath$currentPath -m "test bash"