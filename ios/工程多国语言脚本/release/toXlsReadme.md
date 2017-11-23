# 简介
本脚本主要是把工程中多国语言.string文件转换成xlsx文件，配合fromXls脚本使用

# 使用说明
1. 配置好start.sh中的参数，然后命令行运行start.sh即可

## i8n\_2_xlsV3.cs传参说明
	"第一个":工程中国际化目录（例：.../project/svn/GameGuess_CN/GameGuess_CN/Supporting Files/Language(国际化)）
	"第二个":字典（例："{'key':'en', 'output':'output.xls', 'ignoreKeys':['vi']}"）
	字典说明：
	"key":做为模板的语言
	"output":输出文件名
	"ignoreKeys":不需要扣取转换的语言（注意：是个数组）

# 注意
无

# 示例
	python i8n_2_xlsV3.cs ".../project/svn/GameGuess_CN/GameGuess_CN/Supporting Files/Language(国际化)" "{'key':'en', 'output':'output.xls', 'ignoreKeys':['vi']}"

# 其它
无
 