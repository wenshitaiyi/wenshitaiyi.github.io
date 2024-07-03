---
layout: post
title: Acoustics Toolbox 翻译
subtitle: 关于Bellhop各个版本的介绍
aliases: 
date: 2024-01-28 00:01:12
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - 翻译
  - 水声工具箱
url: http://oalib.hlsresearch.com/AcousticsToolbox/
typora-copy-images-to: ../img/post
typora-root-url: ../
number headings: off
---

> *updated 18 May 2023*
>
> url: http://oalib.hlsresearch.com/AcousticsToolbox/

The Acoustics Toolbox is distributed under the GNU Public License.

声学工具箱（Acoustics Toolbox）采用GNU公共许可证发布。
## Download 下载

- at source code (zip file) for Mac, Linux, or Windows. Binaries are *NOT* provided. (2023_5_18)
- at Binaries (zip file) for Windows 10. This version is older than the one above. (The source code is also included so that you can access the compatible Matlab routines that read/write model input/output.) (2020_11_4)


- 提供源代码（zip文件）适用于Mac、Linux或Windows。二进制文件*不*提供。（2023_5_18）
- 提供Windows 10的二进制文件（zip文件）。此版本比上述版本旧。（源代码也包含在内，以便您可以访问兼容的Matlab程序，用于读写模型输入/输出。）（2020_11_4）

---

The Fortran2008 source code should be fully portable. The Windows10 binaries were compiled for a plain vanilla Intel architecture. Therefore they will likely be slower that one that you compile yourself for the native architecture.

Fortran2008源代码应该是完全可移植的。Windows10二进制文件是为普通的英特尔架构编译的。因此，它们可能会比您为本地架构自行编译的要慢。

## Compiling the package 编译包

The Fortran95 standard does not clarify whether record lengths are in bytes or words. For some compilers, e.g. the Intel Fortran you need to use a compiler switch making bytes the standard unit for record lengths. We use the free gfortran compiler.

Fortran95标准没有明确记录长度是以字节还是字来计算。对于某些编译器，例如Intel Fortran，您需要使用编译器开关，使字节成为记录长度的标准单位。我们使用免费的gfortran编译器。

---

The compilation is done using standard Makefiles that work under Unix, OS X, etc. We also use them under Windows with either the Cygwin system or MinGW, which provide a Unix-like environment under Windows. Cygwin and Mingw are also freely distributed.

```bash
make clean # to remove old objects and executables

make # to compile (can also say 'make all' )

!!!! make install # to move the binaries to at/bin (currently not implemented)
```

编译是使用标准Makefiles完成的，这些Makefiles适用于Unix、OS X等系统。我们也在Windows下使用它们，结合Cygwin系统或MinGW，这些系统在Windows下提供类Unix环境。Cygwin和Mingw也是免费分发的。

```bash
make clean # 删除旧的对象和可执行文件

make # 进行编译（也可以说'make all'）

!!!! make install # 将二进制文件移动到at/bin（当前未实现）
```

---

## Running the package 运行包

We currently run the Acoustics Toolbox through Matlab using shell-escape commands to execute the binaries and a variety of Matlab scripts and functions (in at/matlab) to manipulate and display the output. If you don't have Matlab then you'll have to figure out your own graphics. In that case, the Matlab plot routines at least provide a good example of how to read the file formats.

我们目前通过Matlab运行声学工具箱，使用shell-escape命令来执行二进制文件，并使用各种Matlab脚本和函数（在at/matlab中）来操纵和显示输出。如果您没有Matlab，那么您将需要自己解决图形问题。在这种情况下，Matlab绘图程序至少提供了一个很好的示例，说明如何读取文件格式。

---

The only challenge in this phase is to get the paths set up properly. When you call the Acoustics Toolbox through Matlab, you're using Matlab scripts. Those Matlab scripts use the Matlab 'which' command to find the location of the binaries within the Matlab search path. Therefore, Matlab has to have its path set to include the Acoustics Toolbox.

在这一阶段唯一的挑战是正确设置路径。当你通过Matlab调用声学工具箱时，你使用的是Matlab脚本。这些Matlab脚本使用Matlab的'which'命令来找到Matlab搜索路径中二进制文件的位置。因此，Matlab必须设置其路径以包含声学工具箱。

---

Here's an example of running kraken at the regular command line (rather than from inside Matlab):

```bash
cd at/tests/Munk
kraken.exe MunkK
```

The 'cd' command above is hypothetical. You should cd to the directory where you've created the Acoustics Toolbox. If you get an error, the likely problem is that the path is not set properly. The following commands may be useful in tracking that down.

```bash
printenv
which kraken.exe
```

这里有一个在常规命令行（而不是在Matlab内部）运行kraken的示例：

```bash
cd at/tests/Munk
kraken.exe MunkK
```

上面的'cd'命令是假设的。您应该cd到您创建声学工具箱的目录。如果您遇到错误，可能的问题是路径没有正确设置。以下命令可能有助于追踪这个问题。

```bash
printenv
which kraken.exe
```

---

If instead, you run the package through Matlab, start Matlab and make sure you have 'at' in your path. Check that by typing to following on the Matlab command line:

