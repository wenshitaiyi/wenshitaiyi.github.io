---
layout: post
title: QPainter创建路径
subtitle: QT绘图事件的使用
date: 2023-05-28 10:07:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QPainter]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QPainter创建路径

路径的交叉并补可以通过函数或者操作符进行操作，如下：

```cpp
//函数
QPainterPath subtracted(const QPainterPath &p) const;	//差集
QPainterPath united(const QPainterPath &p) const;		//并集
QPainterPath intersected(const QPainterPath &p) const;//交集
//操作符
QPainterPath operator&(const QPainterPath &other) const;
QPainterPath &operator&=(const QPainterPath &other);
QPainterPath operator+(const QPainterPath &other) const;
QPainterPath &operator+=(const QPainterPath &other);
QPainterPath operator-(const QPainterPath &other) const;
QPainterPath &operator-=(const QPainterPath &other);
```

示例代码：

```cpp
void QwIFNTProgressBar::Pate_Test3(QPainter& painter)
{
	painter.save();
	painter.setWindow(0, 0, 400, 400);
	painter.translate(200,0);
	painter.scale(0.8, 0.8);

	painter.setRenderHint(QPainter::Antialiasing);
	QPainterPath path;
	path.lineTo(100, 0);
	path.cubicTo(200, 0, 100, 50, 200, 100);
	path.closeSubpath();
	path.addRect(50, 50, 50, 50);

	QPainterPath path2;
	path2.addEllipse(80, 30, 50, 50);
	path = path.subtracted(path2);

	QPoint offsetPoint(20, 20);
	painter.translate(offsetPoint);
	painter.setBrush(Qt::lightGray);
	painter.drawPath(path);
	painter.setBrush(Qt::NoBrush);
	painter.drawRect(path.boundingRect());

	QPen pen;
	pen.setWidth(5);
	pen.setColor(Qt::red);
	painter.setPen(pen);
	painter.drawPoint(QPoint(100, 0) );
	painter.drawPoint(QPoint(200, 0) );
	painter.drawPoint(QPoint(100, 50) );
	painter.drawPoint(QPoint(200, 100) );

	painter.restore();
}
```

