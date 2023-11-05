---
layout: post
title: QT实现一个TcpServer
subtitle: 需支持使用QNetworkAccessManager进行网络请求
date: 2023-06-25 10:07:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,服务,Tcp,TcpServer,网络]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QT实现一个TcpServer并且可以使用QNetworkAccessManager进行网络请求

常规情况下使用QTcpSocket和QTcpServer开发一个socket服务或者是http服务，在网上搜索的时候有很多的答案，这里不再给出重复答案。[因为我的笔记中仅仅记录了问题]

现在遇到的问题是，自己使用QT开发出来的TcpServer可以通过自己模拟的客户端进行通信，而且网页上也是可以访问并取得结果的，唯独使用QNetworkAccessManager访问的时候会出错，还没有拿到结果，就断开了连接。

查找着实是费了一番功夫，需要在回复的时候给出正确的header才可以，如下：

```cpp
static QString replyTextFormat(
	"HTTP/1.1 %1 OK\r\n"
	"Content-Type: %2\r\n"
	"Content-Length: %3\r\n"
	"Access-Control-Allow-Origin: *\r\n"
	"Access-Control-Allow-Headers: Content-Type,X-Requested-With\r\n"
	"\r\n"
);
```

注：需要上述响应头才能在finished信号对应的slots中接收到数据，否则会提`QNetworkReply::RemoteHostClosedError`，server会提前断开连接。推测，与`Access-Control-Allow-Origin`有关。

备注：作为server读取文件向外发送的时候还是统一发送utf-8编码格式，不然在接收端收到数据之后解析会提示QJsonParseError::IllegalValue.