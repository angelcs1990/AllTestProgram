# !/usr/bin/python
#coding:utf-8


#code by cs
from struct import pack
from binascii import b2a_hex, a2b_hex
import sys
import os



# print sys.path.append(os.path.basename(__file__).join('S_Algo'))
# print os.path.basename(__file__).join('S_Algo')
#算法部分，不需要的可以删掉
from S_Algo.ICryptAlgo import ICryptAlgo
from S_Algo.AlgoAES import AlgoAES

from Crypto.Cipher import blockalgo
from Crypto.Cipher import AES
from Crypto.Cipher import Blowfish
from Crypto import Hash
from Crypto.Hash import HMAC
from Crypto.Hash import MD5
from Crypto import Random

class GenerateKeyFile():
    def __init__(self, secret = 'secret_Generate', md5Key = 'cs_author_Generate', cryptAlgo = ICryptAlgo()):
        self.m_md5Key = md5Key
        self.m_secret = secret
        self.m_crypt = cryptAlgo
        self.m_outPath = None

    def Generate(self, srcFilePaths, templateFilePath):
        if self.m_crypt == None:
            print '加密算法没有设置'
            return

        md5Gen = MD5.new()
        md5Gen.update(self.m_md5Key)
        md5Value = md5Gen.hexdigest()
        print 'md5Key:' + self.m_md5Key
        print 'md5Value:' + md5Value

        hmacSha256 = HMAC.new(self.m_secret, digestmod = Hash.SHA256)
        srcFilePath = srcFilePaths[0]

        for filePath in srcFilePaths:
            with open(filePath, 'r') as fReader:
                keyData = fReader.read()
                hmacSha256.update(keyData)
        hmacSha256.update(md5Value)
        hashValue = hmacSha256.hexdigest()

        

        self.m_crypt.m_baseKey = hashValue[16:-16]

        print 'hashKey:' + self.m_crypt.m_baseKey
        
        (basename, extName) = os.path.splitext(os.path.basename(srcFilePath))
        if self.m_outPath != None:
            savePath = os.path.join(self.m_outPath,  basename + '.cs_e')
        else:
            savePath = os.path.dirname(srcFilePath)
            savePath = os.path.join(savePath,  basename + '.cs_e')

        with open(templateFilePath, 'r') as freader:
            with open(savePath, 'w+') as fwriter:
                rData = freader.read()
                eData = self.m_crypt.encrypt(rData)
                fwriter.write(eData)
    
def main():
    #FileEy_MacV2
    # gen = GenerateKeyFile('secret_coderun', 'cs_author_codeRun', ct2())
    # gen.Generate(['/Users/xxx/Desktop/myself_i8n/FileEncrypt/src/FileEy_MacV2.py', '/Users/xx/Desktop/myself_i8n/FileEncrypt/src/CodeRun.cs'], '/Users/xxx/Desktop/myself_i8n/FileEncrypt/src/FileEy_MacV2_Template1.txt')

    gen = GenerateKeyFile('secret_coderun', 'cs_author_codeRun', AlgoAES())
    gen.Generate(['/Users/xxx/Desktop/myself_i8n/FileEncrypt/PyUntiHack/MyTestPy/main.py', '/Users/xx/Desktop/myself_i8n/FileEncrypt/PyUntiHack/MyTestPy/release_sign/SRunEncryptCode.cs'], '/Users/xxx/Desktop/myself_i8n/FileEncrypt/PyUntiHack/MyTestPy/test.py',)

if __name__ == '__main__':
    main()






 
