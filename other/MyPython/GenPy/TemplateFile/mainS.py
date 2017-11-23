# !/usr/bin/python
#coding:utf-8

#code by cs


import os
import sys
import signal

from SLoadModule import CsFileLoad
# from S_Algo.__s_@_s__Algo import __s_@_s__Algo

g_genPy_key = '__s_@_s__key'
# g_genPy_Algo = __s_@_s__Algo
g_genPy_EntryFun = '__s_@_s__entry'




def handler(signal_num,frame):
    print ''
    print '\033[31m' + '不要酱紫强退嘛，温柔点会死丫。😁' + '\033[0m' 
    sys.exit(signal_num)
signal.signal(signal.SIGINT, handler)

def cur_file_dir():
     #获取脚本路径
     path = sys.path[0]
     #判断为脚本文件还是py2exe编译后的文件，如果是脚本文件，则返回的是脚本的目录，如果是py2exe编译后的文件，则返回的是编译后的文件路径
     if os.path.isdir(path):
         return path
     elif os.path.isfile(path):
         return os.path.dirname(path)

def main():
    path = cur_file_dir()

    codeRunPath = os.path.join(path, 'Module/SRunEncryptCode.cs')
    keyPath = os.path.join(path, 'Module/' + g_genPy_key)
    selfPath = os.path.join(path, 'SMain.py')
    algoPath = os.path.join(path, 'S_Algo/__s_@_s__Algo.cs')

    csLoad = CsFileLoad()
    csRunModel = csLoad.CsLoadFun(codeRunPath)
    csAlgoModel = csLoad.CsLoadFun(algoPath)

    if csRunModel == None or csAlgoModel == None:
        return

    cAlgo = csAlgoModel.__s_@_s__Algo()

    cRun = csRunModel.CodeRun(cryptAlgo=cAlgo)
    mainStart = cRun.GetFunction(keyPath, [selfPath, codeRunPath], g_genPy_EntryFun)

    if mainStart != None:
        mainStart()

if __name__ == '__main__':
    main()