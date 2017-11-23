# !/usr/bin/python
#coding:utf-8

#code by cs

from Crypto.Hash import MD5
from Crypto import Hash
from Crypto.Hash import HMAC
from Crypto.Cipher import AES
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

class AlgoXor(ICryptAlgo):
    def __init__(self, *args):
        super(AlgoXor, self).__init__(*args)
        self.m_baseKey = 'An arbitrarily long key'
        self.m_baseName = 'xor算法'
    def encrypt(self, text):
        self.obj1 = XOR.new(self.m_baseKey)
        self.ciphertext = self.obj1.encrypt(text)
        return b2a_hex(self.ciphertext)
    
    def decrypt(self, text):
        self.obj2 = XOR.new(self.m_baseKey)
        plain_text  = self.obj2.decrypt(a2b_hex(text))
        return plain_text

def main():
    algo = AlgoXor()
    algo.m_baseKey = 'cssssss'
    t = algo.encrypt('esfdf')
    print t
    print algo.decrypt(t)
    print algo.m_baseName

if __name__ == '__main__':
    main()
    