---
layout: post
title: QLocalServer不能检测到新的连接
subtitle: 
alias: 
date:  2024-06-20 16:04:34
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT]
typora-copy-images-to: ../../img/post
typora-root-url: ../../ 
---
[QLocalServer incomingConnection method never calls, but newConnection signal sent](https://www.qtcentre.org/threads/58429-QLocalServer-incomingConnection-method-never-calls-but-newConnection-signal-sent)

直接新写一个QT的控制台程序，里面使用QLocalServer的时候是可以的，但是在公司的框架下开发的时候，怎么也不能正常使用QLocalServer。

即使是按照文中的描述，等待新连接的到来之后再做其他的操作，也不行。但这个时候的情况又有一些变化，能听到一段时间，然后就再也听不到了。然后咧，这个server关掉之后，在client段竟然还能够检测到自己的连接出现了问题。
