#-*- coding:utf-8 -*-
# > nul 2>&1 || cd "%~dp0" && python "%~0" && goto :eof
import win32pdh
import ctypes
import psutil
import os, time, types
import getpass
from os import system

win32pdh.EnumObjects(None, None, win32pdh.PERF_DETAIL_WIZARD)
junk, instances = win32pdh.EnumObjectItems(None,None,'Process', win32pdh.PERF_DETAIL_WIZARD)
proc_dict = {}
for instance in instances:
    if proc_dict.has_key(instance):
        proc_dict[instance] = proc_dict[instance] + 1
    else:
        proc_dict[instance]=0
# for instance in instances:
# 	print instance, ':',proc_dict[instance]

proc_ids = []
for instance, max_instances in proc_dict.items():
    for inum in xrange(max_instances+1):
        hq = win32pdh.OpenQuery() # initializes the query handle 
        try:
            path = win32pdh.MakeCounterPath( (None, 'Process', instance, None, inum, 'ID Process') )
            counter_handle=win32pdh.AddCounter(hq, path) #convert counter path to counter handle
            try:
                win32pdh.CollectQueryData(hq) #collects data for the counter 
                type, val = win32pdh.GetFormattedCounterValue(counter_handle, win32pdh.PDH_FMT_LONG)
                proc_ids.append((instance, val))
            except win32pdh.error, e:
                #print e
                pass

            win32pdh.RemoveCounter(counter_handle)

        except win32pdh.error, e:
            #print e
            pass
        win32pdh.CloseQuery(hq) 
        
def kill(pid): 
    """kill function for Win32""" 
    kernel32 = ctypes.windll.kernel32 
    handle = kernel32.OpenProcess(1, 0, pid) 
    #使用termina函数结束进程 
    return (0 != kernel32.TerminateProcess(handle, 0))
pids_kill = []
for proc in proc_ids:
    try:
        p = psutil.Process(proc[1])
        try:
            uname = p.username()
            # print uname
        except:
            pass
            # print 'not user process', proc
        else:
            # utfname = uname.encode('utf-8')
            # print utfname
            unamearr = uname.encode('utf-8').split('\\')
            if(unamearr[1] == getpass.getuser()):
                # print 'killed th process', proc
                # print proc[1]
                if(proc[0].encode('utf-8').lower() not in ('python', 'explorer','cmd','conhost')):
                    # kill(proc[1])
                    # print proc
                    pids_kill.append(proc[1])
    except:
        pass

for pid_kill in pids_kill:
	kill(pid_kill)
	
cmd="cmd.exe /k shutdown -s -t 0";
os.system(cmd);