---
layout: post
title: paintEvent将绘制坐标系，转换为中心为圆点的常规坐标系
subtitle: 折腾了一遭，毫无意义
date: 2023-06-25 10:04:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,paintEvent]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# paintEvent将绘制坐标系，转换为中心为圆点的常规坐标系

绘制翻转过程

```cpp
#include <QRectF>
void PhysicalBasicWidget::ResetTransform()
{
	QRectF rect = this->rect();//100,30
	m_sceneTF.reset();
	m_sceneTF.translate(rect.width() / 2, rect.height() / 2);
	m_sceneTF.rotate(180);
	m_sceneTF.rotate(-180,Qt::YAxis);
	m_sceneTFInvert = m_sceneTF.inverted();//获取逆矩阵
}
```

坐标系虽然对上了，当时文字、图像等的绘制规则依旧是从小值到大值的过程，看上去还是反着的；这个窗口不像是三维里面的窗口，中心即原点。

如果使用了上述过程，则绘制图像或文字的代码如下：

```cpp
void TestFun(QPainter& painter)
{
	painter.save();
	painter.setPen(QPen(Qt::black, 2));
	const QTransform& ivTF = m_pScene->GetInvertedTF();//逆矩阵暂时不用
	const QTransform& TF = m_pScene->GetTF();//转换矩阵必不可少
	painter.setTransform(ivTF, true); //可以直接写Qtransform()，设置成空，减少一步运算

	QRectF pr = TF.mapRect(m_bg.rect());
	painter.drawPixmap(pr.toRect(), m_bg);

	double rx = m_pScene->rect().width() / 2;
	double ry = m_pScene->rect().height() / 2;

	QList<QPointF> dirTextPntList;
	dirTextPntList
		<< TF.map(zeroPnt + QPointF(0, ry - 30))
		<< TF.map(zeroPnt + QPointF(0, -ry + 30))
		<< TF.map(zeroPnt + QPointF(-rx + 30, 0))
		<< TF.map(zeroPnt + QPointF(rx - 30, 0));
	QList<QString> dirTextList;
	dirTextList
		<< QString::fromLocal8Bit("北")
		<< QString::fromLocal8Bit("南")
		<< QString::fromLocal8Bit("西")
		<< QString::fromLocal8Bit("东");

	QFont font(QString::fromLocal8Bit("隶书"));
	font.setPixelSize(30);
	
	painter.setFont(font);
	for (int i = 0; i < 4; i++)
	{
		const QPointF& cp = dirTextPntList.at(i);
		QFontMetricsF fm(font);
		QRectF fRect = fm.boundingRect(dirTextList[i]);
		painter.drawText(
			QRectF(
				cp.x() - fRect.width() / 2,
				cp.y() - fRect.height() / 2,
				fRect.width(), fRect.height()
			),
			dirTextList[i]
		);
	}
	painter.restore();
}
```

注（2023年6月25日）：感觉这种思路天生有问题，窗口坐标系本来就是从左上到右下的，非要调整成常规的左下到右上的绘制模式，就好像在和整合绘制过程反着来，天然会碰壁。所以，这里仅作为记录，后续也不会使用这种方法。