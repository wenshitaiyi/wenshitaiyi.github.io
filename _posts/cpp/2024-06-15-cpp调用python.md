---
layout: post
title: 
subtitle: 
aliases: 
date: 2024-06-15 20:51:08
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - cpp
  - python
typora-copy-images-to: ../../img/post
typora-root-url: ../../
---
一些参考资料：
- [1. 使用 C 或 C++ 扩展 Python — Python 3.10.13 文档](https://docs.python.org/zh-cn/3.10/extending/extending.html)
- [C++ 调用python方法 - MasonLee - 博客园](https://www.cnblogs.com/mxnote/articles/16742618.html)
- [《人生苦短，我用python·三》pybind11简单使用-CSDN博客](https://blog.csdn.net/cs1395293598/article/details/133999296)
	- 这个里面写了一个回调函数，竟然可以在python中直接继承并实现？感觉十分的神奇
- [pybind11 documentation](https://pybind11.readthedocs.io/en/stable/)
	- 这个是纯头文件绑定到方式的官方文档
	- 可以支持C++11的语法（目前在用的就是这个）
- [Convert Python Result C++. by ChatGPT](https://chatgpt.com/share/8a9527e5-2a71-46db-ab73-022c01827d96)
	- 我和ChatGPT的某次对话，还是很有参考价值的
- [reddit.com/r/QtFramework/comments/zbdzn6/managing\_qt\_event\_loop\_in\_a\_python\_console/](https://www.reddit.com/r/QtFramework/comments/zbdzn6/managing_qt_event_loop_in_a_python_console/)
	- 问题很好，但不是我想要的问题。作者想知道的是如何在py调用byd模块的时候，可以使用QT的事件循环、Timer，但我目前的问题是cpp主线程调用py，还希望不阻塞主线程（主要是希望py的回调能够发生在主线程中）
- [Is there a way to call an \`async\` python method from C++? - Stack Overflow](https://stackoverflow.com/questions/54553907/is-there-a-way-to-call-an-async-python-method-from-c)
	- 这里似乎提到了一个方式，但似乎并不是很好用
- [Pybind11异步调用回调](https://chatgpt.com/share/648a9a72-b9ea-4260-bec6-faa4b62bacd3)
	- 异步调用的一种说法，但并不保真。有的时候我真的怀疑ChatGPT在一本正经的胡说八道

使用cpp调用python的一些场景：
- cpp中其中给一个线程，里面调用python的算法模块，计算计算时间之后可以直接将结果返回给c++
- 和系统有关的，cpp执行一个小的py脚本，可以同步的在主线程运行一段脚本，这个脚本可以对系统的实体进行操控