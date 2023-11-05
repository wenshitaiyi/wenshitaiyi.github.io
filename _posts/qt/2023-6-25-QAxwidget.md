---
layout: post
title: QAxwidget使用记录
subtitle: QT中使用OCX（有很多坑）
date: 2023-06-25 10:05:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,OCX,编译]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# QAxwidget使用记录

## Qaxwidget QAxserver regsvr32

```
regsvr32
this application failed to start because it could not find or load the QT platforrm plugin "windows" in "".
Available platforem plugins ar:windows
Reinstalling the application may fix this problem.
```

### idc.exe

```
QObject::moveToThread: Current thread (0x1e286aa0a60) is not the object's thread (0x2490).
Cannot move to target thread (0x1e286aa0a60)

This application failed to start because it could not find or load the Qt platform plugin "windows"
in "".

Available platform plugins are: windows.

Reinstalling the application may fix this problem.
```

> 备注：QT不能正确的找到对应平台的库：qwindows.dll

#### QT注册com的方式与普通注册方式比较

##### Qt的方式

```
set "GTTargetDir=C:\temp64\gtmap\bin\release\register"

C:\qt\5.9.1\msvc2017_64\bin\idc.exe "%GTTargetDir%\GTEntityUI.dll" /idl "%GTTargetDir%/GTEntityUI.idl" -version 1.0
midl "%GTTargetDir%/GTEntityUI.idl" /tlb "%GTTargetDir%/GTEntityUI.tlb"
C:\qt\5.9.1\msvc2017_64\bin\idc.exe "%GTTargetDir%\GTEntityUI.dll" /tlb "%GTTargetDir%/GTEntityUI.tlb"
C:\qt\5.9.1\msvc2017_64\bin\idc.exe "%GTTargetDir%\GTEntityUI.dll" /regserver
```

> 备注：**需要在VS2019的运行时中运行**

##### 普通方式

```
regsvr32 /s "%GTTargetDir%\GTEntityUI.dll"
```

> QT的方式可以同时注册多个com，但是普通方式只能注册一个com组件，QT提供一种方式axfactory，可以通过一个dll同时设置多个面板！！！

#### 对于 qwindows.dll

其加载策略是QT写好的：

- 首先检测plugins文件夹是否存在，
- 存在时找plugins/platforms/qwindows_XX.dll
- 如果没有直接在同级目录下找platforms/qwindows_XX.dll

**Dll连接机制并不是以名称作为唯一标识的**，对于不同版本的同一个dll，可以将其加上版本号进行区分，以此做到同一个bin目录下有两个运行环境。

#### 解决策略

比如，上述的注册错误，只需要在plugins目录下，调整为如下结构即可：

```
├─audio
│      qtaudio_windowsGT.dll
│
├─designer
│      GTGuiDesignerPlugins.dll
│      qaxwidgetGT.dll
│
├─iconengines
│      qsvgicon.dll
│
├─imageformats
│      qgif.dll
│      qgifGT.dll
│      qicns.dll
│      qicnsGT.dll
│      qico.dll
│      qicoGT.dll
│      qjpeg.dll
│      qjpegGT.dll
│      qsvg.dll
│      qsvgGT.dll
│      qtga.dll
│      qtgaGT.dll
│      qtiff.dll
│      qtiffGT.dll
│      qwbmp.dll
│      qwbmpGT.dll
│      qwebp.dll
│      qwebpGT.dll
├─platforms
│      qwindows.dll
│      qwindowsGT.dll
│
├─printsupport
│      windowsprintersupportGT.dll
│
└─styles
        GTGuiStylesPlugin.dll
```

>  所有qt563的库都有对应的标识，所有qt591的库则使用原始命名！

#### 关于dll

- 同样的dll在不同的路径，可以被加载两次
- 在同一个路径，好像只会被加载一次 [验证了一下，应该是对的！！！]
- 不管是静态依赖，或者是通过axwidget->setcontrol的方式，都是一次，先后顺序不重要！！！

#### Class has no metaobject information

大概率是以为当前这个dll的依赖链，在bin[运行]目录下，找不完全！！！

#### 运行环境子目录，注册方法

Idc.exe运行的时候，至少要在某运行环境中；比如上述错误的出现，是因为在运行环境中又多了一级插件环境，当执行idc编译命令的时候：

```bash
cd /d C:\temp64\gtmap\bin\release
# 备注：其中红字标识的内容，在环境变量中添加了主程序的运行环境
# set PATH=C:\temp64\gtmap\bin\release;%PATH%
# 如果是运行环境子目录 plugin_sim，则在注册的时候也应当将这个目录添加到环境变量中，
# 因为这个目录中的库互相依赖同时还依赖了运行环境中的库
set PATH=C:\temp64\gtmap\bin\release;set PATH=C:\temp64\gtmap\bin\release\plugin_sim;%PATH%
set QT_PLUGIN_PATH=$(QTDIR)\plugins
$(QTDIR)\bin\idc.exe "$(TargetPath)" /idl "$(IntDir)$(TargetName).idl" -version 1.0
midl "$(IntDir)$(TargetName).idl" /h nul /iid nul  /tlb "$(IntDir)$(TargetName).tlb"
$(QTDIR)\bin\idc.exe "$(TargetPath)" /tlb "$(IntDir)$(TargetName).tlb"
```

