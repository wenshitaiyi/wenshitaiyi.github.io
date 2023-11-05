---
layout: post
title: 设置QTreeWidget设置节点展开有箭头
subtitle: 
date: 2023-05-21 06:00:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QTreeWidget]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# 设置QTreeWidget设置节点展开有箭头

## 相关函数

使用setChildIndicatorPolicy函数进行设置。官方文档中描述如下：

> Sets the item indicator *policy*. This policy decides when the tree branch expand/collapse indicator is shown. The default value is ShowForChildren.
>
> 设置项目指示器策略。 此策略决定何时显示树枝展开/折叠指示器。 默认值为 ShowForChildren。

```cpp
void QTreeWidgetItem::setChildIndicatorPolicy(QTreeWidgetItem::ChildIndicatorPolicy policy);
```

QTreeWidgetItem::ShowIndicator枚举值如下：

| 名称                                            | 值   | 描述                                                         |
| ----------------------------------------------- | ---- | ------------------------------------------------------------ |
| QTreeWidgetItem::ShowIndicator                  | 0    | 即使没有子项，也会为此项目显示用于展开和折叠的控件           |
| QTreeWidgetItem::DontShowIndicator              | 1    | 即使有孩子，展开和折叠的控件也永远不会显示。 如果节点被强制打开，用户将无法展开或折叠该项目 |
| QTreeWidgetItem::DontShowIndicatorWhenChildless | 2    | 如果项目包含子项，将显示用于展开和折叠的控件                 |

## 示例代码

在 `QTreeWidget` 中设置节点展开时显示箭头，首先使用 `QTreeWidgetItem` 的 `setExpanded()` 方法来设置节点的展开状态，并通过 `QTreeWidgetItem` 的 `setChildIndicatorPolicy()` 方法来设置节点的指示器策略。

以下是设置节点展开箭头的示例代码：

```cpp
#include <QApplication>
#include <QTreeWidget>
#include <QTreeWidgetItem>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    // 创建 QTreeWidget
    QTreeWidget treeWidget;

    // 设置节点指示器策略为显示箭头
    treeWidget.setRootIsDecorated(false); // 隐藏根节点的箭头
    treeWidget.setIndentation(20); // 设置缩进，使箭头对齐
    treeWidget.setHeaderHidden(true); // 隐藏头部

    // 创建根节点
    QTreeWidgetItem *rootItem = new QTreeWidgetItem(&treeWidget);
    rootItem->setText(0, "Root");

    // 创建子节点
    QTreeWidgetItem *childItem1 = new QTreeWidgetItem(rootItem);
    childItem1->setText(0, "Child 1");

    QTreeWidgetItem *childItem2 = new QTreeWidgetItem(rootItem);
    childItem2->setText(0, "Child 2");

    // 设置节点的展开状态
    rootItem->setExpanded(true);

    // 显示窗口
    treeWidget.show();

    return app.exec();
}
```

在上述示例中，我们创建了一个 QTreeWidget，并设置了节点指示器策略，使其显示箭头。然后创建了一个根节点和两个子节点，并设置根节点的展开状态为 true。最后，显示 QTreeWidget 窗口。

请注意，通过设置根节点的展开状态为 true，可以在程序运行时初始展开根节点，并显示箭头。根据需要，您可以根据具体的应用逻辑设置节点的展开状态。

通过这种方式，您可以在 QTreeWidget 中设置节点展开时显示箭头。

