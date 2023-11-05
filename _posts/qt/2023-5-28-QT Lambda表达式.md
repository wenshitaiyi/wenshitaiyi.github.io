---
layout: post
title: QT Lambda表达式
subtitle: C++11之后lambda在代码中出现的越来越多
date: 2023-05-28 10:08:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,Lambda]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QT connect lambda表达式注意事项

```cpp
//参数不匹配[失败]
QPushButton* btn;
connect(btn,&QPushButton::clicked,this,[](GTMap* pMap){
		printf("can compile.");
	});
//隐式类型转换[通过]
QPushButton* btn;
	connect(btn,&QPushButton::clicked,this,[](int a){
		printf("can compile.");
	});

// 参数个数太多[失败]
QPushButton* btn;
	connect(btn,&QPushButton::clicked,this,[](int a, int b){
		printf("can compile.");
	});
```

- 槽函数的参数个数小于等于信号的参数个数

- 信号里面的参数将会传递给槽函数或者lambda表达式

- 如果lambda表达式中的参数列表对应不上，将产生以下错误

  - ```
    c:\qt\gtqt\include\qtcore\qobject.h(331): error C2338: Signal and slot arguments are not compatible.
    1>          UITBBinder.cpp(47): 参见对正在编译的函数 模板 实例化“QMetaObject::Connection QObject::connect<void(__thiscall QAbstractButton::* )(bool),`anonymous-namespace'::<lambda2>>(const QAbstractButton *,Func1,const QObject *,Func2,Qt::ConnectionType)”的引用
    1>          with
    1>          [
    1>              Func1=void (__thiscall QAbstractButton::* )(bool),
    1>              Func2=`anonymous-namespace'::<lambda2>
    1>          ]
    1>
    1>Build FAILED.
    ```

## 具有重载特性的槽函数，connect写法

```cpp
QDoubleSpinBox * pBox;//这一行不能直接复制，需要处理
connect(pBox,static_cast<void(QDoubleSpinBox::*)(double)>(&QDoubleSpinBox::valueChanged),this,[=](double value)
    {
		//处理逻辑
	});
//or 5.7开始可以使用QOverload宏写重载，这种写法更像符合语言描述的习惯
connect(doubleSpinBox, QOverload<double>::of(&QDoubleSpinBox::valueChanged),[=](double d)
    { 
    	//处理逻辑    
    });
```



## lambda表达式的使用

相关链接：

- [C++ 中的 Lambda 表达式](https://learn.microsoft.com/zh-cn/cpp/cpp/lambda-expressions-in-cpp?view=msvc-170)
- [Visual Stdio 2022 C++ 语言文档](https://learn.microsoft.com/zh-cn/cpp/cpp/?view=msvc-170)