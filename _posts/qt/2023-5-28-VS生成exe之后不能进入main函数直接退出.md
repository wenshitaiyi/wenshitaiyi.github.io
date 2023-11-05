---
layout: post
title: VS生成exe之后不能进入main函数直接退出
subtitle: VS调试问题
date: 2023-05-28 10:15:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,VS,调试]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# VS生成exe之后不能进入main函数直接退出

```
The thread 'Win32 Thread' (0x8274) has exited with code 1 (0x1).
The thread 'Win32 Thread' (0x2cbc) has exited with code 1 (0x1).
The thread 'Win32 Thread' (0x6854) has exited with code 1 (0x1).
The program '[17672] Test.exe: Native' has exited with code 1 (0x1).
```

注：`Must construct qapplication before Qwidget` [必须构造一个`qapplication`对象，在使用`QWidget`之前]

错误代码示例如下：

```cpp
//cpp文件
QTreeWidget *treeWidget=new QTreeWidget();
Test::Test(QWidget *parent)
	: QMainWindow(parent) {
	ui.setupUi(this);
}
```

如果这是一个可执行程序工程中的cpp文件，则在F5运行后，会先将所有cpp文件中的全局变量初始化，上述代码中new了一个QTreeWidget对象，这个时候QT的GUI框架还没有起来，所以会有问题。