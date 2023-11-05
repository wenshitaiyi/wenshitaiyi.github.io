---
layout: post
title: qInitResources_images 函数未定义
subtitle: 资源文件编译文字
date: 2023-06-25 10:06:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,编译]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# qInitResources_images 函数未定义

```cpp
Q_INIT_RESOURCE(images);
Q_INIT_RESOURCE(MainWindow);
```

当该宏传入的名称不是当前项目的资源文件时，会报上述类似的问题，说函数没有实现。

在QT的源码中写的是images.qrc，然后迁移到本地后调整为MianWindow.qrc的文件，此时在main函数中是需要调整的。

如果只是QT的pro工程，直接使用QTCreator进行编译就好了，没必要转换成VS的工程，再配置一遍。

## 关于Q_INIT_RESOURCE

Initializes the resources specified by the .qrc file with the specified base *name*. Normally, when resources are built as part of the application, the resources are loaded automatically at startup. The Q_INIT_RESOURCE() macro is necessary on some platforms for resources stored in a static library.

Note: This macro cannot be used in a namespace. It should be called from main(). If that is not possible, the following workaround can be used to init the resource myapp from the function MyNamespace::myFunction:

注：只能用在main函数中。

## 其他

目前对于QTCreator的编译流程还不是很熟悉，针对于这项，有一些疑问需要在以后的工作过程中确认：

 - 如何快速学会一个IDE？
   - pycharm、unity、ue、vscode、vs2019、qtcreator···
 - 如果快速进行环境配置，是否有通用之处？
   - git？
 - 国产化开发有哪些常用的技能？
 - 拿到一个新东西之后，怎么才能快速上手？到什么程度才算入门？
   - 入门宝典？快速指南？官方手册？
 - 终极一问：如何快速上手一门语言？
   - 比如OpenGL、osg、shader这种都是有门槛的，还能像学习C++、C语言一样吗？