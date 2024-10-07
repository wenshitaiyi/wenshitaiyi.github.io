---
layout: post
title: 2024-08-24-filezillaserver无法启动
subtitle: 
aliases: 
date: 2024-08-24 21:32:50
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - ftp
  - filezillaserver
typora-copy-images-to: ../img/post
typora-root-url: ../
---
问题如下：

```
<Date/Time> Info [Type] Message
<2024/8/24 21:32:29> Admin UI [Error] Failed connection to server 127.0.0.1:14148. Reason: ECONNREFUSED - Connection refused by server.
```

![[assets/Pasted image 20240824213424.png]]

还以为是配置过程出了问题，结果是filezillaserver这个服务真的没有开启，乌龙了。