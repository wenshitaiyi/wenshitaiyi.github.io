---
layout: post
title: Qwidget新手避坑
subtitle: Must construct a Qapplication before a Qwidget
date: 2023-05-21 00:00:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QWidget]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# 新手避坑："QWidget: Must construct a Qapplication before a Qwidget"错误

## 问题

该错误信息表示在创建 QWidget（窗口部件）之前必须先创建 QApplication（应用程序）。这是因为 QApplication 在创建 QWidget 之前会进行一些初始化操作，确保正确运行应用程序。

要解决这个错误，您需要在创建 QWidget 之前先创建 QApplication。以下是处理该错误的常见方法：

1. 在 main() 函数中创建 QApplication 对象：
```cpp
#include <QApplication>
#include <QWidget>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    // 创建 QWidget 对象或其他窗口部件
    QWidget widget;
    widget.show();

    return app.exec();
}
```

在这个例子中，我们在 main() 函数中首先创建了 QApplication 对象 `app`，然后再创建 QWidget 对象 `widget`。请确保在创建 QWidget 或其他窗口部件之前创建 QApplication。

2. 确认应用程序只有一个 QApplication 对象：
如果您的应用程序已经有了 QApplication 对象，而且在创建 QWidget 之前已经正确创建和设置了 QApplication 对象，请确保不要重复创建 QApplication 对象。在这种情况下，可能是由于代码逻辑问题导致重复创建了 QApplication 对象。

3. 检查头文件和源文件的包含顺序：
在包含 QWidget 相关的头文件之前，确保先包含 QApplication 的头文件。例如：
```cpp
#include <QApplication>
#include <QWidget>

// 其他代码
```

这样可以确保 QApplication 类的定义在 QWidget 之前可用。

## 注意

刚开接触QT的时候对于怎么创建工程，怎么找添加一个GUI类可能都处于一知半解的状态，这种情况下会因为一个很小的配置项产生出来很呆瓜的问题，如果能搜索到相关问题还比较好解决，搜索不到的情况下，最好是直接新建工程，使用compare对比工具对于两个工程进行对比，看看具体哪些配置出现了偏差。

当然了，上述情况并非是因配置异常而出现了，可能是因为误删，毕竟新手不知道误删了内容，比如刚开始的我！针对当前这个问题，需要理解的是GUI工程大致的运行原理，相关的uic，rcc，moc的过程也是需要了解的，但是这个时候只知道有这么写个过程，比如：一个文件要想被moc，其在VS中的编译选项是怎样的，与普通的cpp文件有哪些差别。

常识性的问题大致了解之后，可以更少的踩坑。

> 想到一个很好笑的事情，刚开始接触java的时候使用`class`作为了类名，导致出现了很离谱的编译错误，但是却怎么也查不到 [那个时候还只会百度]

往往，因为了解的少，不知道解决方向，而盲目操作，会让代码中的错误越来越多，直到打击了编码自信！