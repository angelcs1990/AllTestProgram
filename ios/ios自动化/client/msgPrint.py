#!/bin/bash
#coding:utf-8

#code by cs
def consolePrint(msg):
	print '\033[31m' + "[提示]" + msg + '\033[0m'
def actionPrint(msg):
	print '\033[32m' + "[操作]" + msg + '\033[0m'
def errPrint(msg):
	print '\033[33m' + "[终止运行]" + msg + '\033[0m'