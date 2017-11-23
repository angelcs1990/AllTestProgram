# !/usr/bin/python
#coding:utf-8

#code by cs

import py_compile
import sys
import os


# 扫描所有py文件
def listDir(path, filter, outFiles):
    for file in os.listdir(path):
        tmpFilePath = os.path.join(path, file)
        if os.path.isdir(tmpFilePath):
            continue
        else:
            if file.endswith(filter):
                outFiles.append(tmpFilePath)
    return outFiles

def checkPathValid(path, isCreate = False):
    tmpRet = os.path.exists(path)
    if tmpRet == False and isCreate:
        os.makedirs(path)
        

    return path

def signWrite(path):
    with open(path, 'r+') as fHander:
        with open(path + 'bk', 'w+') as ftmpWt:
            ftmpWt.write('cs')
            data = fHander.read()
            ftmpWt.write(data)
    os.remove(path)
    os.rename(path + 'bk', path)

def main():
    if len(sys.argv) != 3:
        print '出错了' + str(len(sys.argv))
        sys.exit(1)
    filePath = checkPathValid(sys.argv[1])
    outputPath = checkPathValid(sys.argv[2], True)
    allPyFiles = listDir(filePath, '.py', [])
    try:
        for itemPy in allPyFiles:
            py_compile.compile(itemPy)
            (tmpFilePath, tmpFileName) = os.path.split(itemPy)
            (fileName, exteName) = os.path.splitext(tmpFileName)
            cmdLine = 'cp ' + tmpFilePath + '/' + fileName + '.pyc ' + os.path.join(outputPath, fileName + '.cs')
            os.system(cmdLine)
            
            signWrite(os.path.join(outputPath, fileName + '.cs'))
        cleanCmd = 'rm ' + filePath + '/*.pyc'
        os.system(cleanCmd)
    except Exception, e:
        print e
    

if __name__ == '__main__':
    main()