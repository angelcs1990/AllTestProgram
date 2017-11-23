# !/usr/bin/python
#coding:utf-8


#code by cs

# 脚本加密文件

import sys
import os
import shutil
import subprocess

from optparse import OptionParser
from S_Algo.ICryptAlgo import ICryptAlgo
from SGenCodeKeyFile import GenerateKeyFile
from S_Algo.AlgoAES import AlgoAES

gMainEntryFun = 'tSign'


def cur_file_dir():
     #获取脚本路径
     path = sys.path[0]
     #判断为脚本文件还是py2exe编译后的文件，如果是脚本文件，则返回的是脚本的目录，如果是py2exe编译后的文件，则返回的是编译后的文件路径
     if os.path.isdir(path):
         return path
     elif os.path.isfile(path):
         return os.path.dirname(path)

class SGenPy(object):
    def __init__(self):
        self.m_codeAlgo = ICryptAlgo()
        # self.m_algoAlgoPath = ''
        self.m_destPyPath = ''
        self.m_destPyFolder = ''
        self.m_outFolder = ''
        self.m_Md5Key = 'cs_author_Generate'
        self.m_SecretKey = 'secret_Generate'
        self.m_SelfPathDir = cur_file_dir()
    def KeyWorkReplace(self, filePath, keys={}):
        print keys
        with open(filePath, 'r+') as fWriter:
            datas = fWriter.read()
            for itemKey, itemValue in keys.items():
                datas = datas.replace(itemKey, itemValue)
            with open(filePath, 'w+') as f:
                f.write(datas)
    def runCmd(self, cmd):
        cmdLine = cmd
        # print cmdLine
    
        output = subprocess.Popen(cmdLine, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout,stderr = output.communicate()
        if len(stderr) != 0:
            print '[-] ' + stderr
            return True
        else:
            print '[+] 执行：' + stdout
            return False

    def encodeCsFile(self):
        print '[*] 开始模块生成'
        complilePyPath = os.path.join(self.m_SelfPathDir, 'compileSrcWithSignTag/compilePy.py')
        self.runCmd('python "{0}" "{1}" "{2}"'.format(complilePyPath, self.m_outFolder, os.path.join(self.m_outFolder, 'Module')))
        self.runCmd('python "{0}" "{1}" "{2}"'.format(complilePyPath, os.path.join(self.m_SelfPathDir, 'S_Algo'), os.path.join(self.m_outFolder, 'S_Algo')))
    # 生成入口文件main.py
    def GenEntryFile(self):
        entryFile = 'SMain.py'
        outpath = os.path.join(self.m_outFolder, entryFile)
        print '[+] 生成入口文件：' + entryFile
        try:
            shutil.copy(os.path.join(self.m_SelfPathDir, 'TemplateFile/mainS.py'), outpath)
        except Exception, e:
            print '[!] 入口文件生成出错'
            return None
        # self.KeyWorkReplace(outpath, {'__s_@_s__Algo':self.m_codeAlgo, '__s_@_s__key':'code.cs_e', '__s_@_s__entry':gMainEntryFun})
        return outpath
    
    # 生成加密代码运行文件
    def GenRunEncryptCodeFile(self):
        runEnCodeFile = 'SRunEncryptCode.py'
        outpath = os.path.join(self.m_outFolder, runEnCodeFile)
        print '[+] 生成核心文件：' + runEnCodeFile
        try:
            shutil.copy(os.path.join(self.m_SelfPathDir, 'TemplateFile/SRunEncryptCodeS.py'), outpath)
        except Exception, e:
            print '[!] 核心文件生成出错'
            return None
        # self.KeyWorkReplace(runEncryTemplateCopy, {'__s_@_s__secret':'secret_Generate', '__s_@_s__md5Key':'cs_author_Generate'})
        return outpath

    # 生成Key文件
    def GenKeyFile(self):
        destPyName = os.path.basename(self.m_destPyPath)
        entryFile = 'SMain.py'
        entryPath = os.path.join(self.m_outFolder, entryFile)
        runCodePath = os.path.join(self.m_outFolder, 'Module/SRunEncryptCode.cs')
        gen = GenerateKeyFile()
        gen.m_crypt = self.m_codeAlgo()
        gen.m_md5Key = self.m_Md5Key
        gen.m_secret = self.m_SecretKey
        gen.m_outPath = os.path.join(self.m_outFolder, 'Module')
        gen.Generate([entryPath, runCodePath], os.path.join(self.m_outFolder, 'tMain.template'))

    def GenSign(self):
        sign = '''
from SLoadModule import CsFileLoad
import os
def Sign():
    signPath = os.path.join("{0}", 'Module/SSign.cs')
    csLoad = CsFileLoad()
    csRunModel = csLoad.CsLoadFun(signPath)
    csRunModel.Sign()

def {1}():
    Sign()
        '''.format(self.m_outFolder, gMainEntryFun)
        
        print '[*] 开始签名嵌入'
        tmpMainPath = os.path.join(self.m_outFolder, 'tMain.template')
        shutil.copy(self.m_destPyPath, tmpMainPath)
        if os.path.exists(os.path.join(self.m_outFolder, 'Module')) == False:
            os.mkdir(os.path.join(self.m_outFolder, 'Module'))
        shutil.copy(os.path.join(self.m_SelfPathDir, 'SSign.cs'), os.path.join(self.m_outFolder, 'Module'))
        with open(tmpMainPath, 'r+') as fReader:
            datas = fReader.read()
            datas = datas.replace('def {0}():'.format(gMainEntryFun), sign)
            with open(tmpMainPath, 'w+') as fWriter:
                fWriter.write(datas)
        # self.m_destPyPath = tmpMainPath
        

    def GenNeedDependeLib(self):
        loadModuelFilePath = os.path.join(self.m_SelfPathDir, 'SLoadModule.py')
        CryptoFolder = os.path.join(self.m_SelfPathDir, 'Crypto')

        shutil.copy(loadModuelFilePath, self.m_outFolder)
        shutil.copytree(CryptoFolder, os.path.join(self.m_outFolder, 'Crypto'))

    def checkPathValid(self):
        print '[*] 相关检测'
        # if os.path.exists(self.m_algoAlgoPath) == False:
        #     print '[-] 算法文件不存在'
        #     return False
        if os.path.exists(self.m_destPyPath) == False:
            print '[-] 目标py文件不存在'
            return False
        self.m_destPyFolder = os.path.dirname(self.m_destPyPath)
        self.m_outFolder = os.path.join(self.m_destPyFolder, 'Output')
        # 创建目录
        try:
            if os.path.exists(self.m_outFolder):
                shutil.rmtree(self.m_outFolder)
            
            print '[*] 开始创建目录 > ' + self.m_outFolder 
            os.mkdir(self.m_outFolder)
        except Exception, e:
            print '[!] 文件创建出错'
            return False
        

        return True
    def GenStartCommand(self):
        print '[*] 生成启动脚本start.command'
        startpath = os.path.join(self.m_outFolder, '{0}.command'.format(os.path.basename(self.m_destPyPath)[0:-3]))
        shutil.copy(os.path.join(self.m_SelfPathDir, 'TemplateFile/startS.command'), startpath)
        self.KeyWorkReplace(startpath, {'__s_@_s__mainEntry':'SMain.py'})

    def cleanup(self):
        print '[*] 清除无效文件'
        os.remove(os.path.join(self.m_outFolder, 'SRunEncryptCode.py'))
        os.remove(os.path.join(self.m_outFolder, 'tMain.template'))
        # os.remove(os.path.join(self.m_outFolder, 'SSign.py'))
    def start(self):
        if self.checkPathValid() == False:
            return
        entryPath = self.GenEntryFile()
        codeRunPath = self.GenRunEncryptCodeFile()
        self.KeyWorkReplace(entryPath, {'__s_@_s__Algo':'{0}'.format(self.m_codeAlgo.__name__), '__s_@_s__key':'SMain.cs_e', '__s_@_s__entry':gMainEntryFun})
        self.KeyWorkReplace(codeRunPath, {'__s_@_s__secret':self.m_SecretKey, '__s_@_s__md5Key':self.m_Md5Key})
        self.GenSign()
        self.encodeCsFile()
        self.GenKeyFile()
        self.GenNeedDependeLib()
        self.GenStartCommand()
        self.cleanup()

        print '[*] 所有操作完成'

def handleOption():
    if len(sys.argv) != 4:
        print '出错了'
        sys.exit(-1)
    # 要加密脚本的路径
    destPyPath = sys.argv[1]
    # # 内置算法模板的路径
    # innertAlgoPath = sys.argv[2]
    # # 选用代码加解密的算法
    codeAlgo = sys.argv[2]
    global gMainEntryFun
    gMainEntryFun = sys.argv[3]
    gen = SGenPy()
    gen.m_codeAlgo = eval(codeAlgo) #AlgoAES
    print gen.m_codeAlgo
    # gen.m_algoAlgoPath = destPyPath 
    gen.m_destPyPath = destPyPath
    try:
        gen.start()
    except Exception, e:
        print '[!] 脚本运行出错了！！！'


def main():
    handleOption()
    
    


if __name__ == '__main__':
    main()

    # print  os.path.join('path/', 'S_Algo/{0}.cs'.format(AlgoAES.__name__))
    

