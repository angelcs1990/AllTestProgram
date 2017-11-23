# !/usr/bin/python
#coding:utf-8

#code by cs

import imp, marshal
import os
import sys

class CsFileLoad():
    def __init__(self):
        pass
    def CsLoadMemoryData(self, name, filename, data, ispackage=False):
        if data[2:6]!=imp.get_magic():
            raise ImportError('Bad magic number in %s' % filename)
        code = marshal.loads(data[10:])
        imp.acquire_lock() # Required in threaded applications
        try:
            mod = imp.new_module(name)
            sys.modules[name] = mod # To handle circular and submodule imports 
                                    # it should come before exec.
            try:
                mod.__file__ = filename # Is not so important.
                # For package you have to set mod.__path__ here. 
                # Here I handle simple cases only.
                if ispackage:
                    mod.__path__ = [name.replace('.', '/')]
                exec code in mod.__dict__
            except:
                del sys.modules[name]
                raise
        finally:
            imp.release_lock()
        return mod
    def CsLoadFun(self, csfilepath):
        if os.path.exists(csfilepath) == False:
            print '文件不存在'
            return None

        (baseName, extName) = os.path.splitext(os.path.basename(csfilepath))

        tFun = None

        with open(csfilepath, 'rb') as fReader:
            tFunData = fReader.read()
            tFun = self.CsLoadMemoryData(baseName, baseName, tFunData)

        return tFun
