---
layout: post
title: QVariant数据结构的使用
subtitle: QT中的万能类型
date: 2023-05-28 10:13:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QVariant]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QVariant数据结构的使用

在 Qt 中，可以使用 QHeaderView 类的 setSectionResizeMode() 方法来设置表格的列宽或行高的拉伸方式。这个方法可以用于设置表格的自动拉伸、固定大小或根据内容调整等。

以下是一些常用的设置表格拉伸的方法：

1. 设置列宽拉伸方式：
```cpp
QTableView *tableView = new QTableView;

// 设置所有列宽自动调整
tableView->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);

// 设置指定列宽自动调整
tableView->horizontalHeader()->setSectionResizeMode(columnIndex, QHeaderView::Stretch);

// 设置指定列固定宽度
tableView->horizontalHeader()->setSectionResizeMode(columnIndex, QHeaderView::Fixed);
tableView->setColumnWidth(columnIndex, width);
```

对于设置列拉伸的情况，通常会使用`setStretchLastSection(false)`函数来禁止最后一列的自动拉伸。

2. 设置行高拉伸方式：

```cpp
QTableView *tableView = new QTableView;

// 设置所有行高自动调整
tableView->verticalHeader()->setSectionResizeMode(QHeaderView::Stretch);

// 设置指定行高自动调整
tableView->verticalHeader()->setSectionResizeMode(rowIndex, QHeaderView::Stretch);

// 设置指定行固定高度
tableView->verticalHeader()->setSectionResizeMode(rowIndex, QHeaderView::Fixed);
tableView->setRowHeight(rowIndex, height);
```

对于自动行号的写法，QT的表格控件经过测试是OK的，对于树形控件是否可行，尚且未知。

上述代码中，`tableView` 是一个 `QTableView` 对象，用于显示表格数据。通过获取水平或垂直的表头对象 `horizontalHeader()` 和 `verticalHeader()`，可以使用 `setSectionResizeMode()` 方法来设置拉伸方式。其中，`QHeaderView::Stretch` 表示自动拉伸，`QHeaderView::Fixed` 表示固定大小。

注意，表格的自动拉伸方式可能会根据表格内容的变化而自动调整列宽或行高。而固定大小方式则需要显式设置列宽或行高的值。

