---
layout: post
title: 2024-03-01-Delphi与Qt在Windows下使用共享内存进程间通信
subtitle: 
aliases: 
date: 2024-03-01 09:18:49
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - cpp
  - 转载
  - 共享内存
typora-copy-images-to: ../img/post
typora-root-url: ../
---
原文地址：[Delphi与Qt在Windows下使用共享内存进程间通信](https://www.cnblogs.com/danju/p/3691513.html)

**Delphi部分**

```delphi
type  
  TGuardInfo=record  
    Lock: Integer;  
  end;  
  PGuardInfo = ^TGuardInfo;  
  
  TGuardShareMem=class  
  private  
    FHandle: THandle;  
    FGuardInfo: PGuardInfo;  
  public  
    constructor Create;  
    destructor Destroy; override;  
    function GetGuardInfo: PGuardInfo;  
  end;  
  
{ TGuardShareMem }  
  
constructor TGuardShareMem.Create;  
begin  
  FHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0,  
    SizeOf(TGuardInfo), PChar('guardinfo_2013'));  
  FGuardInfo := MapViewOfFile(FHandle, FILE_MAP_WRITE or FILE_MAP_READ, 0, 0,  
    sizeof(TGuardInfo));  
  FGuardInfo.Lock := 0;  
end;  
  
destructor TGuardShareMem.Destroy;  
begin  
  UnmapViewOfFile(FGuardInfo);  
  CloseHandle(FHandle);  
  inherited;  
end;
```

**Qt部分**

```cpp
struct GuardInfo  
{  
    qint32 lock;  
};  
  
bool lock()  
{  
    QSharedMemory sharedMemory;  
    sharedMemory.setNativeKey("guardinfo_2013");  
    if (!sharedMemory.attach())  
    {  
        qDebug()<<"atttach fail";  
        return false;  
    }  
    GuardInfo *p= (GuardInfo *)sharedMemory.constData();  
    qDebug()<<p->lock;  
    p->lock = 212;  
    return true;  
}
```

注：其中的key是native的类型，主要是用来和原生系统进行通信的。直接setkey只能和qt自己的进行通信。