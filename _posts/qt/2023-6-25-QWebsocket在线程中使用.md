---
layout: post
title: QWebsocket在线程中使用
subtitle: QT的ws网络传输协议如何运行在子线程中
date: 2023-06-25 10:14:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,WS,线程]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QWebsocket在线程中使用

如果是在主线程进行创建，movetothread这个过程是不可行的，会提示websocket的parent在主线程，无法在子线程中使用。

可以直接在子线程中创建websocket并使用，由于笔记中找不到，只有UDP的相关代码，这里就只写UDP的，emm

```cpp
class UDPReceiver :public QThread
{
	Q_OBJECT

public:
	UDPReceiver(QObject *parent);
	~UDPReceiver();
	void run();
public slots:
    //调用函数解析数据，然后直接在线程中将数据发到中央处理模块，对tracker进行数据添加
	void S_RecvAISData();
private: 
    //配置udp的地址和端口号[指定某ip]
	void InitConnect(const QHostAddress& a, const QString& port);
    //直接监听ipv4内的所有端口
	void InitConnect(const QString& port);
private:
	QUdpSocket* m_pUDPAISRecvier;
	QString m_ip;
	QString m_port;
};


void UDPReceiver::InitConnect(const QString& port)
{
	m_pUDPAISRecvier = new QUdpSocket;
	bool ret = m_pUDPAISRecvier->bind(QHostAddress::AnyIPv4, port.toUInt(), QUdpSocket::ShareAddress);
	m_pUDPAISRecvier->setSocketOption(QAbstractSocket::ReceiveBufferSizeSocketOption, 1024 * 1024 * 8);
	m_pUDPAISRecvier->setSocketOption(QAbstractSocket::MulticastLoopbackOption, 1);
	//Qt::DirectConnection: The slot is invoked immediately, when the signal is emitted.
	connect(m_pUDPAISRecvier, &QUdpSocket::readyRead, this, &UDPReceiver::S_RecvAISData,Qt::ConnectionType::DirectConnection);
}

void UDPReceiver::run()
{
	InitConnect(m_port);
	exec();
}
```

直接在线程中创建udpsocket，这种情况可以保证每一次的接收都是在子线程。

如果数据处理的过程都是在子线程中的，自然是没有问题，但解析完毕的数据如果要在主线程中进行展示，就需要使用mutex对数据加以保护，并通过轮询或者通知的方式告知主线程数据可以获取了。

## 在run函数中实例化socket，在主线程中调用socket的写机制

```cpp
QSocketNotifier: Socket notifiers cannot be enabled or disabled from another thread.
```

系统提示无法在另一个线程完成操作。

## 直接使用connect连接主线程的信号，子线程的槽函数

```cpp
connect(this, &QEmailServer::Si_BroadCastData, m_pServerThread->GetInternalServer(), &RealServer::S_BSendData);
```

`QObject::connect: Cannot queue arguments of type 'QJsonObject&'(Make sure 'QJsonObject&' is registered using qRegisterMetaType().)`

备注：直接无法发送信号

- 如果是主线程对象的信号，主线程对象的槽函数则没有问题，如下
  - `connect(this, &QEmailServer::Si_BroadCastData, m_pServerThread, &ServerThread::S_BroadCastData);`
- 如果使用的是QbyteArray& 也会有同样的错误

## 如果使用的是Qbytearray，不是引用，则可以正常跳转到线程，实现主线程与子线程的通信

```cpp
void S_BSendData2(QByteArray data);
void Si_BroadCastData2(QByteArray data);
connect(this, &QEmailServer::Si_BroadCastData2, m_pServerThread->GetInternalServer(), &RealServer::S_BSendData2);

void RealServer::S_BSendData2(QByteArray data)
{
	QString str = data.constData();
	for each (auto i in m_clients)
	{
		i->sendTextMessage(data);
	}
}
```

备注：可以在客户端的主线程中收到，客户端在哪个线程收到是由客户端代码决定的，应该：并非一定是主线程。

至此，在server端完可成主线程控制子线程，通过子线程对客户端进行文件发送。

## Server的正常关闭

> 备注：上述思路完成前期工作后，关闭时，有问题

```cpp
Debug error:
Assert failure in qcoreapplication::sendevent:"cannot send events to objects owned by a different thread. Current thrad 2aca078. Receiver "(of type 'Qnativesocketengine') was created in thread 2f4ea00"
```

备注：

- 无论是主动的delete还是设置object parent为server thread，还是直接就设置为null
- 都会有上面的错误，不能跨线程关闭socketserver

但是，如下代码：

```cpp
m_pServer = new QWebSocketServer("EmailServer", QWebSocketServer::NonSecureMode, nullptr);
```

实际的socketserver 的parent设置为空，且不处理的时候，可以正常关闭，但总觉得资源没有正常释放。如果启用了线程级别的事件循环，则可以有如下操作：

```cpp
void run()
{
	//前期准备，声明各种变量
    
    exec();//开启事件循环
    
    //事件循环结束，释放各种变量
}
```

在run函数中的所有内容，都是在线程中执行的，线程中创建出来的量，自然是可以在线程中处理的，这种情况需要使用`quit()`函数用来结束线程，并使用`wait()`函数等待线程执行完毕。