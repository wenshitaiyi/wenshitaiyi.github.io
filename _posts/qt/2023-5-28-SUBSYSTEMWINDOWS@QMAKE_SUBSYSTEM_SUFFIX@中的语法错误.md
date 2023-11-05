---
layout: post
title: “SUBSYSTEM:WINDOWS@QMAKE_SUBSYSTEM_SUFFIX@” 中的语法错误
subtitle: 莫名其妙的编译错误，是和VS中的项目配置有关系的
date: 2023-05-28 10:14:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [QT,VS,编译]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# “SUBSYSTEM:WINDOWS@QMAKE_SUBSYSTEM_SUFFIX@” 中的语法错误

将【链接器】【命令行】【其他】项里面的内容删掉即可

注：应该是QT的插件自动设置上的一些内容。

## 关于 QMAKE_SUBSYSTEM_SUFFIX

`SUBSYSTEM:WINDOWS@QMAKE_SUBSYSTEM_SUFFIX` 是在 Qt 的 `.pro` 文件中用于设置生成的可执行文件的子系统的指令。

在 Windows 平台上，可执行文件的子系统指定了程序运行时的环境，包括窗口、控制台等。`SUBSYSTEM:WINDOWS` 指定了生成的可执行文件为 Windows 子系统，它以窗口方式运行。

`QMAKE_SUBSYSTEM_SUFFIX` 是一个变量，用于指定生成的可执行文件的后缀名。在 Windows 上，可执行文件的后缀通常是 `.exe`。

通过将 `SUBSYSTEM:WINDOWS` 和 `@QMAKE_SUBSYSTEM_SUFFIX` 结合使用，可以在 Qt 的 `.pro` 文件中设置生成的可执行文件为 Windows 子系统，并指定后缀名为 `.exe`。示例代码如下：

```pro
TEMPLATE = app
TARGET = MyApp

# 设置生成的可执行文件为 Windows 子系统，并指定后缀名为 .exe
win32:CONFIG(release, debug|release) {
    QMAKE_LFLAGS += /SUBSYSTEM:WINDOWS@QMAKE_SUBSYSTEM_SUFFIX@
}

# 其他配置项...
```

上述代码将生成的可执行文件指定为 Windows 子系统，并使用 `.exe` 作为后缀名。你可以根据需要进行调整和修改。