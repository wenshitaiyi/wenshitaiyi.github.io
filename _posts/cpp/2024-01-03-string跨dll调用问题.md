---
layout: post
title: string跨dll调用问题
subtitle: 
aliases: 
date: 2024-01-03 16:11:01
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - cpp
  - DLL
  - 编译
typora-copy-images-to: ../../img/post
typora-root-url: ../../
---
## 1 问题描述
关于C++，我遇到一个情况。我实现了一个dll，主要实现了函数‘virtual bool fun_test(const string& path) = 0’，其中string是std::string，但是提前声明了。在另外一个exe中，调用该函数。调试状态下传入的string地址都是一样的，但是在exe中有内容，传递到函数fun_test中就看不到内容了，可能是因为什么？
## 2 解决方案
在debug模式下调用debug生成的dll没有问题，调用release生成的dll就会出现参数传递了，但是内部的值却不存在的情况。
## 3 相关问题
为了解决该问题，搜索过程中也发现了类似的问题，如下：
- [vs2012中std::string通过DLL传参报错-解决方法\_std::string dll 参数-CSDN博客](https://blog.csdn.net/weixin_42096202/article/details/108651357)
- [关于Vector等STL容器作为dll函数接口参数的问题\_c++ dll接口 vector用什么替代-CSDN博客](https://blog.csdn.net/xuelangwin/article/details/53836327)
- [C++中string跨DLL失败解决途径 - 努力奋斗的阿贝拉 - 博客园](https://www.cnblogs.com/abella/p/9582549.html)