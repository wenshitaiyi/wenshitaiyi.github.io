---
layout: post
title: (HTTP code 500) server error - Ports are not available
subtitle: 这大概是使用docker的新手问题
aliases: 
date: 2024-08-23 22:19:23
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - docker
  - 网络
  - alist
typora-copy-images-to: ../img/post
typora-root-url: ../
---

问题描述：

(HTTP code 500) server error - Ports are not available: exposing port TCP 0.0.0.0:5244 -> 0.0.0.0:0: listen tcp 0.0.0.0:5244: bind: An attempt was made to access a socket in a way forbidden by its access permissions.

解决方法如下：

```
net stop winnat
net start winnat
```