---
layout: post
title: LoadLibraryA 是否会重复加载dll
subtitle: 动态库加载
date: 2023-05-28 10:04:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [WinAPI,DLL]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# LoadLibraryA 是否会重复加载dll

## 说明

在 Windows 系统中，`LoadLibraryA` 函数用于加载动态链接库 (DLL)。当调用 `LoadLibraryA` 函数时，操作系统会尝试加载指定的 DLL 文件并创建一个进程内的模块。

如果在同一个进程中多次调用 `LoadLibraryA` 函数并传递相同的 DLL 文件路径，操作系统只会加载一次该 DLL。操作系统会维护一个计数器来跟踪 DLL 的加载次数，每次调用 `LoadLibraryA` 函数会将计数器加一。只有在计数器归零时，才会释放 DLL 并卸载它。

这意味着，多次调用 `LoadLibraryA` 函数加载相同的 DLL 不会导致重复加载，而是会增加 DLL 的加载次数计数。只有在最后一次调用 `FreeLibrary` 函数释放 DLL 并将计数器归零后，DLL 才会被真正卸载。

需要注意的是，在使用 `LoadLibraryA` 函数加载 DLL 时，需要遵循相应的加载和卸载流程，确保正确地管理 DLL 的加载和卸载，以避免资源泄露或冲突的问题。

## 使用示例

以下是一个使用 `LoadLibraryA` 和 `FreeLibrary` 函数的示例：

```cpp
#include <Windows.h>
#include <iostream>

int main()
{
    // 加载 DLL
    HMODULE hModule = LoadLibraryA("example.dll");
    if (hModule == nullptr) {
        std::cout << "Failed to load DLL." << std::endl;
        return 1;
    }

    // 调用 DLL 中的函数
    // ...

    // 卸载 DLL
    if (!FreeLibrary(hModule)) {
        std::cout << "Failed to unload DLL." << std::endl;
        return 1;
    }

    return 0;
}
```

在示例中，首先使用 `LoadLibraryA` 函数加载名为 "example.dll" 的 DLL。如果加载成功，返回一个有效的模块句柄 `hModule`；否则，返回 `nullptr`。然后可以通过该句柄调用 DLL 中的函数。最后，使用 `FreeLibrary` 函数释放 DLL，确保 DLL 的加载次数计数归零并卸载 DLL。

请根据实际情况将示例中的 "example.dll" 替换为你要加载的 DLL 文件路径。另外，务必进行适当的错误处理，以处理加载和卸载 DLL 可能出现的错误情况。

## QT加载dll的方式

在 Qt 中，可以使用 `QLibrary` 类来加载和使用动态链接库（DLL）。

以下是一个使用 `QLibrary` 加载 DLL 的示例：

```cpp
#include <QCoreApplication>
#include <QLibrary>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    // 加载 DLL
    QLibrary myLibrary("example.dll");
    if (!myLibrary.load()) {
        qDebug() << "Failed to load DLL:" << myLibrary.errorString();
        return 1;
    }

    // 检查 DLL 是否加载成功
    if (!myLibrary.isLoaded()) {
        qDebug() << "Failed to load DLL:" << myLibrary.errorString();
        return 1;
    }

    // 获取并调用 DLL 中的函数
    typedef int (*MyFunctionType)();
    MyFunctionType myFunction = reinterpret_cast<MyFunctionType>(myLibrary.resolve("myFunction"));
    if (myFunction) {
        int result = myFunction();
        qDebug() << "Result from DLL function:" << result;
    } else {
        qDebug() << "Failed to resolve function from DLL:" << myLibrary.errorString();
        return 1;
    }

    // 卸载 DLL
    myLibrary.unload();

    return a.exec();
}
```

在示例中，首先创建一个 `QLibrary` 对象，并指定要加载的 DLL 文件路径（例如 "example.dll"）。然后使用 `load` 函数加载 DLL。如果加载成功，可以通过 `isLoaded` 函数检查 DLL 是否加载成功。接下来，可以使用 `resolve` 函数获取 DLL 中的函数指针，并将其转换为适当的函数类型。如果函数解析成功，可以调用该函数。最后，使用 `unload` 函数卸载 DLL。

## 查看dll的导出函数

可以使用控制台命令 `dumpbin` 来查看 Windows 下 DLL 中导出的函数。以下是使用命令行查看 DLL 导出函数的步骤：

1. 打开命令提示符（CMD）或 PowerShell。

2. 使用 `cd` 命令切换到 DLL 文件所在的目录。

3. 运行以下命令查看 DLL 的导出函数：

   ```bash
   dumpbin /exports YourDll.dll
   ```

   将 `YourDll.dll` 替换为你要查看的实际 DLL 文件名。

4. 命令执行后，会在控制台中显示 DLL 中导出的函数列表。

请注意，`dumpbin` 命令是 Visual Studio 提供的工具，因此需要确保你的系统已经安装了 Visual Studio 或者已经设置了相应的环境变量。

> 如果已经安装了VS可以直接使用VS的控制台打开，在Win10系统中，通常可以在开始菜单中找到。	
> 名称类似于：`Developer Command Prompt for VS 2019`