```shell
cd at/tests/Munk
kraken MunkK
```

If the above runs without error, then go to at/tests and type 'runtests' to execute a huge battery of test cases. If the above generates an error then it could be you don't have at/Matlab in your Matlab path.

如果您通过Matlab运行该包，请启动Matlab并确保您的路径中有'at'。通过在Matlab命令行输入以下内容来检查：

```shell
cd at/tests/Munk
kraken MunkK
```

如果上述操作没有错误，那么转到at/tests并输入'runtests'来执行大量的测试用例。如果上述操作产生错误，可能是因为您的Matlab路径中没有at/Matlab。

---

The test battery that you run by typing 'runtests' may fail somewhere unless you have a beefy computer--- it generates a very large number of figures and consumes a lot of memory in the process. However, it's easy enough to restart the test battery at exactly the point where it overwhelms your system.

通过输入'runtests'运行的测试套件可能在某处失败，除非您有一台高性能的计算机——它会生成大量的图表，并在此过程中消耗大量的内存。然而，重新启动测试套件并不难，只需在它压垮您的系统的那一点重新开始即可。

---

## MATLAB version of the Acoustics Toolbox 声学工具箱的MATLAB版本

Note that at/Matlab includes versions of BELLHOP, KRAKEL, SCOOTER, and SPARC in Matlab (Kraken to come soon). The Matlab versions are typically much slower; however, they're much easier to use and modify. The Matlab version of SCOOTER has an optional Mex file (thanks to Paul Hursky) for the inner loop which is a tridiagonal solver. If you compile the Mex file, the Matlab SCOOTER runs about as fast as the Fortran one. The Matlab versions are not maintained as carefully as the Fortran versions and may not have the latest updates.

请注意，at/Matlab包括Matlab中的BELLHOP、KRAKEL、SCOOTER和SPARC版本（Kraken即将推出）。Matlab版本通常要慢得多；然而，它们更容易使用和修改。SCOOTER的Matlab版本有一个可选的Mex文件（感谢Paul Hursky），用于内部循环，这是一个三对角求解器。如果您编译了Mex文件，Matlab版的SCOOTER运行速度大约与Fortran版一样快。Matlab版本没有像Fortran版本那样细心维护，可能没有最新的更新。

---

J. P. Ianniello also wrote a Matlab version of Kraken, called Krak_mat. See the link on oalib on the 'Modes' page. It implements the Kraken algorithm but is not set up to use the same input and output files.

J. P. Ianniello还编写了Kraken的Matlab版本，名为Krak_mat。请参阅oalib上“模式”页面上的链接。它实现了Kraken算法，但没有设置为使用相同的输入和输出文件。

---

There are demo versions of various acoustic models available. See the link for 'Demo' on oalib on the 'Other' page. These are 'toy' codes that illustrate the methods, but are not really suitable for realistic problems.

有各种声学模型的演示版本可用。请参阅oalib上“其他”页面上的“演示”链接。这些是说明方法的“玩具”代码，但并不真正适合实际问题。

---

The Acoustics Toolbox now includes a simple PE model in Matlab called (what else?) Simple.

声学工具箱现在包括一个简单的Matlab PE模型，名为（还能是什么？）Simple。

---

## GUI Wrappers: GUI包装器：

ACT: Matlab front-end providing a Graphical User Interface for the Acoustic Toolbox written by Alec Duncan from the Centre for Marine Science and Technology at Curtin University.

ACT：Matlab前端，为声学工具箱提供图形用户界面，由科廷大学海洋科学与技术中心的Alec Duncan编写。

---

## Python Tools: Python工具：

AcousticPy: Runs the test cases for the Acoustic Toolbox and provides components to read and plot various files--- written by Orlando Rodríguez from the University of Algarve.

AcousticPy：运行声学工具箱的测试用例，并提供读取和绘制各种文件的组件——由阿尔加夫大学的奥兰多·罗德里格斯编写。

---

arlpy, a Python interface to BELLHOP. Some of these tools may be useful for KRAKEN as well (September 2018)

- (Mandar Chitre, National University of Singapore)

arlpy，一个BELLHOP的Python接口。这些工具中的一些可能也对KRAKEN有用（2018年9月）

- （新加坡国立大学，Mandar Chitre）

---

## C++ and CUDA C++和CUDA

bellhopcxx/bellhopcuda Port of BELLHOP to multithreaded C++ and CUDA with compatible interface (based on BELLHOP release 2022_4 with bug fixes and some algorithmic changes). The speed up is roughly proportional to the number of processors. Contributed by the Jaffe Lab for Underwater Imaging, Scripps Institution of Oceanography, University of California, San Diego.

bellhopcxx/bellhopcuda BELLHOP移植到多线程C++和CUDA，具有兼容接口（基于BELLHOP 2022_4版本，带有错误修复和一些算法更改）。加速程度大致与处理器数量成正比。由加州大学圣迭戈分校海洋研究所的Jaffe实验室贡献。

---
> 比较可惜的事，md中并不能直接对文本进行上色，并不等很显眼的看出翻译的内容。