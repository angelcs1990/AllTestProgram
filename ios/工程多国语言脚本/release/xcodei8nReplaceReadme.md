#简介
本脚本是把工程中中文替换成多国语言的代替符号
#使用说明
1. 运行start.sh

##xcodei8nReplace.cs传参说明
	"第一个":需要替换的目标工程路径（必填）
	"第二个":参考的国家化语言文件路径（如：.../../Localizable.strings,必填）
	"第三个":替换后的样式（如"cs{%s}",替换后就是cs{xxx},必填） 
	"第四个":忽略的文件目录（如：'["WebSocket", "SWebViewController", "Http", "SRouter2", "STabView", "SPopView", "CS"]'，没有可以填"")
	"第五个":忽略的文件（如：同上，没有可以填"")

#注意
无

#示例
	python xcodei8nReplace.cs '.../project/Export/GameGuess_CN2/GameGuess_CN' '.../project/svn/GameGuess_CN2/GameGuess_CN/Supporting Files/Language(国际化)/zh-Hans.lproj/Localizable.strings' "%s" '["WebSocket", "SWebViewController", "Http", "SRouter2", "STabView", "SPopView", "CS"]' ''

#其它
无
 