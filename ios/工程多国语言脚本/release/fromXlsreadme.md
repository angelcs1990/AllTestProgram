# 使用说明
1. 请确保数据文件是xlsx后缀（具体写法参照里面的source）
2. 请修改i8n_file_replace.py文件中的dest_dir跟src_dir字段
3. 如果是给GGame用，请使用start_GGame.sh运行
4. 如果有错误请及时联系

## i8n\_create_GGame.py传参说明
	"key":根据该字段进行扣取（不写，默认：key)
	"notesKey":以该字段作为注释字段扣取（不写，默认：zh-Hans)
	"sourceFile":读取的xlsx文件路径（不写，默认：source.xlsx)
	"headerFileType":输出头文件类型（不写，默认：0)
	"headerFileTemplate":根据headerFileType＝2时，自定义模板（不写，默认：static输出)
	"outputFolder":保存的目录（不写，默认：i8n)

#### headerFileType字段说明
取值范围(0-2)  
0:static输出  
1:define输出  
2:自定输出，此时headerFileTemplate字段有效  

#### headerFileTemplate字段说明
输出变量有{0}跟{1}两个  
{0}代表关键词  
{1}代表输出值  
如:  
<pre>"static NSString *const {0} = @\"{0}\";\n"</pre>


## i8n\_file_replace.py传参说明
	"destDir":输出目录（一般是工程文件中的国际化目录）
	"srcDir":输入目录（一般是上述outputFolder目录）
	"destName":输出目录中的输出文件名（默认Localizable.strings）

# 注意
无

# 示例
无参数的例子  

	python i8n_create_GGame.py "{'key':'', 'notesKey':'', 'sourceFile':'', 'headerFileType':'', 'headerFileTemplate':'', 'outputFolder':''}"

有参数的例子

	python i8n_create_GGame.py "{'key':'en', 'notesKey':'zh-Hans', 'sourceFile':'source.xlsx', 'headerFileType':'0', 'headerFileTemplate':'', 'outputFolder':'i8n'}"

# 其它
用命令行进入该目录后，使用chmod +x start_GGame.sh,以后就可以直接./start_GGame.sh运行
 