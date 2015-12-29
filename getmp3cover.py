#!/usr/bin/env python
# coding=utf-8
#! /usr/bin/env python
# Ref: http://robotexp.blogspot.tw/2010/02/python-curl.html

import pycurl
import sys

class GetPage:
	def __init__ (self, url):
		elf.contents = ''
		elf.url = url

	def read_page (self, buf):
		self.contents = self.contents + buf

	def show_page (self):
		print self.contents

	def savetofile (self):
		file_mp3_cover = open('mp3cover.html', 'w')
		file_mp3_cover.write(self.contents)
		file_mp3_cover.close()

class GetPageByFakeBrowser(GetPage):
	def __init__ (self, url, ua):
		self.contents = ''
		self.url = url
		self.ua = ua

http_link="https://www.kkbox.com/tw/tc/search.php?search=mix&word="+sys.argv[1]+"&lang=tc"
#"https://www.kkbox.com/tw/tc/search.php?search=mix&word=$album_name&lang=tc", \
mypage = GetPageByFakeBrowser( \
http_link, \
"Mozilla/5.0 (Windows NT 5.1; rv:43.0) Gecko/20100101 Firefox/43.0")
testcurl = pycurl.Curl()
testcurl.setopt(testcurl.URL, mypage.url)
testcurl.setopt(testcurl.USERAGENT, mypage.ua)
testcurl.setopt(testcurl.WRITEFUNCTION, mypage.read_page)
testcurl.perform()
testcurl.close()
#show page
#mypage.show_page()
#save page
mypage.savetofile()
#file_mp3_cover = open('mp3cover.html', 'w')
#file_mp3_cover.write(mypage.get_value())
#file_mp3_cover.close()
