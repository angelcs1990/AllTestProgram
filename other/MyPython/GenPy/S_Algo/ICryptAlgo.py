# !/usr/bin/python
#coding:utf-8

#code by cs


class ICryptAlgo(object):
    def __init__(self, *args):
        super(ICryptAlgo, self).__init__(*args)
        self.m_baseKey = 'baseKey'
        self.m_baseName = 'baseName'
    def encrypt(self, text):
        raise Exception('没有实现')
    def decrypt(self, text):
        raise Exception('没有实现')

class TestAlgo(ICryptAlgo):
    def __init__(self, *args):
        super(TestAlgo, self).__init__(*args)
    def encrypt(self, text):
        print 'encrypt test' + text + self.m_baseName
    def decrypt(self, text):
        print 'decrypt test' + text + self.m_baseName

def main():
    algo = TestAlgo()
    algo.encrypt('ttt')
    algo.decrypt('xxx')

if __name__ == '__main__':
    main()
    




        