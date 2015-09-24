#-*- coding:utf-8 -*-
import ctypes
import win32pdh
import  psutil
def kill(pid): 
    """kill function for Win32""" 
    kernel32 = ctypes.windll.kernel32 
    handle = kernel32.OpenProcess(1, 0, pid) 
    #使用termina函数结束进程 
    return (0 != kernel32.TerminateProcess(handle, 0)) 

# kill(12212)
# kill(14680)

# p = psutil.Process(704)
# uname = p.username()
pid = 6208
p = psutil.Process(pid)
try:
    uname = p.username()
    print uname
    # uname.split
    print type(uname)
    utfname = uname.encode('utf-8')
    print type(utfname)
    print utfname
    unamearr = utfname.split('\\')
    print unamearr[1]
    print unamearr[1] == 'yi.zhang'
    kill(pid)
except:
    pass