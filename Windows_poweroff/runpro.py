
#-- coding:utf-8 --
# > nul 2>&1 || cd "%~dp0" && python "%~0" && goto :eof
import win32api
import win32process
import os
# 在ProPath中添加希望自动启动的程序的完整路径
# 注意路径之间的分割符是 双反斜线  \\
ProPath = ('C:\\Program Files (x86)\\JetBrains\\PyCharm 4.5.3\\bin\\pycharm64.exe',
	       'C:\\Program Files (x86)\\Navicat for MySQL\\navicat.exe',
	       )

for propath in ProPath:
	win32process.CreateProcess(propath, '', None , None , 0 ,win32process. CREATE_NO_WINDOW , None , None ,win32process.STARTUPINFO())


