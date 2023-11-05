---
layout: post
title: 使用Qcompleter制作QCombobox的搜索下拉框
subtitle: 
date: 2023-05-21 04:00:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QCombobox]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# 使用Qcompleter制作QCombobox的搜索下拉框

要使用 QCompleter 在 QComboBox 中实现搜索下拉框，完整的示例代码如下：

```cpp
#include <QApplication>
#include <QComboBox>
#include <QCompleter>
#include <QStringListModel>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    // 创建 QComboBox 和 QCompleter 对象
    QComboBox comboBox;
    QCompleter completer;

    // 设置下拉框选项
    QStringList options;
    options << "Apple" << "Banana" << "Orange" << "Pear";

    // 设置自动完成模型
    completer.setModel(new QStringListModel(options, &completer));

    // 将 QCompleter 与 QComboBox 关联
    comboBox.setCompleter(&completer);

    // 显示窗口
    comboBox.show();

    return app.exec();
}
```

通过运行这个示例程序，您将看到一个具有搜索下拉框功能的 QComboBox。在输入框中输入文本时，它将根据输入的内容自动完成或过滤下拉框的选项。

在这个示例中，我们将 QStringListModel 对象作为 QCompleter 的模型传递，而 QCompleter 会负责管理这个模型的生命周期。因此，在这种情况下，您不需要手动释放 QStringListModel 对象。

当 QCompleter 被销毁时，它会自动删除其关联的模型对象。所以您可以放心地让 QCompleter 管理 QStringListModel 的释放。

值得注意的是，在其他情况下，如果您直接创建了一个对象并在程序的其他部分使用它，您需要在适当的时候手动释放该对象，以避免内存泄漏。但是在这个特定的示例中，由于 QCompleter 负责管理模型对象，您不需要显式释放 QStringListModel。

注意：上述代码中是直接在main函数中写的示例，在真实使用的时候需要再某函数体内写，且需要注意擅用Qt的元对象机制，注意动态内存管理。