注：基本上QT自己生成的注册流程是没有问题的，千万不要自己将这部分注册的过程单独抽离出来，使其成为dll编译后手动执行的过程。

### 多面板注册

#### QT 官方示例

```cpp
#include <QAxFactory>
#include <QCheckBox>
#include <QRadioButton>
#include <QPushButton>
#include <QToolButton>
#include <QPixmap>

/* XPM */
static const char *fileopen[] = {
"    16    13        5            1",
". c #040404",
"# c #808304",
"a c None",
"b c #f3f704",
"c c #f3f7f3",
"aaaaaaaaa...aaaa",
"aaaaaaaa.aaa.a.a",
"aaaaaaaaaaaaa..a",
"a...aaaaaaaa...a",
".bcb.......aaaaa",
".cbcbcbcbc.aaaaa",
".bcbcbcbcb.aaaaa",
".cbcb...........",
".bcb.#########.a",
".cb.#########.aa",
".b.#########.aaa",
"..#########.aaaa",
"...........aaaaa"
};


//! [0]
class ActiveQtFactory : public QAxFactory
{
public:
    ActiveQtFactory( const QUuid &lib, const QUuid &app )
        : QAxFactory( lib, app )
    {}
    QStringList featureList() const
    {
        QStringList list;
        list << "QCheckBox";
        list << "QRadioButton";
        list << "QPushButton";
        list << "QToolButton";
        return list;
    }
    QObject *createObject(const QString &key)
    {
        if ( key == "QCheckBox" )
            return new QCheckBox(0);
        if ( key == "QRadioButton" )
            return new QRadioButton(0);
        if ( key == "QPushButton" )
            return new QPushButton(0 );
        if ( key == "QToolButton" ) {
            QToolButton *tb = new QToolButton(0);
//          tb->setIcon( QPixmap(fileopen) );
            return tb;
        }

        return 0;
    }
    const QMetaObject *metaObject( const QString &key ) const
    {
        if ( key == "QCheckBox" )
            return &QCheckBox::staticMetaObject;
        if ( key == "QRadioButton" )
            return &QRadioButton::staticMetaObject;
        if ( key == "QPushButton" )
            return &QPushButton::staticMetaObject;
        if ( key == "QToolButton" )
            return &QToolButton::staticMetaObject;

        return 0;
    }
    QUuid classID( const QString &key ) const
    {
        if ( key == "QCheckBox" )
            return "{6E795DE9-872D-43CF-A831-496EF9D86C68}";
        if ( key == "QRadioButton" )
            return "{AFCF78C8-446C-409A-93B3-BA2959039189}";
        if ( key == "QPushButton" )
            return "{2B262458-A4B6-468B-B7D4-CF5FEE0A7092}";
        if ( key == "QToolButton" )
            return "{7c0ffe7a-60c3-4666-bde2-5cf2b54390a1}";

        return QUuid();
    }
    QUuid interfaceID( const QString &key ) const
    {
        if ( key == "QCheckBox" )
            return "{4FD39DD7-2DE0-43C1-A8C2-27C51A052810}";
        if ( key == "QRadioButton" )
            return "{7CC8AE30-206C-48A3-A009-B0A088026C2F}";
        if ( key == "QPushButton" )
            return "{06831CC9-59B6-436A-9578-6D53E5AD03D3}";
        if ( key == "QToolButton" )
            return "{6726080f-d63d-4950-a366-9bf33e5cdf84}";

        return QUuid();
    }
    QUuid eventsID( const QString &key ) const
    {
        if ( key == "QCheckBox" )
            return "{FDB6FFBE-56A3-4E90-8F4D-198488418B3A}";
        if ( key == "QRadioButton" )
            return "{73EE4860-684C-4A66-BF63-9B9EFFA0CBE5}";
        if ( key == "QPushButton" )
            return "{3CC3F17F-EA59-4B58-BBD3-842D467131DD}";
        if ( key == "QToolButton" )
            return "{f4d421fd-4ead-4fd9-8a25-440766939639}";

        return QUuid();
    }
};
//! [0] //! [1]

QAXFACTORY_EXPORT( ActiveQtFactory, "{3B756301-0075-4E40-8BE8-5A81DE2426B7}", "{AB068077-4924-406a-BBAF-42D91C8727DD}" )
//! [1]
```

路径："C:\qt\5.6.3\msvc2010x64\examples\activeqt\wrapper"

备注：这种方式提供了同时注册多个面板的方式。

#### 调整成为适应项目的工厂模式

