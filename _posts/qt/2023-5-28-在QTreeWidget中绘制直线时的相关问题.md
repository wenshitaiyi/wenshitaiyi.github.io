---
layout: post
title: 在QTreeWidget中绘制直线时的相关问题
subtitle: 绘图事件重写
date: 2023-05-28 10:21:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QTreeWidget,paintEvent]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# 在QTreeWidget中绘制直线时的相关问题

## 问题1 QWidget::paintEngine: Should no longer be called

错误如下：

```
QWidget::paintEngine: Should no longer be called
QPainter::begin: Paint device returned engine == 0, type: 1
QPainter::save: Painter not active
QPainter::setPen: Painter not active
QPainter::setPen: Painter not active
QPainter::restore: Unbalanced save/restore
```

代码如下：

```cpp
void QRTreeWidget::paintLine()
{

	QPainter painter(this);
	painter.save();

	QPen pen(palette().base().color());
	painter.setPen(pen);
	painter.drawLine(m_oldLine);

	//QPen pen(Qt::green);
	pen.setColor(Qt::green);
	pen.setWidth(1);
	painter.setPen(pen);
	painter.drawLine(m_newLine);

	painter.restore();
}
//错误调用位置：
void QRTreeWidget::dragMoveEvent(QDragMoveEvent* e)
{
	//... ...
	paintLine();
	return QTreeWidget::dragMoveEvent(e);
}
//正确的调用位置
void QRTreeWidget::paintEvent(QPaintEvent* e)
{
	paintLine();
	return QTreeWidget::paintEvent(e);
}
```

> **Note**: the only place you should create and use a painter is inside paintEvent().[只能在paintEvent中使用或者创建painter]

## 问题2 WA_PaintOutsidePaintEvent

错误代码如下：

```
1>QRTreeWidget.cpp(9): error C2039: “WA_PaintOutsidePaintEvent”: 不是“Qt”的成员
```

注：关于WA_PaintOutsidePaintEvent的定义，只能在QT4的文档中找到，在QT5的文档中已经消失。

> 官方给出的解释如下：
>
> Makes it possible to use QPainter to paint on the widget outside paintEvent(). This flag is not supported on Windows, Mac OS X or Embedded Linux. We recommend that you use it only when porting Qt 3 code to Qt 4.
>
> 不适合现有的系统，只适用于X11，其他系统均无效，在其他的系统中，会与到问题1类似情况！

## 问题3 QPainter painter(this) 绘制无效

```cpp
//需要适用一下初始化的方式 [还是viewport的问题]
QPainter painter(this->viewport());	
//备注：只有在设置绘制主体为视窗，才能正确显示绘制内容！
//查看QT源码，可见：
#include "qabstractscrollarea.h" 中

QWidget *viewport() const;
QWidget *QAbstractScrollArea::viewport() const
{
    Q_D(const QAbstractScrollArea);
    return d->viewport;
}
```

