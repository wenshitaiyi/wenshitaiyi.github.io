---
layout: post
title: 开垦荒原，准备种地
subtitle: 种地的一些小细节
date: 2023-11-3 22:49:34
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [测试]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

进行一些小小的测试，方便以后更好的种地！

## 图像测试

![image-20231104170741574](/img/post/image-20231104170741574.png)

可以书写相对路径，路径的根是仓库的根。可以和原来博主的模板一样，将图像放在img文件夹下，并且在其中建立post文件夹专门用来存放博客中需要的图像。

但，根据目前了解到的内容，git仓库的容量是有限的，图像会少放一些，后续的博文尽量以文字为主。或者等经济上略微好转，便找一个不错的图床。（不过我依旧觉得相对路径才是最有效的，博客在本地或者git上都可以查看。）

## 文章头

```
---
layout: post
title: 种地测试
subtitle: 种地的一些小细节
date: 2023-11-3 22:49:34
author: 雯饰太一
header-img: img/post-bg-2015.jpg
tags:
    - 测试
typora-copy-images-to: ../img/post
typora-root-url: ../
---
```

其中每一行对应的值，可以不加双引号。原来的模板中有些添加了引号，有些没有，感觉这样统一下，看着比较舒服。

typora-copy-images-to，这个是图像拷贝的路径，是相对于当前md文件的，使用typora写文章的时候需要这个配置。

typora-root-url，文章对应的根路径，粘贴图片倒指定路径之后，会根据这个跟路径计算出来一个相对路径，然后写在md文件中。

tags，默认生成的是`[]`空内容，如果要换行写，则开头应该是四个空格，而不能使用tab键位。如果是写成`tags: [temp,临时,测试]`也是可以使用的。

所有自动生成的文章都添加temp标签，后续会对每一篇文章添加标签，用来进行分类统计。

在_posts文件夹下建立self子文件夹，可以不上传到git上，只在本地浏览。

## 模板（Hux）

所有的博客都放在`_posts`文件夹下，每一篇文章都有指定的格式，可以在引入[Rake](https://github.com/ruby/rake)工具之后使用命令进行生成：

```
# title值中有中文，生成的文件名称会自动将其去掉，但是写入文件中的信息确实对的
rake post title="Hello 2015" subtitle="Hello World, Hello Blog"
```

个人觉得直接整一个模板，每次写内容的时候都复制一遍应该也没有问题。如果要使用Rake工具，则需要调整Rakefile文件，将原来属于typora编辑器的部分默认加上，如下：

```
puts "Creating new post: #{filename}"
open(filename, 'w') do |post|
post.puts "---"
post.puts "layout: post"
post.puts "title: \"#{title.gsub(/-/,' ')}\""
post.puts "subtitle: \"#{subtitle.gsub(/-/,' ')}\""
post.puts "date: #{date}"
post.puts "author: \"雯饰太一\""
post.puts "header-img: \"img/post-bg-2015.jpg\""
post.puts "tags: []"
post.puts "---"
```

### 头像

需要适用网络路径才可以

### 背景图片

需要有足够的宽度

### 网页icon



## 中文调整

| 关键字 | 页面 |
| ------ | ---- |
| About  | about.html |
| Archive  | archive.html |
| Home  | _includes\nav.html |
| About Me  | _includes\short-about.html |
| Featured Tag  | _includes\featured-tags.html |
| Catalog  | _includes\post.html |
| Powered by  | _includes\footer.html |
| Previous/Next | _layouts\keynote.html |
| FRIENDS | _includes\friends.html |
| Newer Posts/Older Posts | index.html |

其中archive页面直接调整中文之后，文章会无法被检测到，需要调整footer.html，添加如下代码

```txt
"if page.title == 'Archive'" 将其中的Archive调整成为“归档”。
注：“归档”这两个字就是个人汉化之后的文字，是按照这个查找的文件夹。
找到这个段落之后直接复制出来一个段落亦可，这里不能直接将代码写出来，因为footer中的花括号开头的代码会被jekyll自动检测到，并解析，但是会解析失败。
```

## 评论

国外的评论插件[Disqus](http://disqus.com)有试用时间，对于我这种小白不太适用；国内的[Duoshuo](http://duoshuo.com)系统，似乎已经停止维护了；甚至是QQ的邮我也不能用了。

呐，评论这一块的操作直接放弃了。

## 写些什么

- 生活中经历的事情
- 编程所得（c++、python、personal prj···）
- 转载（记录）一些好的文章（知乎、CSDN、博客园）
  - 但是有很多文章是付费的，应该怎么办呢？
- 论文翻译（不能浮于表面，当学一些理论性的内容）
- 一些好的句子（可以持续进行更新）
- 一些工作经历（目前常驻一家公司，似乎也没有什么经历）
- 软件使用的心得（老婆将来一定是设计行业的大佬）
- 一些收集品（怪癖得以释放？？？）
- ···

> 有一个想法，“怎么样可以让博客对外可见，但是github仓库对外不可见”，经过一波冷静分析之后，觉得这无异于自讨苦吃，现在的记录日志含金量不高，谁看或者是谁拥有都是一样的。