# !/usr/bin/python
#coding:utf-8

#code by cs


from Crypto.Hash import MD5
from Crypto import Hash
from Crypto.Hash import HMAC
from Crypto.Cipher import AES
from Crypto.Cipher import XOR
from Crypto import Random
import random
import shutil

from binascii import b2a_hex, a2b_hex
import struct
import sys
import os

# from S_Algo.ICryptAlgo import ICryptAlgo
from SLoadModule import CsFileLoad

s_global_secret = '__s_@_s__secret'
s_global_md5Key = '__s_@_s__md5Key'

#插入算法替换，如果是单独用这个文件，可以注释掉该段代码
# def _decodeAlgoG(datas):
#     pass

class CodeRun():
    __m_globals = {}

    def __init__(self, cryptAlgo):
        self.crypt = cryptAlgo
        self.m_secret = s_global_secret
        self.m_md5Key = s_global_md5Key


    def _decodeAlgo(self, algoPath):
        if os.path.exists(algoPath):
            print '关键文件不存在'
            return sys.exit(-1)
        (baseName, extName) = os.path.splitext(os.path.basename(algoPath))
        with open(algoPath, 'r') as fReader:
            algoDatas = fReader.read()
            decodeDatas = _decodeAlgoG(algoDatas)
            csLoad = CsFileLoad()
            tModel = csLoad.CsLoadMemoryData(baseName, baseName, decodeDatas)
        return tModel

    def _execute(self, content):
        exec(content, CodeRun.__m_globals, CodeRun.__m_globals)

    def execEncryptCode(self, text, key,fun):
        CodeRun.__m_globals = {}
        plCode = ''

        try:
            self.crypt.m_baseKey = key
            plCode = self.crypt.decrypt(text)
        except Exception, e:
            plCode = text
        
        try:
            code = compile(plCode, '', 'exec')
            self._execute(code)
        except Exception, e:
            print '解码出错了:' + str(e)
            return None
        return CodeRun.__m_globals.get(fun)()
    def runFun(self, fun):
        return CodeRun.__m_globals.get(fun)()

    def GetHash(self, iv = 'cs_xxxxxx'):
        h = HMAC.new(self.m_secret, digestmod = Hash.SHA256)
        hashKey = ''

        for filePath in self.paths:
            # print filePath
            with open(filePath, 'r') as fHander:
                data = fHander.read()
                h.update(data)
        h.update(iv)
        hashKey = h.hexdigest()
        
        return hashKey
    def GetFunction(self, keyFilePath, srcFilePaths, fun): 
        h = MD5.new()
        h.update(self.m_md5Key)
        td5 = h.hexdigest()
        # print 'SRunEncryptCode(MD5Key):' + 'cs_author_codeRun'
        # print 'SRunEncryptCode(MD5):' + td5
        keyPath = keyFilePath
        self.paths = srcFilePaths
        

        deData = ''
        cf = None
        if os.path.exists(keyPath) == False:
            print '关键文件不存在'
            return

        with open(keyPath, 'r') as fHandler:
            data = fHandler.read()
            tHash = self.GetHash(td5)
            # print 'SRunEncryptCode(HASH):' + tHash
            cf = self.execEncryptCode(data, tHash[16:-16], fun)
            
        return cf

def main():
    h = MD5.new()
    h.update(b'cs_author_codeRun')
    td5 = h.hexdigest()
    print td5


if __name__ == '__main__':
    main()