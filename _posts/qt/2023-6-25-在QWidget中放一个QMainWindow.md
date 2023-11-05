---
layout: post
title: 在QWidget中放一个QMainWindow
subtitle: QMainWindow也是一个窗体类
date: 2023-06-25 10:21:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QWidget]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# 在QWidget中放一个QMainWindow

QMainWidow本质是一个复杂的Widget，只要能获取到指针，就可以成功放置进去，如下：

```cpp
PlayUIContainer::PlayUIContainer(QWidget *parent)	
	: QWidget(parent),m_pPlayUIInterface(nullptr),m_pPlayUIWidget(nullptr)
{
	ui.setupUi(this);
	this->setWindowTitle(QString::fromLocal8Bit("用户界面"));

	m_pPlayUIWidget = GetPlayUIWidget();
	QVBoxLayout* pLayout = new QVBoxLayout;
	pLayout->setContentsMargins(0, 0, 0, 0);
	pLayout->addWidget(m_pPlayUIWidget);
	this->setLayout(pLayout);

	m_pPlayUIInterface = GetPlayUIInterface();
}
```

> 其中PlayUIContainer是继承与QWidget的

只要是UI界面，使用pointer的方式进行创建，可以很方便的在工程内做到嵌套，并且将类导出之后，也可以在其他同版本的QT工程中进行调用。

这应当是一个常识，遇到的时候搜索不到相关的答案，在开发过程中，我们应当意识到，**一切皆对象，只要是对象，那便可以动态创建，一些显示的内容都是widget，只要是widget那便可以进行嵌套**。