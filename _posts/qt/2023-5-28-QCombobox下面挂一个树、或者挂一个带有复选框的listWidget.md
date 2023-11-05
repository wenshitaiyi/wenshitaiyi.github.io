---
layout: post
title: QCombobox定制
subtitle: QCombobox下面挂一个树、或者挂一个带有复选框的listWidget
date: 2023-05-28 10:05:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QComboBox]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QCombobox下面挂一个树、或者挂一个带有复选框的listWidget

## 难点

- 挂载一棵树，有以下一个难点
  - 鼠标点击的时候，如何知道点击的是展开，还是指定的item
  -  鼠标展开树节点的时候，怎么样动态扩展下拉菜单的高度
- 挂载checkbox list的难点
  - 如何知道点击的是复选框？

注：需要适用eventfileter，官方解释如下：

An event filter is an object that receives all events that are sent to this object. The filter can either stop the event or forward it to this object. The event filter filterObj receives events via its eventFilter() function. The eventFilter() function must return true if the event should be filtered, (i.e. stopped); otherwise it must return false.

If multiple event filters are installed on a single object, the filter that was installed last is activated first.

最后安装的会最先激活，返回false才会继续向下执行。

## 树的情况

头文件：MyComboBox.h

```cpp
#pragma once

#include <QComboBox>
#include <QWidget>

class QTreeView;
class QStandardItemModel;
class QModelIndex;

enum Cbx_View_Type
{
	CVT_List,
	CVT_Tree,
	CVT_Table
};

class MyComboBox : public QComboBox
{
	Q_OBJECT

public:
	MyComboBox(QWidget *parent = 0);
	~MyComboBox();
	void setView(QAbstractItemView* itemView,const Cbx_View_Type vt = CVT_List);
private:
	bool eventFilter(QObject* o, QEvent* e);
	//统计可见节点的数目
	int GetVisibleItemCount(QTreeView* pTreeView, QStandardItemModel* pTreeModel, QModelIndex& rootIndex, int* deltaHeight = nullptr);
private:
	bool m_bHitRealItem;
	Cbx_View_Type m_viewType;
};
```

源文件：MyComboBox.cpp

