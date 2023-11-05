---
layout: post
title: QTreeWidgetItem::removeChild函数
subtitle: QT中的take和remove
date: 2023-05-28 10:10:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QTreeWidgetItem]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QTreeWidgetItem::removeChild函数

```cpp
void QTreeWidgetItem::removeChild(QTreeWidgetItem* child);
```

Removes the given item indicated by *child*. The removed item will not be deleted.[移除指定的子孩子，但是这个子孩子并不会被删除]

```cpp
QTreeWidgetItem *QTreeWidgetItem::takeChild(int index);
```

Removes the item at *index* and returns it, otherwise return 0.[移除指定位置的子孩子，并返回该位置的子孩子指针，如果没有就返回空值]

```cpp
QList<QTreeWidgetItem *> QTreeWidgetItem::takeChildren();
```

Removes the list of children and returns it, otherwise returns an empty list.[移除所有的子孩子，并将这些子孩子的指针以List的形式返回出去]

> 通常，QT中有remove，take意思的函数，其具体的表现形式需要查阅一下官方文档的说明，如上几个函数，都不会自动删除子孩子，需要外部调用之后，主动的对这些子孩子的指针进行管理。