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

## 1 图像测试

![image-20231104170741574](/img/post/image-20231104170741574.png)

可以书写相对路径，路径的根是仓库的根。可以和原来博主的模板一样，将图像放在img文件夹下，并且在其中建立post文件夹专门用来存放博客中需要的图像。

但，根据目前了解到的内容，git仓库的容量是有限的，图像会少放一些，后续的博文尽量以文字为主。或者等经济上略微好转，便找一个不错的图床。（不过我依旧觉得相对路径才是最有效的，博客在本地或者git上都可以查看。）

## 2 文章头

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

## 3 模板（Hux）

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

### 3.1 头像

需要适用网络路径才可以

### 3.2 背景图片

需要有足够的宽度

### 3.3 网页icon

## 4 中文调整

| 关键字                     | 页面                           |
| ----------------------- | ---------------------------- |
| About                   | about.html                   |
| Archive                 | archive.html                 |
| Home                    | _includes\nav.html           |
| About Me                | _includes\short-about.html   |
| Featured Tag            | _includes\featured-tags.html |
| Catalog                 | _includes\post.html          |
| Powered by              | _includes\footer.html        |
| Previous/Next           | _layouts\keynote.html        |
| FRIENDS                 | _includes\friends.html       |
| Newer Posts/Older Posts | index.html                   |

其中archive页面直接调整中文之后，文章会无法被检测到，需要调整footer.html，添加如下代码

```txt
"if page.title == 'Archive'" 将其中的Archive调整成为“归档”。
注：“归档”这两个字就是个人汉化之后的文字，是按照这个查找的文件夹。
找到这个段落之后直接复制出来一个段落亦可，这里不能直接将代码写出来，因为footer中的花括号开头的代码会被jekyll自动检测到，并解析，但是会解析失败。
```

## 5 评论