```cpp
#include "MyComboBox.h"
#include <QAbstractItemView>
#include <QEvent>
#include <QMouseEvent>
#include <QStandardItemModel>
#include <QAbstractItemModel>
#include <QRect>
#include <QTreeView>
#include <QStack>

MyComboBox::MyComboBox(QWidget* parent)
	: QComboBox(parent), m_bHitRealItem(false), m_viewType(CVT_List){}
MyComboBox::~MyComboBox(){}

void MyComboBox::setView(QAbstractItemView* itemView, const Cbx_View_Type vt)
{
	if (!itemView) return;
	m_viewType = vt;
	QComboBox::setView(itemView);
	itemView->viewport()->installEventFilter(this);
}

bool MyComboBox::eventFilter(QObject* o, QEvent* e)
{
	if (e->type() == QEvent::MouseButtonPress && o == this->view()->viewport())
	{
		QMouseEvent* me = static_cast<QMouseEvent*>(e);
		QAbstractItemModel* pModel = this->model();
		QAbstractItemView* pView = this->view();
		QPoint p = me->pos();
		QModelIndex idx = pView->indexAt(p);
		QRect rect = pView->visualRect(idx);
		m_bHitRealItem = p.x() > rect.x();

		printf("(%d,%d) (%d,%d,%d,%d)\n", p.x(), p.y(), rect.width(), rect.height(), rect.x(), rect.y());

		if (!m_bHitRealItem)
		{
			switch (m_viewType)
			{
			case CVT_List:
			{
				//use default
				break;
			}
			case CVT_Tree:
			{
				QTreeView* pTreeView = static_cast<QTreeView*>(pView);
				QStandardItemModel* pTreeModel = static_cast<QStandardItemModel*>(pModel);

				QStandardItem* pItem = pTreeModel->itemFromIndex(idx);
				if (!pItem) break;

				if (pItem->isCheckable())
				{
					//maybe no use
				}
				else
				{
					if (pItem->hasChildren())
					{
						int deltaHeight = 0;
						if (pTreeView->isExpanded(idx))
						{
							GetVisibleItemCount(pTreeView, pTreeModel, idx, &deltaHeight);
							deltaHeight = -deltaHeight;
							pTreeView->collapse(idx);
						}
						else
						{
							pTreeView->expand(idx);
							GetVisibleItemCount(pTreeView, pTreeModel, idx, &deltaHeight);
						}
						QWidget* pContainer = (QWidget*)(pTreeView->parent());
						printf("view=0x%p, viewPort=0x%p\nviewParent=0x%p, viewPortParet=0x%p\n"
							, pTreeView
							, pTreeView->viewport()
							, pTreeView->parent()
							, pTreeView->viewport()->parent());
						printf("(%d,%d),(%d,%d)\ndeltaheight=%d\n"
							, pTreeView->width(), pTreeView->height()
							, pContainer->width(), pContainer->height()
							, deltaHeight);
						pContainer->resize(pContainer->width(), pContainer->height() + deltaHeight);
					}
					else
					{
						m_bHitRealItem = true;
					}

				}
				break;
			}
			case CVT_Table:
			{
				break;
			}
			default:
				break;
			}
		}
		return !m_bHitRealItem;
	}
	else if (e->type() == QEvent::MouseButtonRelease && o == this->view()->viewport())
	{
		return !m_bHitRealItem;
	}
	return QComboBox::eventFilter(o, e);
}

int MyComboBox::GetVisibleItemCount(QTreeView* pTreeView, QStandardItemModel* pTreeModel, QModelIndex& rootIndex, int* deltaHeightPtr)
{
	if (!pTreeView || !pTreeModel) return 0;
	int deltaHeight = 0;
	QStack<QModelIndex> toCheck;
	int count = 0;
	toCheck.push(rootIndex);
	while (!toCheck.isEmpty())
	{
		QModelIndex parent = toCheck.pop();
		for (int i = 0; i < pTreeModel->rowCount(parent); ++i)
		{
			QModelIndex idx = pTreeModel->index(i, 0, parent);
			if (!idx.isValid())
				continue;
			deltaHeight += pTreeView->visualRect(idx).height();
			if (pTreeModel->hasChildren(idx) && pTreeView && pTreeView->isExpanded(idx))
				toCheck.push(idx);
			++count;
		}
	}

	if (deltaHeightPtr != nullptr) *deltaHeightPtr = deltaHeight;
	printf("Count = %d\n", count);
	return count;
}
```

获取可见节点个数的函数，摘抄于Qcombobox的源码；eventFilter中的tree部分的函数，是检测的重点。

## 列表的情况

头文件：

````cpp
#ifndef MYCOMBOBOX_H
#define MYCOMBOBOX_H
#include "stdafx.h"
#include <QComboBox>

#include <QWidget>
#include <QListWidget>
#include <QListWidgetItem>
#include <QLineEdit>
#include <QCheckBox>
class MyComboBox : public QComboBox
{
	Q_OBJECT

public:
	MyComboBox(QWidget *parent = 0);
	~MyComboBox();
	void initComboBox();
	void appendItem(QString text);
	QList<QListWidgetItem*> getItems();
	QList<QListWidgetItem*> getSelectedItems();
	void clearItem();
public slots:
	void stateChangeSlot(int state);
private:
	QListWidget* m_listWidget;
	QLineEdit* m_lineEdit;
	QString m_selectedText;
	QList<QListWidgetItem*> m_cusItmes;
};
````



源文件：

````cpp
#include "stdafx.h"
#include "MyComboBox.h"

MyComboBox::MyComboBox(QWidget *parent)
	: QComboBox(parent)
{
	initComboBox();
}

MyComboBox::~MyComboBox()
{

}

void MyComboBox::initComboBox()
{
	m_listWidget = new QListWidget(this);
	m_lineEdit = new QLineEdit(this);
	this->setModel(m_listWidget->model());
	this->setView(m_listWidget);
	this->setLineEdit(m_lineEdit);
	m_lineEdit->setReadOnly(true);
}

