
import os, win32api, win32pdh
aa=win32pdh.EnumObjectItems(None,None,'process',win32pdh.PERF_DETAIL_WIZARD)
print aa