国外的评论插件[Disqus](http://disqus.com)有试用时间，对于我这种小白不太适用；国内的[Duoshuo](http://duoshuo.com)系统，似乎已经停止维护了；甚至是QQ的邮我也不能用了。

呐，评论这一块的操作直接放弃了。

### 5.1 使用Gitment评论

参考链接

- [Hexo中Gitment的配置](https://xoyolucas.github.io/2019/10/21/Hexo%E4%B8%ADgitment%E7%9A%84%E9%85%8D%E7%BD%AE/)
- [给github博客添加评论功能](https://zzqcn.github.io/design/rest/add_comment.html)

代码中的配置

```js
<div id="container-blog"></div>
<link rel="stylesheet" type="text/css" href="//unpkg.com/gitalk/dist/gitalk.css?v=0.0.0">
    <script type="text/javascript" src="//cdn.bootcss.com/blueimp-md5/2.10.0/js/md5.js?v=0.0.0"></script>
<script type="text/javascript" src="//unpkg.com/gitalk/dist/gitalk.min.js?v=0.0.0"></script>
<script>
    var gitalk = new Gitalk({
        clientID: 'c4e8013d948388xxxxxx',
        clientSecret: 'f4fbb60a3660c700432f45b9ff1dca94xxxxxxxx',
        repo: 'blog_gitment',
        owner: 'wenshitaiyixxxx',
        admin: ['wenshitaiyixxxx'],
        id: md5(location.pathname),
        distractionFreeMode: false
    })
gitalk.render('container-blog')
</script>
```

上述代码中的样式略微调整了一下，是参考了另外一个开发者的博客[https://cynickimi.github.io/](https://cynickimi.github.io/)，甚是感谢！！

> 如果要用这段代码的话，其中Gitalk中的内容需要按照自己的需求进行调整，不能直接用我的！！！

## 6 赞赏模块

> [星合の空](https://wu-kan.cn/)的赞赏部分代码做的很好，想要参考一下！
>
> 注：这个和[hux](https://huxpro.github.io)的博客网站似乎规则不太一样，直接将仓库clone到本地之后并不能通过jekyll serve --watch的方式进行预览，hux的博客中每一个界面都会有一个header，直接将星合の空打赏界面的代码粘贴过去后并不能正常使用。

研究中...

界面中的header具体有什么作用？是否可以将其中的侧边栏单独去掉？

## 7 特效
### 7.1 点击特效

```js
<script type="text/javascript">
/* 鼠标特效 */
var a_idx = 0;
jQuery(document).ready(function($) {
    $("body").click(function(e) {
        var a = new Array("❤富强❤","❤民主❤","❤文明❤","❤和谐❤","❤自由❤","❤平等❤","❤公正❤","❤法治❤","❤爱国❤","❤敬业❤","❤诚信❤","❤友善❤");
        var $i = $("<span></span>").text(a[a_idx]);
        a_idx = (a_idx + 1) % a.length;
        var x = e.pageX,
        y = e.pageY;
        $i.css({
            "z-index": 999999999999999999999999999999999999999999999999999999999999999999999,
            "top": y - 20,
            "left": x,
            "position": "absolute",
            "font-weight": "bold",
            "color": "rgb("+~~(255*Math.random())+","+~~(255*Math.random())+","+~~(255*Math.random())+")"
        });
        $("body").append($i);
        $i.animate({
            "top": y - 180,
            "opacity": 0
        },
        1500,
        function() {
            $i.remove();
        });
    });
});
</script>
```

### 7.2 雪花效果

```js

<!-- 背景动画 -->
<script>
(function($){$.fn.snow=function(options){var $flake=$('<div id="flake" />').css({'position':'absolute','top':'-50px'}).html('&#10052;'),documentHeight=$(document).height(),documentWidth=$(document).width(),defaults={minSize:10,maxSize:20,newOn:500,flakeColor:"#FFFFFF"},options=$.extend({},defaults,options);var interval=setInterval(function(){var startPositionLeft=Math.random()*documentWidth-100,startOpacity=0.5+Math.random(),sizeFlake=options.minSize+Math.random()*options.maxSize,endPositionTop=documentHeight-40,endPositionLeft=startPositionLeft-100+Math.random()*200,durationFall=documentHeight*10+Math.random()*5000;$flake.clone().appendTo('body').css({left:startPositionLeft,opacity:startOpacity,'font-size':sizeFlake,color:options.flakeColor}).animate({top:endPositionTop,left:endPositionLeft,opacity:0.2},durationFall,'linear',function(){$(this).remove()});},options.newOn);};})(jQuery);
$.fn.snow({ minSize: 5, maxSize: 50, newOn: 1000, flakeColor: '#aaa' });
</script>
```

使用VPN的时候这个雪花特效请求的js也是可以访问到的

这些效果真是神奇，只需要添加一段脚本就可以有效果

## 8 控件

### 8.1 看板娘

这个人的主页上有：[ 一杯清酒邀明月](https://www.cnblogs.com/ybqjymy/)

使用这个的时候会下载关于看板娘的资源，目前还没能成功的添加上

## 9 统计分析

谷歌的统计分析：footer.html中有使用`ga_track_id`的位置，是在这里进行的设置。

后续还需要添加百度的分析模块

## 10 写些什么

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

## 11 问题记录

### 11.1 数学公式显示

在现有的博客模板中已经可以显示了，但也需要微调，改成如下形式即可：

```js
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    TeX: {
      equationNumbers: {
        autoNumber: "AMS"
      }
    },
    SVG: {
      scale: 90
    },
    tex2jax: {
      inlineMath: [ ['$','$'] ,['\\(','\\)']],
	  skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
      displayMath: [ ['$$','$$'] ,['\\[','\\]']],
      processEscapes: true,
    }
  });
</script>
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS-MML_SVG">
</script>
```

主要是displayMath这一项的内容，添加了一种中括号的形式。这是因为在md文件中如果是行间公式，是通过`$$`包裹的，这种公式转换为html文件的时候会变成`\[\]`的形式。

### 11.2 换行问题

紧凑换行，末尾添加两个空格。常规换行，使用两次回车。可以参考：[2024-01-14-批量调整紧凑换行的格式](2024-01-14-批量调整紧凑换行的格式.md)

### 11.3 分隔符问题

使用`***`的形式即可，具体情况可以参考：[2024-01-13-MD分割线测试（实际上没有什么作用）](2024-01-13-MD分割线测试.md)

### 11.4 与Obsidian配合使用

是否可以有一种方式，技能使用Obsidian的丰富插件功能，还是使用Typora良好的实时渲染显示效果？使用typora进行md文章的编写，在githug.io的网页中出现错误的概率是比较小的，但是使用Obsidian编写md文件的时候会因为太多随意导致文章渲染之后效果比较差。

或者就是在记性文章书写的时候养成一种习惯，这种习惯是符合typora中的书写风格的，比如在标题之后换一行再写新的内容，如果是紧凑的换行就在每一行的最后手动的添加两个空格，这些都是为了保证在github.io中正确的显示。

需要熟悉的熟悉规则具体如下： #todo/完善

### 11.5 竖线被识别为表格

参考链接：

- [测试页面（中文版） | Kubernetes](https://kubernetes.io/zh-cn/docs/test/)
- [jekyll下Markdown的填坑技巧 | Weclome to eipi10](https://eipi10.cn/others/2019/12/07/jekyll-markdown-skills/)

在md文件中使用竖线进行分割的时候，会被识别未表格：
```
| 会被识别未表格
&#124; 这个标识在typora中可以显示，但是在Obsidian中不能正常显示
```

说明：Jekyll 默认使用 Kramdown 作为其 Markdown 引擎，而 Kramdown 在解析 Markdown 时会将竖线（|）视为表格的分隔符。如果你想在 Markdown 中避免竖线被渲染成表格，可以使用 HTML 实体来代替竖线。

#### 11.5.1 是否有方式可对其进行配置？^skip

直接咨询的ChatGPT4，暂时没有方法通过配置文件对其进行调整，但是有必要吗？在本地是不是也OK？我直接在本地查看，不管这些破事应该也OK，反正个人博客网站看的人也比较少。

对！不能内耗了，先保证本地的文件编辑是正常的，后期可以实现一个自动化的脚本，批量的处理博客中的文件，将其调整成为jekyll可以正常渲染的内容，对于竖线这种情况，如果可以不使用那就不使用，如果实在要用，就临时替换成编码形式。

> 只要有原始的博客内容，在未来定然会有更加方便的博客编辑的方式，也不急于一时，可以先积攒一些内容，这个才是重点，疯狂的构建博客，简直就是舍本逐末。

### 11.6 jekyll自动刷新问题

记得开始配置环境的时候，只要是md文件有所改变，对应的网页就会刷新，但是现在md文件调整之后不会有任何的变化，如果是和配置有关的文件发生了调整，则是可以自动刷新的，这是正常的吗？

如同[Jekyll auto reloading](https://stackoverflow.com/questions/15723412/jekyll-auto-reloading)描述的一般，这是正常的吗？没想到想要构建一个博客网站竟然这般麻烦，不如就在本地吧，反正也不会有人看到这些文章！！！

再如[Live reload local Jekyll site in browser on file changes — Amit Merchant — A blog on PHP, JavaScript, and more](https://www.amitmerchant.com/live-reloading-local-jekyll-site-on-file-changes/#:~:text=As%20you%20may%20guess%2C%20all,jekyll%20serve%20command%20like%20so.&text=And%20it%20will%20automatically%20reload,site%20in%20your%20browser%20automatically.)文章中描述的一般，即使使用了`-l`选项依旧不能再md文件调整的时候进行自动的刷新。

等等，我现在是在内耗吗？

个人感觉可能是因为将_posts文件夹设置成了符号链接的原因。对于不是符号链接的哪些文件，刷新是正常的，这可真是恨啊！

对于_posts文件夹，暂时将blog中的作为主题，Obsidian中的作为链接，找到链接被覆盖的原因之后再进行决定如何修改。

## 12 其他测试

### 12.1 本地bat文件

在win上写一个bat文件，快速启动jekyll环境：

```bat
@echo off

rem 启动 Ruby 环境
rem C:\Windows\System32\cmd.exe /E:ON /K D:\Ruby32-x64\bin\ridk enable

rem 启用 Ruby 环境
call D:\Ruby32-x64\bin\ridk enable

rem 切换到 E: 盘
E:

rem 切换到你的 Jekyll 项目目录
cd "E:\Blog\wenshitaiyi.blog"

rem 启动 Jekyll 服务
jekyll serve
```

`C:\Windows\System32\cmd.exe /E:ON /K D:\Ruby32-x64\bin\ridk enable`这个是原来ruby安装之后自带的一个，在bat文件中会阻塞后续的代码执行。

**ChatGPT：**

这是因为 `cmd.exe` 的 `/K` 参数会启动一个新的命令提示符会话，并在执行完 `ridk enable` 命令后保持该命令提示符窗口打开。在这种情况下，脚本会暂停，后续的命令将不会被执行。

原理解释：

- **`cmd.exe /K`**：表示运行指定的命令后不关闭命令提示符窗口，这会中断批处理文件的执行，因为它启动了一个新的命令行环境并停在那里等待用户输入。

为了继续执行批处理文件中的其他命令，你可以使用 `&&` 操作符将命令链接起来，或者使用 `/C` 参数而不是 `/K`。不过，问题是，你需要一个新的命令提示符会话来执行 Ruby 环境命令（`ridk enable`），并在同一个环境中执行后续命令。

解决方案：

为了在同一个环境中执行所有命令，你可以将 `ridk enable` 的命令行部分移到批处理文件本身中，而不通过一个新的命令提示符来启动。这样整个批处理文件会在同一个环境中运行。

### 12.2 增加静态页面



## 13 相关参考链接

- [jekyll中文网站](https://jekyllcn.com/)
- [欢迎 - Jekyll • 简单静态博客网站生成器](https://jekyllcn.com/docs/home/)
- [Markdown 语法的使用 - 孙思锴的博客 | Kay Blog](https://sunsikai.github.io/2020/05/20/Markdown-%E8%AF%AD%E6%B3%95%E7%9A%84%E4%BD%BF%E7%94%A8/)
- [在Jekyll中使用LaTex - Librarius's Blog](https://lloyar.github.io/2018/10/08/mathjax-in-jekyll.html)
- [黄玄的博客 | Hux Blog](https://huangxuan.me/)
- [jekyll下Markdown的填坑技巧 | Weclome to eipi10](https://eipi10.cn/others/2019/12/07/jekyll-markdown-skills/)

[黄玄的博客 | Hux Blog](https://huangxuan.me/)

这里使用了一个|，这里使用了|