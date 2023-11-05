---
layout: post
title: QTreeWidget 文字自动调整行高
subtitle: 树控件中的自动换行效果
date: 2023-05-22 07:00:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QTreeWidget]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QTreeWidget 文字自动调整行高

一行代码可以搞定：

```cpp
int labelHeight = (label->fontMetrics().width(str) / 
    ui.treeWidget->columnWidth(1)) == 0 
    ? label->fontMetrics().height() 
    : (label->fontMetrics().width(str) / ui.treeWidget->columnWidth(1) + 1) *	//行数 = 显示总长 / 控件列宽
    (label->fontMetrics().height() + label->fontMetrics().lineSpacing());		//每行的高度 = 行高 + 行距
```

其中`label`是承载字符串的label，`ui.treeWidget`是树形空间，上述代码希望在数据很长的时候能够达到一个换行的效果。

## 其他方法-代理

要实现 `QTreeWidget` 内的文字自动换行和自动调整行高，可设置适当的委托（Delegate）来处理。以下是一个示例代码，演示了如何实现文字自动换行和自动调整行高的 `QTreeWidget`：

```cpp
#include <QApplication>
#include <QTreeWidget>
#include <QTreeWidgetItem>
#include <QStyledItemDelegate>
#include <QPainter>

class TreeWidgetItemDelegate : public QStyledItemDelegate
{
public:
    explicit TreeWidgetItemDelegate(QObject* parent = nullptr) : QStyledItemDelegate(parent) {}

    void paint(QPainter* painter, const QStyleOptionViewItem& option, const QModelIndex& index) const override
    {
        QStyleOptionViewItem opt = option;
        initStyleOption(&opt, index);

        QStyledItemDelegate::paint(painter, opt, index);

        painter->save();

        if (index.column() == 0)
        {
            QRect rect = opt.rect.adjusted(2, 2, -2, -2);
            painter->drawText(rect, Qt::TextWordWrap, opt.text);
        }

        painter->restore();
    }

    QSize sizeHint(const QStyleOptionViewItem& option, const QModelIndex& index) const override
    {
        QSize size = QStyledItemDelegate::sizeHint(option, index);

        if (index.column() == 0)
        {
            QString text = index.data().toString();
            QFontMetrics fontMetrics(option.font);
            QRect rect = fontMetrics.boundingRect(option.rect, Qt::TextWordWrap, text);
            size.setHeight(rect.height());
        }

        return size;
    }
};

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QTreeWidget treeWidget;
    treeWidget.setHeaderLabels({"Items"});
    treeWidget.setIndentation(20);

    TreeWidgetItemDelegate* delegate = new TreeWidgetItemDelegate(&treeWidget);
    treeWidget.setItemDelegate(delegate);

    QTreeWidgetItem* item1 = new QTreeWidgetItem(&treeWidget, {"Long Text Example 1"});
    QTreeWidgetItem* item2 = new QTreeWidgetItem(&treeWidget, {"Long Text Example 2"});

    treeWidget.show();

    return app.exec();
}
```

在上述代码中，我们定义了一个 `TreeWidgetItemDelegate` 类作为委托，继承自 `QStyledItemDelegate`。在 `paint` 函数中，我们使用 `drawText` 方法绘制文字，并设置了 `Qt::TextWordWrap` 标志以实现自动换行。在 `sizeHint` 函数中，我们根据文字内容和字体计算了适当的行高。

通过设置委托对象为 `QTreeWidget` 的委托，你可以实现 `QTreeWidget` 内的文字自动换行和自动调整行高。当文字内容过长时，文字会自动换行并调整行高以适应内容。

请注意，在此示例中，我们只针对第一列的文字进行了自动换行和自动调整行高的处理。如果你希望其他列的文字也能自动换行和调整行高，可以相应地修改委托的 `paint` 和 `sizeHint` 函数来处理多列内容。

在委托类的 `sizeHint` 函数中，我们通过使用 `QFontMetrics` 类的 `boundingRect` 函数来计算换行后文本的高度。

具体来说，在 `sizeHint` 函数中，我们获取了要绘制的文本内容（通过 `index.data().toString()`）和委托使用的字体（通过 `option.font`）。然后，我们使用 `QFontMetrics` 的 `boundingRect` 函数来获取以指定字体绘制文本时的边界矩形。

`boundingRect` 函数接受多个参数，其中包括了用于绘制文本的矩形边界、绘制文本时使用的文本格式（例如 `Qt::TextWordWrap`），以及要绘制的文本内容。通过调用 `boundingRect` 函数，我们可以获得文本在给定矩形边界内绘制时的大小，包括了换行后的高度。

因此，通过 `QFontMetrics` 类的 `boundingRect` 函数，我们能够计算出文字在换行后的高度，以便在 `sizeHint` 函数中返回正确的行高。这样，`QTreeWidget` 中的每一行都可以根据文字内容自动调整行高，确保文字能够完整显示。