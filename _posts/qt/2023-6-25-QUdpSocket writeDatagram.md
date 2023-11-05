---
layout: post
title: QUdpSocket::writeDatagram
subtitle: QT的udp模块使用记录
date: 2023-06-25 10:13:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,UDP]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QUdpSocket::writeDatagram

Sends the datagram at *data* of size *size* to the host address *address* at port *port*. Returns the number of bytes sent on success; otherwise returns -1.

Datagrams are always written as one block. The maximum size of a datagram is highly platform-dependent, but can be as low as 8192 bytes. If the datagram is too large, this function will return -1 and error will return DatagramTooLargeError.

Sending datagrams larger than 512 bytes is in general disadvised, as even if they are sent successfully, they are likely to be fragmented by the IP layer before arriving at their final destination.

**Warning:** Calling this function on a connected UDP socket may result in an error and no packet being sent. If you are using a connected socket, use write to send datagrams.

> 翻译：
>
> 将数据大小为 size 的数据报发送到端口 port 处的主机地址。 成功时返回发送的字节数； 否则返回-1。
>
> 数据报总是作为一个块写入。 数据报的最大大小高度依赖于平台，但可以低至 8192 字节。 如果数据报太大，该函数将返回-1，并且error()将返回DatagramTooLargeError。
>
> 通常不建议发送大于 512 字节的数据报，因为即使发送成功，它们也可能在到达最终目的地之前被 IP 层分段。
>
> 警告：在已连接的 UDP 套接字上调用此函数可能会导致错误并且不会发送数据包。 如果您使用连接的套接字，请使用 write() 发送数据报。

注：使用QUDPSocket的时候，如果发现readyRead()信号不会触发，可能是发送的数据块太大了。