# 简介
给python脚本进行加密，只能对单一python脚本。加密后的脚本，不能进行调试，修改，否则运行不了。

# 用法介绍
* 修改start.command脚本
    >参数：
    ><font color=red>destPythonPath</font>:你自己脚本的路径
    ><font color=red>algo</font>:算法（需要在SGenPy添加相应算法的引用）
    ><font color=red>entryFun</font>:你脚本中的入口函数
* 双击运行start.command脚本

# 注意
如果双击不能运行start.command脚本，那么命令行chmod +x 你的路径/start.command后，再双击

# 其他
算法可以自己实现，参考S_Algo中的算法实现。实现后，如果要使用，请在SGenPy.py中进行引用

***
<font color=blue>code by cs</font>