```cpp
//头文件
#pragma once
#include <QAxFactory>

class ActiveUIFactory : public QAxFactory
{
public:
	ActiveUIFactory(const QUuid& lib, const QUuid& app)
		: QAxFactory(lib, app)
	{
		int a = 0;
	}
	QStringList featureList() const;
	QObject* createObject(const QString& key);
	const QMetaObject* metaObject(const QString& key) const;
	QUuid classID(const QString& key) const;
	QUuid interfaceID(const QString& key) const;
	QUuid eventsID(const QString& key) const;
};


//实现
#include "ActiveUIFactory.h"
#include "GTEntityUI_Module_Impl.h"

QStringList ActiveUIFactory::featureList() const
{
	return M_ModelImpl()->GetRegisterItemList();
}

QObject* ActiveUIFactory::createObject(const QString& key)
{
	if (auto f = M_ModelImpl()->GetWidgetClsItem(key.toLocal8Bit().data()))
	{
		return f->m_creator();
	}
	return 0;
}

#include <cstdio>
const QMetaObject* ActiveUIFactory::metaObject(const QString& key) const
{
	printf("use: %s\n", key.toLocal8Bit().data());
	if (auto f = M_ModelImpl()->GetWidgetClsItem(key.toLocal8Bit().data()))
	{
		return f->m_metaObject;
	}
	return 0;
}
QUuid ActiveUIFactory::classID(const QString& key) const
{
	if (auto f = M_ModelImpl()->GetWidgetClsItem(key.toLocal8Bit().data()))
	{
		return f->m_clsID;
	}
	return QUuid();
}
QUuid ActiveUIFactory::interfaceID(const QString& key) const
{
	if (auto f = M_ModelImpl()->GetWidgetClsItem(key.toLocal8Bit().data()))
	{
		return f->m_interfaceID;
	}
	return QUuid();
}
QUuid ActiveUIFactory::eventsID(const QString& key) const
{
	if (auto f = M_ModelImpl()->GetWidgetClsItem(key.toLocal8Bit().data()))
	{
		return f->m_eventID;
	}
	return QUuid();
}

QAXFACTORY_EXPORT(
	ActiveUIFactory,
	"{4FF5153F-5FA6-40D4-B953-8C75512AE625}",
	"{273EE45E-3E59-4DF3-8B62-A02F2EF275E7}"
)
```

备注：M_ModelImpl()是真实注册的模块，可以自己定义！在这个模块中可以获取到所有注册注册内容对应这几个函数的值。

### 实际情况

有一个GTEntityUI.dll的Axserver的工程已经具备了上述的factory，由于项目内模块颇多，且有需求需要挂载新的模块使用，则此时，要求该dll注册的时候能够同时将附属的几个功能模块注册进去。

部分代码如下:

```cpp
GTEntityUI_Module_Impl* g_pModuleImpl = nullptr;

/*
* set "GTTargetDir=C:\temp64\gtmap\bin\release\register"
* C:\qt\5.9.1\msvc2017_64\bin\idc.exe "%GTTargetDir%\GTEntityUI.dll" /idl "%GTTargetDir%/GTEntityUI.idl" -version 1.0
* midl "%GTTargetDir%/GTEntityUI.idl" /tlb "%GTTargetDir%/GTEntityUI.tlb"
* C:\qt\5.9.1\msvc2017_64\bin\idc.exe "%GTTargetDir%\GTEntityUI.dll" /tlb "%GTTargetDir%/GTEntityUI.tlb"
* C:\qt\5.9.1\msvc2017_64\bin\idc.exe "%GTTargetDir%\GTEntityUI.dll" /regserver
* 
* 备注：如果有需要加载的附属模块[普通的dll]，且希望该模块具备提供ocx面板的能力
*	1、注册时需要在2019的运行时下运行
*	2、需要切换到软件的运行目录，比如C:\\temp64\\gtmap\\bin\\release
*	3、或者在load dll 的时候写绝对路径
*/
#include <QLibrary>
GTEntityUI_Module_Impl* GTEntityUI_Module_Impl::GetInstance()
{
	if (!g_pModuleImpl)
	{
		g_pModuleImpl = new GTEntityUI_Module_Impl;
		printf("[Get Impl] addr = 0x%p\n", g_pModuleImpl);

		//QByteArray dllName = "C:\\temp64\\gtmap\\bin\\release\\GTEntityUI_ExtendWidget.dll";
		QByteArray dllName = "GTEntityUI_ExtendWidget.dll";
		printf("[Info] Try load dll %s\n", dllName.data());
		QLibrary loader(dllName);
		loader.load();
		if (!loader.isLibrary(dllName))
		{
			printf("%s not a library!\n", dllName.data());
		}
		if (loader.isLoaded())
		{
			printf("%s load success!\n", dllName.data());
		}
	}
	return g_pModuleImpl;
}
```

备注：如果不按照上述流程来，则可能使得注册的DLL无法生效。

思想：GTEntityUI.dll提供出来接口，支持其他的DLL通过此接口完成注册过程，注册的内容会统一流入Uidll的factory中，后期该DLL执行regserver过程的时候，主动加载相关dll，此时会调用到其他dll的注册函数。