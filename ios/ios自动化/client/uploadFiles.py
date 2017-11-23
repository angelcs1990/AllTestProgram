#coding=utf-8

import requests
import os
import sys

import msgPrint as mp

# url = 'http://httpbin.org/post'
# files = {'file':('my.txt', open('1.pyc', 'rb')),'file2':('my2.txt', open('2.py', 'rb'))}
# r = requests.post(url, files=files)
# print r.text
# r = requests.get(url)
# print r.text.encode('utf-8')
# print r.encoding


class AutoUploadFiles(object):
	"""docstring for AutoUploadFiles"""
	def __init__(self, serverUrl = None):
		super(AutoUploadFiles, self).__init__()
		self.__serverUrl = serverUrl

	def uploadFiles(self, files):
		"""
		参数:files-字典类型{'对应form的name':'filePath'}
		描述:文件上传
		返回:False or True
		"""
		mp.actionPrint("开始执行文件上传")
		# 安全检测
		if self.__serverUrl == None or isinstance(files, dict) == False or len(files) == 0:
			print 'return'
			return False
		try:
			url = self.__serverUrl
			uploadFiles = {}
			for key,value in files.items():
				if os.path.exists(value):
					uploadFiles[key] = (os.path.basename(value), open(value, 'rb'))
					mp.consolePrint("上传文件：" + os.path.basename(value))
				else:
					mp.consolePrint(value + '文件不存在')
			if len(uploadFiles) == 0:
				mp.consolePrint("文件上传失败")
				mp.actionPrint("结束文件上传")
				return False
			r = requests.post(url, files=uploadFiles, verify=False)
			if r.status_code == 200:
				mp.consolePrint("文件上传成功")
		except Exception, e:
			print str(e)
			mp.consolePrint("文件上传失败")
			mp.actionPrint("结束文件上传")
			return False
		mp.actionPrint("结束文件上传")
		return True

if __name__ == '__main__':
	if len(sys.argv) != 3:
		mp.consolePrint("例子：uploadFiles.py \"http://xxxxxx\" \"{\"xxx\":\"xxx\"}\" ")
		sys.exit(1)
	mp.consolePrint("上传地址为：" + sys.argv[1])
	auf = AutoUploadFiles(sys.argv[1])
	dictParams={};
	try:
		dictParams = eval(sys.argv[2])
		if(auf.uploadFiles(dictParams) == False):
			sys.exit(1)
	except Exception, e:
		mp.consolePrint(str(e))
		sys.exit(1)

	# auf.uploadFiles({'file1':'6.pyc', 'file2':'2.py'})
# auf = AutoUploadFiles('http://httpbin.org/post')
# auf = AutoUploadFiles('https://192.168.31.70:9998/file_upload')
# auf.uploadFiles({'file1':'6.pyc', 'file2':'2.py'})
