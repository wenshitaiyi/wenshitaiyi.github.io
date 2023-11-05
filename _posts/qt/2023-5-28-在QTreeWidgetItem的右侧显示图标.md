---
layout: post
title: 在QTreeWidgetItem的右侧显示图标
subtitle: QT自定义绘制
date: 2023-05-28 10:20:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QTreeWidget,图标]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# 在QTreeWidgetItem的右侧显示图标

## 头文件

```cpp
#pragma once

#include <QItemDelegate>
#include <QObject>

class ScenarioDelegateItem : public QItemDelegate
{
	Q_OBJECT

public:
	ScenarioDelegateItem(QObject* parent) :QItemDelegate(parent) {}
	~ScenarioDelegateItem() {}
	QWidget* createEditor(QWidget* parent, const QStyleOptionViewItem& option, const QModelIndex& index) const;
	void paint(QPainter* painter, const QStyleOptionViewItem& option, const QModelIndex& index) const;
	void setEditorData(QWidget* editor, const QModelIndex& index) const;
	void setModelData(QWidget* editor, QAbstractItemModel* model, const QModelIndex& index) const;
	QSize sizeHint(const QStyleOptionViewItem& option, const QModelIndex& index) const;
	void updateEditorGeometry(QWidget* editor, const QStyleOptionViewItem& option, const QModelIndex& index) const;
};
```

## 源文件

```cpp
#include "stdafx.h"
#include "ScenarioDelegateItem.h"
#include "ScenarioDlg.h"

QWidget* ScenarioDelegateItem::createEditor(QWidget* parent, const QStyleOptionViewItem& option, const QModelIndex& index) const
{
	return nullptr;
}

void ScenarioDelegateItem::paint(QPainter* painter, const QStyleOptionViewItem& option, const QModelIndex& index) const
{
	//只处理第0列, 在右侧绘制一个矩形
	if (index.column() == 0 && ScenarioDlg::ShowMediaIcon(index))
	{
		painter->save();

		QRectF itemRect(option.rect.x(), option.rect.y(), option.rect.width(), option.rect.height());
		qreal sideLength = itemRect.height() * 0.9;
		QRectF mediaIconRect(itemRect.width() - itemRect.height(), (itemRect.height() - sideLength) * 0.5 + itemRect.y(), sideLength, sideLength);
		painter->setViewport(mediaIconRect.toRect());
		painter->setWindow(-50, -50, 100, 100);

		/*printf("itemRect(%d,%d,%d,%d);  mediaIconRect(%f,%f,%f,%f);  sideLen=%f,\n"
			, option.rect.x(), option.rect.y(), option.rect.width(), option.rect.height()
			, mediaIconRect.x(), mediaIconRect.y(), mediaIconRect.width(), mediaIconRect.height()
			, sideLength);*/

		QPixmap pm(":/img/Resources/video.png");
		painter->drawPixmap(-50, -50, 100, 100, pm, 0, 0, pm.width(), pm.height());
		painter->restore();

		drawDisplay(painter, option, option.rect, index.model()->data(index, Qt::DisplayRole).toString());
	}
	else
	{
		QItemDelegate::paint(painter, option, index);
	}

	/*drawBackground(painter, option, index);
	QItemDelegate::paint(painter, option, index);*/
}

void ScenarioDelegateItem::setEditorData(QWidget* editor, const QModelIndex& index) const
{
	return;
}

void ScenarioDelegateItem::setModelData(QWidget* editor, QAbstractItemModel* model, const QModelIndex& index) const
{
	return;
}

QSize ScenarioDelegateItem::sizeHint(const QStyleOptionViewItem& option, const QModelIndex& index) const
{
	return QItemDelegate::sizeHint(option, index);
}

void ScenarioDelegateItem::updateEditorGeometry(QWidget* editor, const QStyleOptionViewItem& option, const QModelIndex& index) const
{
	editor->setGeometry(option.rect);
}
```

注：通过实现QdelegateItem来达到效果，在右侧指定位置绘制图标，然后通过drawText来重新绘制文字，如果没有这个函数，将会只显示图标，不显示问题，目前还没有找到原因。

绘制图标的时候，需要知道自己的绘制矩形是什么，然后从右侧裁出来一个方形用来绘制图标，在同一个函数中也可以继续操作，比如，记录裁剪后的矩形，如果还有状态图标需要绘制，则再次裁剪。

上述代码的展示效果中有中情况需要注意，如果显示图标的这一列是可以拉伸的，该列特别窄的时候，文字部分会变成...，但是图片却不会自动变化，乍一看就像是图片悬浮到了文字上面。

如果有些重载函数没有使用到，在派生类中可以直接不写，比如上述代码中的`setModelData`、`setEditorData`

> 补：上述绘制文字的情况不是特别专业

