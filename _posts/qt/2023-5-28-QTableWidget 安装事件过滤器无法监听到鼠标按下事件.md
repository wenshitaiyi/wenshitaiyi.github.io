---
layout: post
title: QTableWidget 安装事件过滤器无法监听到鼠标按下事件
subtitle: 使用事件过滤器，定制或监控用户行为
date: 2023-05-28 10:09:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,eventFilter,事件过滤]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QTableWidget 安装事件过滤器无法监听到鼠标按下事件

不能直接给该窗体`installEventFilter`,而是该窗体的`viewport`添加事件过滤

与此类似的还有：

- QTreeWidget
- QTreeView
- QTableView
- QListWidget
- QListView
- QGraphicsView

在添加事件过滤器的时候，需要给视窗添加，同时在eventFilter重载函数中也需要检测窗口指针。通常情况下继承于`QAbstractScrollArea`的对象，都需要给`viewport`添加事件过滤器才会生效。

有如下继承关系图

```
QAbstractScrollArea
	QAbstractItemView
		QColumnView
		QHeaderView
		QListView
			QListWidget
			QUndoView
		QTableView
			QTableWidget
		QTreeView
			QTreeWidget
	QGraphicsView
	QMdiArea
	QPlainTextEdit
	QScrollArea
	QTextEdit
		QTextBrowser
```

## 示例

用户鼠标左键点击的时候，可以知道当前激活的是哪一个窗口，代码示例如下：

```cpp
TestDlg::TestDlg(QWidget *parent)
	: QDialog(parent)
{
	ui.setupUi(this);

	m_pHelathTable = ui.tableWidget_health;//展示生命值的table
	m_pAttackTable = ui.tableWidget_attack;//展示攻击值的table

	m_pHelathTable->setMouseTracking(true);
	m_pAttackTable->setMouseTracking(true);
    
	m_pHelathTable->installEventFilter(this);
	m_pAttackTable->installEventFilter(this);
        
}


bool TestDlg::eventFilter(QObject * obj, QEvent * e)
{
	if(obj == m_pAttackTable->viewport()){
		if(e->type() == QEvent::MouseButtonPress){
			QMouseEvent* me = static_cast<QMouseEvent*>(e);
			if(me->button() == Qt::LeftButton)
				m_curTable = m_pAttackTable;
		}
	}
	else if(obj == m_pHelathTable->viewport()){
		if(e->type() == QEvent::MouseButtonPress){
			QMouseEvent* me = static_cast<QMouseEvent*>(e);
			if(me->button() == Qt::LeftButton)
				m_curTable = m_pHelathTable;
		}
	}
	return QDialog::eventFilter(obj,e);
}
```

树形控件的拖拽事件，不分监听代码如下：

```cpp
bool TestDlg::eventFilter(QObject * obj, QEvent * e)
{
	if(obj == m_ETTreeWidget->viewport()){
		QEvent::Type eType = e->type();
		if(eType == QEvent::MouseMove){
			printf("MouseMove.\n");
		}
		else if(eType == QEvent::DragMove){
			printf("DragMove.\n");
		}
		else if(eType == QEvent::DragEnter){
			printf("DragEnter.\n");
		}
		else if(eType == QEvent::Drop){
			printf("Drop.\n");
		}
	}
	return QDialog::eventFilter(obj,e);
}
```