void MyComboBox::appendItem(QString text)
{
	QListWidgetItem* listItem = new QListWidgetItem(m_listWidget);
	m_cusItmes.append(listItem);
	m_listWidget->addItem(listItem);
	QCheckBox* checkbox = new QCheckBox(this);
	checkbox->setText(text);
	checkbox->setChecked(true);
	m_lineEdit->setText(m_lineEdit->text().append(text).append(";"));
	m_listWidget->setItemWidget(listItem,checkbox);
	connect(checkbox,SIGNAL(stateChanged(int)),this, SLOT(stateChangeSlot(int)));
}

QList<QListWidgetItem*> MyComboBox::getItems()
{
	return m_cusItmes;
}

QList<QListWidgetItem*> MyComboBox::getSelectedItems()
{
	QList<QListWidgetItem*> ritems;
	foreach (auto item,m_cusItmes)
	{
		QCheckBox* check = (QCheckBox*)(m_listWidget->itemWidget(item));
		if (check&&check->isChecked())
		{
			ritems.append(item);
		}
	}
	return ritems;
}

void MyComboBox::clearItem()
{
	this->m_cusItmes.clear();
	m_listWidget->clear();
}

void MyComboBox::stateChangeSlot(int state)
{
	Q_UNUSED(state);
	QString str("");
	m_selectedText.clear();
	int nCount = m_listWidget->count();
	for (int i = 0;i<nCount;i++)
	{
		QListWidgetItem* pItem = m_listWidget->item(i);
		QWidget* pWidget = m_listWidget->itemWidget(pItem);
		if (!pWidget)
		{
			continue;
		}
		QCheckBox* pCheckBox = (QCheckBox*)pWidget;
		if (pCheckBox->isChecked())
		{
			QString strText = pCheckBox->text();
			str.append(strText).append(";");
		}
		if (str.endsWith(";"))
		{
			str.remove(str.count()-1,1);
		}
		if (!str.isEmpty())
		{
			m_selectedText = str;
			m_lineEdit->setText(str);
			m_lineEdit->setToolTip(str);
		}
		else
		{
			m_lineEdit->clear();
		}
	}
}
````

支持返回多选的内容，仅此而已；对于是否点击到了checkbox，可以通过eventFilter在其他的位置进行检测，具体代码如下：

```cpp
bool BDTreeShowFilterDlg::eventFilter(QObject* obj, QEvent* e)
{
	if (e->type() == QEvent::MouseButtonPress /*|| e->type() == QEvent::MouseButtonRelease*/)
	{
		if (obj == ui.comboBoxFilter->view()->viewport())
		{
			QMouseEvent* me = static_cast<QMouseEvent*>(e);

			int i = m_pListWidget->currentRow();
			QListWidgetItem* item = m_pListWidget->item(i);

			QPoint p = me->pos();
			//QListWidgetItem* item2 = m_pListWidget->itemAt(p);


			//如何判断是不是在checkbox里面
			if (p.x() < 20)
			{
				m_bInCheckbox = true;
				item->setCheckState((item->checkState() == Qt::Checked) ? Qt::Unchecked : Qt::Checked);
			}
			else
			{
				m_bInCheckbox = false;
			}

			printf("You click, row = %d, %p, (%d,%d)\n", i, item, p.x(), p.y());
			return m_bInCheckbox;
			return true;
		}
	}
	else if (e->type() == QEvent::MouseButtonRelease)
	{
		if (obj == ui.comboBoxFilter->view()->viewport())
		{
			return m_bInCheckbox;
		}
	}
	return QDialog::eventFilter(obj, e);
}
```

注意：这种情况下需要监测的是viewport，如下：

```cpp
m_pListWidget = new QListWidget(this);
m_pListWidget->setMouseTracking(true);
ui.comboBoxFilter->setView(m_pListWidget);
ui.comboBoxFilter->setModel(m_pListWidget->model());
ui.comboBoxFilter->view()->viewport()->installEventFilter(this);
```

每一个combobox在设置了view之后可以检测它的视窗。