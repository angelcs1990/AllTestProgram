#! /usr/bin/python
#coding:utf-8

#code by cs

import sys
import os
from xml.etree import ElementTree as ET

g_outputFolder = '/Users/chensi/Desktop/SRouterPlist/output'
g_projectFolder = '/Users/chensi/project/github/SRouter'
g_preTag = 'module'

# 遍历所有SRouter开头的文件
def dirlist(path, ignore, allfile):  
    filelist =  os.listdir(path)  
  
    for filename in filelist:  
        filepath = os.path.join(path, filename)  
        if os.path.isdir(filepath):  
            dirlist(filepath, ignore, allfile)  
        else:  
            if filepath.endswith(ignore):
                allfile.append(filepath)  
    return allfile
def filterFiles(paths, prefix):
    retValue = []
    for itemPath in paths:
        if os.path.basename(itemPath).startswith(prefix):
            retValue.append(itemPath)
    return retValue
def saveFile(plistPath, outputDir):
    if not os.path.exists(plistPath):
        return;
    root = ET.parse(plistPath)
    retNodes = root.findall('array')[0]
    tmpArray = []
    for itemNode in retNodes:
        tmpDict = {}
        for i in xrange(0, len(itemNode) / 2, 2):
            tmpDict[itemNode[i].text] = itemNode[i + 1].text
        tmpArray.append(tmpDict)
    print tmpArray

    

    tmpBaseName = os.path.basename(plistPath)

    tmpFileName = tmpBaseName.split('.')[0] + '.h'
    savePathFile = outputDir + '/' + tmpFileName
    f = open(savePathFile, 'wb')
    f.write('#ifndef ' + tmpFileName.upper().replace('.', '_') + '\n#define ' + tmpFileName.upper().replace('.', '_') + '\n')
    for item in tmpArray:
        tmpName = item.get('name')
        tmpMacro = item.get('macroName')
      
        f.write('NSString *const ' + tmpMacro + ' = @"' + tmpName + '";\n')
    f.write('#endif\n')
    f.close()
def main():
    tmpRet = dirlist(g_projectFolder, 'plist',[])
    tmpRet = filterFiles(tmpRet, g_preTag)
    for item in tmpRet:
        saveFile(item, g_outputFolder)
    
if __name__ == '__main__':
    main()