# !/usr/bin/python
#coding:utf-8

#code by cs



from Crypto.Cipher import AES

from Crypto.Cipher import Blowfish
from struct import pack
from Crypto.Hash import MD5
from Crypto import Hash
from Crypto.Hash import HMAC
from Crypto.Cipher import XOR
from Crypto import Random
from binascii import b2a_hex, a2b_hex

class ICryptAlgo(object):
    def __init__(self, *args):
        super(ICryptAlgo, self).__init__(*args)
        self.m_baseKey = 'baseKey'
        self.m_baseName = 'baseName'
    def encrypt(self, text):
        raise Exception('没有实现')
    def decrypt(self, text):
        raise Exception('没有实现')


class AlgoAES(ICryptAlgo):
    def __init__(self, *args):
        super(AlgoAES, self).__init__(*args)
        self.m_baseName = 'AES算法'
        self.m_baseKey = '1234567890123456'
        self.iv  = 'This is an IV456'
        self.mode = AES.MODE_CBC
        self.BS = AES.block_size
        self.pad = lambda s: s + (self.BS - len(s) % self.BS) * chr(self.BS - len(s) % self.BS)
        self.unpad = lambda s : s[0:-ord(s[-1])]

    def encrypt(self, text):
        text = self.pad(text)
        self.obj1 = AES.new(self.m_baseKey, self.mode, self.iv)
        self.ciphertext = self.obj1.encrypt(text)
        return b2a_hex(self.ciphertext)
    
    def decrypt(self, text):
        self.obj2 = AES.new(self.m_baseKey, self.mode, self.iv)
        plain_text  = self.obj2.decrypt(a2b_hex(text))
        return self.unpad(plain_text.rstrip('\0'))

def main():
    algo = AlgoAES()
    t = algo.encrypt('sdfsdf')
    print t
    print algo.decrypt(t)
    print algo.m_baseName

if __name__ == '__main__':
    main()
    