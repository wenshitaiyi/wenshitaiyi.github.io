---
layout: post
title: 2024-07-07-FileZillaServer使用
subtitle: 
aliases: 
date: 2024-07-07 13:32:05
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - 软件
  - FileZilla
  - FileZillaServer
typora-copy-images-to: ../img/post
typora-root-url: ../
---
## 1 准备工作

直接在[FileZilla官网](https://filezilla-project.org/)下载Server和Client，如果需要破解版或者是绿色版，可以直接上52pojie看看，说不定就有大佬发过帖子。

Server安装可以参考：[FileZilla Server详细安装过程和注意事项-CSDN博客](https://blog.csdn.net/qq_23313467/article/details/136345486)这篇文章，如果失效了，随便搜索一个教程也是可以使用的。

Server配置的时候会遇到一些问题，下面会说。

Client的安装非常的简单，基本上班族都知道，百度吧，骚年。

**补充**：

在Server的配置中，需要配置Group和User，可以勾选`Create native directory if it does not exits`，这样可以自动建立目录。

似乎配置的virtual path仅仅是用作某种标识的，感觉使用根路径应该也没有关系。更高深的配置还是以后学习吧。

## 2 Server访问问题

### 2.1 相关问题

Server：

- GnuTLS error -110 in gnutls_record_recv: The TLS connection was non-properly terminated
- 在Server ui的连接列表中，可以检测到连接，但是Transfer列显示的目录是`/`或者是其他的路径，总之不是idle
- 一段时间之后，client会自己断开
- client的用户验证可以通过

Client：

```txt
状态:        已连接  
状态:        读取目录列表...  
命令:        PWD  
返回:        257 "/" is current directory.  
命令:        TYPE I  
返回:        200 Type set to I  
命令:        PASV  
返回:        227 Entering Passive Mode (58,X,X,X,0,1)  
命令:        LIST  
返回:        425 Can't open data connection.  
错误:        读取目录列表失败
```

> [ftp 读取目录列表失败\_ftp currentdirectory-CSDN博客](https://blog.csdn.net/zzz_781111/article/details/6799010)
> 
> [求助filezilla读取目录列表失败，详细信息如下，该如何解决？-CSDN博客](https://blog.csdn.net/YYuanMa/article/details/136268886)



在尝试解决这个问题的过程中也是小有成果，开始安装的时候我还发现了另外一个文章：[FileZilla Server/Client 的简单使用\_filezilla ftp client-CSDN博客](https://blog.csdn.net/FL1768317420/article/details/137217231)，这里面安装好Server之后还对防火墙进行了配置，本不在意，最后发现Server的异常现象就是出现在防火墙设置上。

直接在本机使用Client连接的时候使用回环地址或者使用局域网本机地址都是可以使用的，**局域网中的另外一台机器在Server机器关闭防火墙之后也是恶意正常使用的**。

> win10关闭防火墙：
>
> 1. win+i 打开设置
> 2. windows安全中心
> 3. 防火墙和网络防护
> 4. 将所有的网络模式中的防火墙都关掉
>
> 网上大多数还是win7型的防火墙关闭，实际上win10的相关UI中是可以直接关闭的

### 2.2 FTP配置

网上大多数建立的都是入栈规则，这是不够的。

我的操作是，通过控制面板添加防火墙规则（入栈和出栈），允许`filezilla-server-gui.exe`和`filezilla-server.exe`的网络访问。

此外，入栈规则中增加FTP端口规则，开放21端口。

如果Server是被动模式，还需要配置被动模式端口范围，开放如50000-51000这样的端口范围。

> 可能是因为我的File Zilla Server不是pro版本，并没有找到一个位置设置“被动模式”。

基本上配置完毕之后，就可以正常访问了。

### 2.3 手机访问

电脑上可以使用File Zilla Client进行访问，手机上恶意使用**AndFTP**进行访问。

> 软件名称就是这个，不要下错了哦，如果需要可以邮箱联系。
>
> AndFTP使用的时候使用默认端口，选择UTF8编码格式，是可以正常访问的。

## 3 日志

之前使用的是Win10自带的FTP，感觉不是很好用，不能灵活开关，并且本地的IP地址经常会改变，导致每次都需要调整配置，由于是家庭版的win10，我还需要自己手动的建立另外一个小号专门用来进行FTP的访问，直到某天我把密码忘了，发现这并不是一个很好的FTP解决方式。

### 3.1 ChatGPT

你可以在防火墙设置中为FileZilla Server创建入站和出站规则，以允许FTP流量通过。以下是详细步骤：

**通过控制面板添加防火墙规则**

1. 打开控制面板。
2. 点击“系统和安全”。
3. 点击“Windows Defender 防火墙”。
4. 在左侧菜单中，点击“高级设置”以打开Windows防火墙的高级安全设置窗口。
5. 在左侧菜单中，选择“入站规则”。
6. 在右侧菜单中，点击“新建规则…”。
7. 在规则类型页面，选择“程序”，然后点击“下一步”。
8. 选择“此程序路径”，然后点击“浏览”并找到FileZilla Server的可执行文件（例如`FileZilla Server.exe`）。点击“下一步”。
9. 选择“允许连接”，然后点击“下一步”。
10. 在配置文件页面，确保选中所有选项（域、专用、公用），然后点击“下一步”。
11. 在名称页面，给规则命名（例如“允许FileZilla Server”），然后点击“完成”。

接下来，为出站规则重复上述步骤：

1. 在左侧菜单中，选择“出站规则”。
2. 点击“新建规则…”。
3. 选择“程序”，点击“下一步”。
4. 选择“此程序路径”，浏览并找到FileZilla Server的可执行文件，点击“下一步”。
5. 选择“允许连接”，点击“下一步”。
6. 确保选中所有配置文件选项（域、专用、公用），点击“下一步”。
7. 给规则命名（例如“允许FileZilla Server出站”），点击“完成”。

**配置FTP端口规则**

FTP使用特定的端口（通常为21）进行通信，你还需要为这些端口创建防火墙规则：

1. 在“入站规则”中，点击“新建规则…”。
2. 选择“端口”，点击“下一步”。
3. 选择“特定本地端口”，并输入21（FTP控制端口），点击“下一步”。
4. 选择“允许连接”，点击“下一步”。
5. 确保选中所有配置文件选项（域、专用、公用），点击“下一步”。
6. 给规则命名（例如“允许FTP端口21”），点击“完成”。

**配置被动模式端口范围**

如果你使用被动模式FTP，需要为被动模式端口范围创建规则：

1. 在“入站规则”中，点击“新建规则…”。
2. 选择“端口”，点击“下一步”。
3. 选择“特定本地端口”，并输入你在FileZilla Server中配置的被动模式端口范围（例如50000-51000），点击“下一步”。
4. 选择“允许连接”，点击“下一步”。
5. 确保选中所有配置文件选项（域、专用、公用），点击“下一步”。
6. 给规则命名（例如“允许被动模式端口”），点击“完成”。

完成这些步骤后，你的防火墙应允许FileZilla Server的FTP连接通过。重新启用防火墙，并测试局域网中的其他计算机能否正常连接和读取用户目录。