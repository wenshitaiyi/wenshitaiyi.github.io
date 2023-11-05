---
layout: post
title: QMainWindow添加状态栏提示
date: 2023-05-21 01:00:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,QMainWindow]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QMainWindow添加状态栏提示

直接上代码：

```c++
//其中ui.statusBar是MainWindow状态栏指针
QLabel* m_pMousePoint = nullptr;//屏幕坐标
QLabel* m_pMapPoint = nullptr;	//地理坐标
QLabel* m_pMapScale = nullptr;	//当前比例尺
m_pMousePoint = new QLabel(QString::fromLocal8Bit("屏幕坐标:(0,0)"),ui.statusBar);
m_pMousePoint->setGeometry(1,ui.statusBar->y()-2,200,ui.statusBar->height());
m_pMapPoint = new QLabel(QString::fromLocal8Bit("地理:(0,0)"),ui.statusBar);
m_pMapPoint->setGeometry(200,ui.statusBar->y()-2,200,ui.statusBar->height());
m_pMapScale = new QLabel(QString::fromLocal8Bit("比例尺:(0,0)"),ui.statusBar);
m_pMapScale->setGeometry(400,ui.statusBar->y()-2,200,ui.statusBar->height());
```

> 使用的是绝对坐标，通过stausBar自身的坐标来获取位置，并同时获取宽高

## 推测

在```QMainWindow```的类中```ui.statusBar```是类```QStatusBar```，继承于```QWidget```,如此一来便可使用布局，使得状态栏中所有的内容都挤在右侧或者左侧，类似于以下代码：

```c++
QVBoxLayout* pLayout = new QVBoxLayout(ui.statusBar);
ui.statusBar->setLayout(pLayout);
//添加第一个label
{
    QLabel* pLabel = new QLabel(QString::fromLocal8Bit("屏幕坐标:(0,0)"),ui.statusBar);
    pLayout->addWidget(pLabel);
}
//添加第二个label
{
    QLabel* pLabel = new QLabel(QString::fromLocal8Bit("屏幕坐标:(0,0)"),ui.statusBar);
    pLayout->addWidget(pLabel);
}
//添加第三个label
{
    QLabel* pLabel = new QLabel(QString::fromLocal8Bit("屏幕坐标:(0,0)"),ui.statusBar);
    pLayout->addWidget(pLabel);
}
//添加拉伸
{
    auto pSpacer = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);
    pLayout->addItem(pSpacer);
}

```

> 注：上面的这一段代码是直接手写的，没有经过验证，应该没有问题。

## 其他

- 关于```{}```的使用

  - 有的时候不想写循环，但是代码又有很多重复，每一次都重新命名变量属实没有必要，这个时候可以使用```{}```将上下文断开；

  - 还有一种情况就是，为了初始化一个量，可以有下面的写法：

  - ```c++
    QLabel* pLabel = nullptr;
    {
        //初始化pLabel
        //设定一系列的参数
    }
    ```

    这样写法可以让代码看着比较简洁。

- 用代码书写ui布局

  - 参考官方文档进行书写
  - 复制uic出来的的```ui_xxxx.h```文件中的内容
    - 编译ui文件的时候，会自动生成一个```ui_xxxx.h```文件
    - 这个文件中有比较标准的布局使用代码
    - 推荐使用这种方式来掌握ui布局的代码写法

> 若是有益，望君不吝点赞~