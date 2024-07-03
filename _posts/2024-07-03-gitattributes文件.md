---
layout: post
title: 2024-07-03-gitattributes文件
subtitle: 
aliases: 
date: 2024-07-03 13:54:35
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - git
typora-copy-images-to: ../img/post
typora-root-url: ../
---
## 1 如何使用

## 2 FAQs
### 2.1 This diff contains a change in line endings from 'LF' to 'CRLF'.

ref:[This diff contains a change in line endings from 'LF' to 'CRLF'. · Issue #18225 · desktop/desktop · GitHub](https://github.com/desktop/desktop/issues/18225#issuecomment-1966401022)

As a fix, you can use `git config core.autocrlf input` in the required directory.

Better use:  
`.gitattributes`

```
* text eol=lf
```

This will set the correct settings for all repository users, not locally.