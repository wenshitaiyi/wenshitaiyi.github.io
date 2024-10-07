---
layout: post
title: 2024-07-07-Behavior_trees_for_AI_How_they_work
subtitle: 
aliases: 
date: 2024-07-07 16:20:13
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - 翻译
  - 行为树
typora-copy-images-to: ../img/post
typora-root-url: ../
number headings: off
---
> ref:[Behavior trees for AI: How they work](https://www.gamedeveloper.com/programming/behavior-trees-for-ai-how-they-work)
>
> 由于Git仓库容量有限，如果需要参考图像，还是直接看原文吧。



# Behavior trees for AI: How they work  
AI 的行为树：它们的工作原理

An introduction to Behavior Trees, with examples and in-depth descriptions, as well as some tips on creating powerful expressive trees.  
行为树的介绍，包括示例和深入描述，以及创建强大的表达树的一些技巧。

## Introduction 介绍

While there are plenty of behaviour tree tutorials and guides around the internet, when exploring whether they would be right for use in Project Zomboid, I ran into the same problem again and again. Many of the guides I read focused very heavily on the actual code implementations of behaviour trees, or focused purely on the flow of generic contextless nodes without any real applicable examples, with diagrams like so:  
虽然互联网上有很多行为树教程和指南，但在探索它们是否适合在 Project Zomboid 中使用时，我一次又一次地遇到了同样的问题。我阅读的许多指南都非常关注行为树的实际代码实现，或者纯粹关注通用无上下文节点的流程，而没有任何实际适用的示例，其图表如下：

![](assets/Pasted%20image%2020240707162128.png)

While they were invaluable in helping me understand the core principles of Behaviour Trees, I found myself in a situation where despite knowing how a behaviour tree operated, I didn't really have any real-world context as to what sort of nodes I should be creating for the game, or what an actual fully developed behaviour tree would look like.  
虽然它们在帮助我理解行为树的核心原则方面非常宝贵，但我发现自己处于这样一种情况：尽管知道行为树是如何运作的，但我实际上没有任何现实世界的背景，不知道我应该为游戏创建什么样的节点，或者一个实际的完全开发的行为树会是什么样子。

I've spent a ton of time experimenting (for the record since Project Zomboid is in Java I’m using the fantastic JBT - Java Behavior Trees ([http://sourceforge.net/projects/jbt/](http://sourceforge.net/projects/jbt/)) so didn't have to concern myself with the actual code implementation. However there are plenty of tutorials out there focusing on this, as well as implementations in many commonly used game engines.  
我花了大量的时间进行实验（作为记录，因为 Project Zomboid 是用 Java 制作的，所以我使用的是出色的 JBT - Java 行为树 （http://sourceforge.net/projects/jbt/），所以不必关心实际的代码实现。但是，有很多教程专注于此，以及许多常用游戏引擎中的实现。

It's possible some of the more specific decorator node types I detail here are actually native to JBT instead of general behaviour tree concepts, but I've found them to be integral to the way PZ behaviour trees work, so they are worth considering for implementation if your particular behaviour tree does not support them.  
我在这里详述的一些更具体的装饰器节点类型可能是 JBT 的原生类型，而不是一般的行为树概念，但我发现它们是 PZ 行为树工作方式不可或缺的一部分，因此如果您的特定行为树不支持它们，它们值得考虑实现。

I’m not professing to be an expert on the subject, however over the development of the Project Zomboid NPCs I’ve found the results I’ve had to be pretty solid, so thought I’d bash out a few things that if I’d known would have made my first attempts go a lot more smoothly, or at least opened my eyes to what I could accomplish with behaviour trees. I’m not going to dig into the implementation but just give a few abstracted examples that were used in Project Zomboid.  
我并不自称是这方面的专家，但是在僵尸计划NPC的开发过程中，我发现我必须非常可靠的结果，所以我想我应该抨击一些事情，如果我知道的话，我的第一次尝试会更加顺利，或者至少让我睁开眼睛，看看我可以用行为树完成什么。我不打算深入研究实现，而只是给出一些在 Project Zomboid 中使用的抽象示例。

## Basics 基本

So the clue is in the name. Unlike a Finite State Machine, or other systems used for AI programming, a behaviour tree is a tree of hierarchical nodes that control the flow of decision making of an AI entity. At the extents of the tree, the leaves, are the actual commands that control the AI entity, and forming the branches are various types of utility nodes that control the AI’s walk down the trees to reach the sequences of commands best suited to the situation.  
所以线索就在名字里。与有限状态机或其他用于 AI 编程的系统不同，行为树是控制 AI 实体决策流程的分层节点树。在树的范围内，树叶是控制 AI 实体的实际命令，而形成分支的是各种类型的实用程序节点，这些节点控制 AI 沿着树走下去以达到最适合这种情况的命令序列。

The trees can be extremely deep, with nodes calling sub-trees which perform particular functions, allowing for the developer to create libraries of behaviours that can be chained together to provide very convincing AI behaviour. Development is highly iterable, where you can start by forming a basic behaviour, then create new branches to deal with alternate methods of achieving goals, with branches ordered by their desirability, allowing for the AI to have fallback tactics should a particular behaviour fail. This is where they really shine.  
这些树可以非常深，节点调用执行特定功能的子树，允许开发人员创建行为库，这些行为库可以链接在一起，以提供非常令人信服的 AI 行为。开发是高度可迭代的，你可以从形成一个基本行为开始，然后创建新的分支来处理实现目标的替代方法，分支根据它们的可取性进行排序，允许人工智能在特定行为失败时采取后备策略。这是他们真正闪耀的地方。

## Data Driven vs Code Driven  
数据驱动与代码驱动

This distinction has little relevance to this guide, however it should be noted that there are many different possible implementations of behaviour trees. A main distinction is whether the trees are defined externally to the codebase, perhaps in XML or a proprietary format and manipulated with an external editor, or whether the structure of the trees is defined directly in code via nested class instances.  
这种区别与本指南关系不大，但应该注意的是，行为树有许多不同的可能实现。一个主要的区别在于，树是在代码库外部定义的，可能是在XML或专有格式中，并通过外部编辑器进行操作，还是通过嵌套类实例直接在代码中定义树的结构。

JBT uses a strange hybrid of these two, where an editor is provided to allow you to visually construct your behaviour tree, however an exporter command line tool actually generates java code to represent the behaviour trees in the code-base.  
JBT使用这两者的奇怪混合体，其中提供了一个编辑器，允许您直观地构建行为树，但是导出器命令行工具实际上会生成java代码来表示代码库中的行为树。

Whatever the implementation, the leaf nodes, the nodes that actually do the game specific business and control your character or check the character’s situation or surroundings, are something you need to define yourself in code. Be that in the native language or using a scripting language such as Lua or Python. These can then be leveraged by your trees to provide complex behaviours. It is quite how expressive these nodes can be, sometimes operating more as a standard library to manipulate data within the tree itself, than just simply character commands, that really make behaviour trees exciting to me.  
无论实现方式如何，叶节点，即实际执行游戏特定业务并控制角色或检查角色情况或周围环境的节点，都是您需要在代码中定义自己的东西。无论是使用母语还是使用 Lua 或 Python 等脚本语言。然后，您的树可以利用这些来提供复杂的行为。这些节点的表现力非常强，有时更像是一个标准库来操作树本身的数据，而不仅仅是简单的字符命令，这确实让我对行为树感到兴奋。

## Tree Traversal 树遍历

A core aspect of Behavior Trees is that unlike a method within your codebase, a particular node or branch in the tree may take many ticks of the game to complete. In the basic implementation of behaviour trees, the system will traverse down from the root of the tree every single frame, testing each node down the tree to see which is active, rechecking any nodes along the way, until it reaches the currently active node to tick it again.  
行为树的一个核心方面是，与代码库中的方法不同，树中的特定节点或分支可能需要多次游戏才能完成。在行为树的基本实现中，系统将每一帧从树的根部向下遍历，测试树上的每个节点，看看哪个节点处于活动状态，沿途重新检查任何节点，直到它到达当前活动节点以再次勾选它。

This isn’t a very efficient way to do things, especially when the behaviour tree gets deeper as its developed and expanded during development. I’d say its a must that any behaviour tree you implement should store any currently processing nodes so they can be ticked directly within the behaviour tree engine rather than per tick traversal of the entire tree. Thankfully JBT fits into this category.  
这不是一种非常有效的做事方式，尤其是当行为树在开发过程中随着其发展和扩展而变得更深时。我想说的是，您实现的任何行为树都应该存储任何当前处理节点，以便可以直接在行为树引擎中勾选它们，而不是在整个树的每次勾选遍历中。值得庆幸的是，JBT属于这一类。

## Flow 流

A behaviour tree is made up of several types of nodes, however some core functionality is common to any type of node in a behaviour tree. This is that they can return one of three statuses. (Depending on the implementation of the behaviour tree, there may be more than three return statuses, however I've yet to use one of these in practice and they are not pertinent to any introduction to the subject) The three common statuses are as follows:  
行为树由几种类型的节点组成，但某些核心功能对于行为树中任何类型的节点都是通用的。这就是他们可以返回三种状态之一。（根据行为树的实现，可能有三个以上的返回状态，但是我还没有在实践中使用其中一个，它们与该主题的任何介绍无关）三种常见状态如下：

Success 成功  
Failure 失败  
Running 运行

The first two, as their names suggest, inform their parent that their operation was a success or a failure. The third means that success or failure is not yet determined, and the node is still running. The node will be ticked again next time the tree is ticked, at which point it will again have the opportunity to succeed, fail or continue running.  
顾名思义，前两个告诉他们的父母他们的手术是成功还是失败。第三种表示成功或失败尚未确定，节点仍在运行。下次勾选树时，节点将再次被勾选，此时它将再次有机会成功、失败或继续运行。

This functionality is key to the power of behaviour trees, since it allows a node's processing to persist for many ticks of the game. For example a Walk node would offer up the Running status during the time it attempts to calculate a path, as well as the time it takes the character to walk to the specified location. If the pathfinding failed for whatever reason, or some other complication arisen during the walk to stop the character reaching the target location, then the node returns failure to the parent. If at any point the character's current location equals the target location, then it returns success indicating the Walk command executed successfully.  
此功能是行为树功能的关键，因为它允许节点的处理在游戏的许多时刻持续存在。例如，Walk 节点将在尝试计算路径期间提供 Running 状态，以及角色步行到指定位置所需的时间。如果寻路失败，无论出于何种原因，或者在步行过程中出现其他一些复杂情况以阻止角色到达目标位置，则节点会将失败返回给父节点。如果在任何时候角色的当前位置等于目标位置，则返回成功，指示成功执行 Walk 命令。

This means that this node in isolation has a cast iron contract defined for success and failure, and any tree utilizing this node can be assured of the result it received from this node. These statuses then propagate and define the flow of the tree, to provide a sequence of events and different execution paths down the tree to make sure the AI behaves as desired.  
这意味着这个节点孤立地有一个为成功和失败定义的铸铁契约，并且任何使用这个节点的树都可以保证它从这个节点收到的结果。然后，这些状态传播并定义树的流，以提供一系列事件和树下的不同执行路径，以确保 AI 按预期运行。

With this shared functionality in common, there are three main archetypes of behaviour tree node:  
有了这个共同的共享功能，行为树节点有三种主要的原型：

Composite 复合  
Decorator 装饰  
Leaf 叶

![](assets/Pasted%20image%2020240707162305.png)

### Composite 复合

A composite node is a node that can have one or more children. They will process one or more of these children in either a first to last sequence or random order depending on the particular composite node in question, and at some stage will consider their processing complete and pass either success or failure to their parent, often determined by the success or failure of the child nodes. During the time they are processing children, they will continue to return Running to the parent.  
复合节点是可以具有一个或多个子节点的节点。它们将根据所讨论的特定复合节点，以从头到尾的顺序或随机顺序处理其中的一个或多个子节点，并在某个阶段认为它们的处理完成，并将成功或失败传递给它们的父节点，通常由子节点的成功或失败决定。在他们处理子项期间，他们将继续将 Running 返回给父级。

The most commonly used composite node is the Sequence, which simply runs each child in sequence, returning failure at the point any of the children fail, and returning success if every child returned a successful status.  
最常用的复合节点是 Sequence，它只是按顺序运行每个子节点，在任何子节点失败时返回失败，如果每个子节点都返回成功状态，则返回成功。

### Decorator 装饰

A decorator node, like a composite node, can have a child node. Unlike a composite node, they can specifically only have a single child. Their function is either to transform the result they receive from their child node's status, to terminate the child, or repeat processing of the child, depending on the type of decorator node.  
装饰器节点（如复合节点）可以具有子节点。与复合节点不同，它们只能有一个子节点。它们的功能是转换从子节点状态接收的结果，终止子节点，或重复处理子节点，具体取决于装饰器节点的类型。

A commonly used example of a decorator is the Inverter, which will simply invert the result of the child. A child fails and it will return success to its parent, or a child succeeds and it will return failure to the parent.  
装饰器的一个常用例子是逆变器，它只会反转子项的结果。子项失败后，它将把成功归还给其父级，或者子项成功，它将把失败还给父级。

### Leaf 叶

These are the lowest level node type, and are incapable of having any children.  
这些是最低级别的节点类型，并且无法具有任何子节点。

Leafs are however the most powerful of node types, as these will be defined and implemented by your game to do the game specific or character specific tests or actions required to make your tree actually do useful stuff.  
然而，叶子是最强大的节点类型，因为这些将由您的游戏定义和实现，以执行游戏特定或角色特定的测试或操作，以使您的树真正做有用的事情。

An example of this, as used above, would be Walk. A Walk leaf node would make a character walk to a specific point on the map, and return success or failure depending on the result.  
如上所述，这方面的一个例子是 Walk。Walk 叶子节点将使角色走到地图上的特定点，并根据结果返回成功或失败。

Since you can define what leaf nodes are yourself (often with very minimal code), they can be very expressive when layered on top of composite and decorators, and allow for you to make pretty powerful behavior trees capable of quite complicated layered and intelligently prioritized behaviour.  
由于您可以自己定义叶节点（通常使用非常少的代码），因此当它们叠加在复合和装饰器之上时，它们可以非常富有表现力，并允许您创建非常强大的行为树，能够进行相当复杂的分层和智能优先级行为。

In an analogy of game code, think of composites and decorators as functions, if statements and while loops and other language constructs for defining flow of your code, and leaf nodes as game specific function calls that actually do the business for your AI characters or test their state or situation.  
在游戏代码的类比中，将复合和装饰器视为函数，if 语句和 while 循环以及其他用于定义代码流的语言结构，将叶节点视为游戏特定的函数调用，这些函数调用实际上为您的 AI 角色执行业务或测试他们的状态或情况。

These nodes can be defined with parameters. For example the Walk leaf node may have a coordinate for the character to walk to.  
这些节点可以使用参数进行定义。例如，“行走”叶节点可能具有角色要步行到的坐标。

These parameters can be taken from variables stored within the context of the AI character processing the tree. So for example a location to walk to could be determined by a 'GetSafeLocation' node, stored in a variable, and then a 'Walk' node could use that variable stored in the context to define the destination. It's through using a shared context between nodes for storing and altering of arbitrary persistent data during processing of a tree that makes behaviour trees immensely powerful.  
这些参数可以从存储在处理树的 AI 字符上下文中的变量中获取。因此，例如，步行到的位置可以由存储在变量中的“GetSafeLocation”节点确定，然后“步行”节点可以使用存储在上下文中的该变量来定义目的地。它通过在节点之间使用共享上下文来存储和更改树的处理过程中的任意持久性数据，这使得行为树变得非常强大。

Another integral type of Leaf node is one that calls another behaviour tree, passing the existing tree's data context through to the called tree.  
Leaf 节点的另一种积分类型是调用另一个行为树，将现有树的数据上下文传递到被调用树。

These are key as they allow you to modularise the trees heavily to create behaviour trees that can be reused in countless places, perhaps using a specific variable name within the context to operate on. For example a 'Break into Building' behaviour may expect a 'targetBuilding' variable with which to operate on, so parent trees can set this variable in the context, then call the sub-tree via a sub-tree Leaf node.  
这些是关键，因为它们允许您大量模块化树以创建可以在无数地方重用的行为树，也许在上下文中使用特定的变量名称进行操作。例如，“闯入建筑物”行为可能需要一个“targetBuilding”变量来操作，因此父树可以在上下文中设置此变量，然后通过子树 Leaf 节点调用子树。

## Composite Nodes 复合节点

Here we will talk about the most common composite nodes found within behaviour trees. There are others, but we will cover the basics that should see you on your way to writing some pretty complex behaviour trees in their own right.  
在这里，我们将讨论行为树中最常见的复合节点。还有其他的，但我们将介绍一些基础知识，这些基础知识应该会让你在编写一些非常复杂的行为树的过程中发挥作用。

### Sequences 序列

The simplest composite node found within behaviour trees, their name says it all. A sequence will visit each child in order, starting with the first, and when that succeeds will call the second, and so on down the list of children. If any child fails it will immediately return failure to the parent. If the last child in the sequence succeeds, then the sequence will return success to its parent.  
在行为树中发现的最简单的复合节点，它们的名字说明了一切。一个序列将按顺序访问每个孩子，从第一个开始，当成功时将调用第二个孩子，依此类推。如果任何子项失败，它将立即将失败返回给父级。如果序列中的最后一个子项成功，则该序列将成功返回给其父级。

It's important to make clear that the node types in behaviour trees have quite a wide range of applications. The most obvious usage of sequences is to define a sequence of tasks that must be completed in entirety, and where failure of one means further processing of that sequence of tasks becomes redundant. For example:  
需要明确的是，行为树中的节点类型具有相当广泛的应用范围。序列最明显的用法是定义一个必须完整完成的任务序列，如果一个任务失败，则意味着对该任务序列的进一步处理变得多余。例如：

![](assets/Pasted%20image%2020240707162336.png)

This sequence, as is probably clear, will make the given character walk through a door, closing it behind them. In truth, these nodes would likely be more abstracted and use parameters in a production environment. Walk (location), Open (openable), Walk (location), Close (openable)  
这个序列，可能很清楚，会让给定的角色穿过一扇门，在他们身后关上它。事实上，这些节点可能会更加抽象，并在生产环境中使用参数。步行（位置）、打开（可打开）、步行（位置）、关闭（可打开）

The processing order is thus:  
处理顺序如下：

Sequence -> Walk to Door (success) -> Sequence (running) -> Open Door (success) -> Sequence (running) -> Walk through Door (success) -> Sequence (running) -> Close Door (success) -> Sequence (success) -> at which point the sequence returns success to its own parent.  
Sequence -> Walk to Door（成功） -> Sequence（运行） -> Open Door（成功） -> Sequence（运行） -> Walk through Door（成功） -> Sequence（运行） -> Close Door（成功） -> Sequence（成功） ->此时，序列将成功返回给其自己的父级。

If a character fails to walk to the door, perhaps because the way is blocked, then it is no longer relevant to try opening the door, or walking through it.  The sequence returns failure at the moment the walk fails, and the parent of the sequence can then deal with the failure gracefully.  
如果一个角色没有走到门口，也许是因为路被挡住了，那么尝试打开门或穿过门就不再重要了。 序列在遍历失败的那一刻返回失败，然后序列的父级可以优雅地处理失败。

The fact that sequences naturally lend themselves to sequences of character actions, and since AI behaviour trees tend to suggest this is their only use, it may not be clear that there are several different ways to leverage sequences beyond making a character do a sequential list of 'things'. Consider this:  
事实上，序列自然而然地适合于角色动作的序列，而且由于 AI 行为树倾向于表明这是它们的唯一用途，因此可能不清楚除了让角色做一系列“事情”之外，还有几种不同的方法来利用序列。考虑一下：

![](assets/Pasted%20image%2020240707162346.png)

In the above example, we have not a list of actions but a list of tests. The child nodes check if the character is hungry, if they have food on their person, if they are in a safe location, and only if all of these return success to the sequence parent, will the character then eat food. Using sequences like this allow you to test one or more conditions before carrying out an action. Analogous to if statements in code, and to an AND gate in circuitry. Since all children need to succeed, and those children could be any combination of composite, decorator or leaf nodes, it allows for pretty powerful conditional checking within your AI brain.  
在上面的示例中，我们没有操作列表，而是测试列表。子节点检查角色是否饿了，他们身上是否有食物，他们是否在安全的位置，只有当所有这些将成功返回给序列父节点时，角色才会吃食物。使用这样的序列，可以在执行操作之前测试一个或多个条件。类似于代码中的if语句，以及电路中的AND门。由于所有孩子都需要成功，而这些孩子可以是复合节点、装饰节点或叶节点的任意组合，因此它允许在 AI 大脑中进行非常强大的条件检查。

Consider for example the Inverter decorator mentioned in the above section:  
例如，考虑上一节中提到的逆变器装饰器：

![](assets/Pasted%20image%2020240707162358.png)

Functionally identical to the previous example, here we show how you can use inverters to negate any test and therefore give you a NOT gate. This means you can drastically cut the amount of nodes you will need for testing the conditions of your character or game world.  
在功能上与前面的示例相同，在这里我们展示了如何使用逆变器来否定任何测试，从而为您提供一个 NOT 门。这意味着您可以大幅减少测试角色或游戏世界条件所需的节点数量。

### Selector 选择器

Selectors are the yin to the sequence's yang. Where a sequence is an AND, requiring all children to succeed to return a success, a selector will return a success if any of its children succeed and not process any further children. It will process the first child, and if it fails will process the second, and if that fails will process the third, until a success is reached, at which point it will instantly return success. It will fail if all children fail. This means a selector is analagous with an OR gate, and as a conditional statement can be used to check multiple conditions to see if any one of them is true.  
选择器是序列的阴阳。如果序列是 AND，要求所有子级成功才能返回成功，则如果其任何子级成功，则选择器将返回成功，并且不处理任何其他子级。它将处理第一个子项，如果失败，它将处理第二个子项，如果失败，它将处理第三个子项，直到达到成功，此时它将立即返回成功。如果所有子项都失败，它将失败。这意味着选择器与 OR 门类似，并且作为条件语句可用于检查多个条件，以查看其中任何一个是否为真。

Their main power comes from their ability to represent multiple different courses of action, in order of priority from most favorable to least favorable, and to return success if it managed to succeed at any course of action. The implications of this are huge, and you can very quickly develop pretty sophisticated AI behaviours through the use of selectors.  
它们的主要力量来自它们代表多种不同行动方案的能力，按优先级从最有利到最不利的顺序排列，如果在任何行动方案中取得成功，则返回成功。这样做的影响是巨大的，你可以通过使用选择器非常快速地开发相当复杂的人工智能行为。

Let's revisit our door sequence example from earlier, adding a potential complication to it and a selector to solve it.  
让我们重新审视前面的门序列示例，为它添加一个潜在的复杂性和一个解决它的选择器。

![](assets/Pasted%20image%2020240707162408.png)

Yes, here we can deal with locked doors intelligently, with the use of only a handful of new nodes.  
是的，在这里，我们可以智能地处理锁定的门，只需使用少数几个新节点。

So what happens when this selector is processed?  
那么，当处理这个选择器时会发生什么？

First, it will process the Open Door node. The most preferable cause of action is to simply open the door. No messing. If that succeeds then the selector succeeds, knowing it was a job well done. There's no further need to explore any other child nodes of that selector.  
首先，它将处理 Open Door 节点。最可取的行动理由是简单地打开门。没有乱七八糟。如果成功了，那么选择器就成功了，因为知道这是一项出色的工作。无需进一步探索该选择器的任何其他子节点。

If, however, the door fails to open because some sod has locked it, then the open door node will fail, passing failure to the parent selector. At this point the selector will try the second node, or the second preferable cause of action, which is to attempt to unlock the door.  
但是，如果门因为某些草皮锁住了门而无法打开，则打开的门节点将失败，并将故障传递给父选择器。此时，选择器将尝试第二个节点，或第二个首选操作原因，即尝试解锁门。

Here we've created another sequence (that must be completed in entirety to pass success back to the selector) where we first unlock the door, then attempt to open it.  
在这里，我们创建了另一个序列（必须完整完成才能将成功传递回选择器），我们首先解锁门，然后尝试打开它。

If either step of unlocking the door fails (perhaps the AI doesn't have the key, or the required lockpicking skill, or perhaps they managed to pick the lock, but found the door was nailed shut when attempting to open it?) then it will return failure to the selector, which will then try the third course of action, smashing the door off its hinges!  
如果开门的任一步都失败了（也许人工智能没有钥匙，或者没有所需的开锁技能，或者他们设法撬开了锁，但在试图打开门时发现门被钉住了？），那么它会将失败返回给选择器，然后选择器将尝试第三种操作方案， 把门从铰链上砸下来！

If the character is not strong enough, then perhaps this fails. In this case there are no more courses of action left, and the the selector will fail, and this will in turn cause the selector's parent sequence to fail, abandoning the attempt to walk through the door.  
如果角色不够强大，那么也许这会失败。在这种情况下，没有更多的操作过程，选择器将失败，这反过来又会导致选择器的父序列失败，放弃穿过门的尝试。

To take this a step further, perhaps there is a selector above that which will then choose another course of action based on this sequence's failure?  
为了更进一步，也许上面有一个选择器，它会根据这个序列的失败选择另一种行动方案？

![](assets/Pasted%20image%2020240707162419.png)

Here we've expanded the tree with a topmost selector. On the left (most preferable side) we enter through the door, and if that fails we instead try to enter through the window. In truth the actual implementation would likely not look this way and its a bit of a simplification on what we did on Project Zomboid, but it illustrates the point. We’ll get to a more generic and usable implementation later.  
在这里，我们用最上面的选择器扩展了树。在左边（最可取的一侧），我们从门进入，如果失败，我们就会尝试从窗户进入。事实上，实际的实现可能不是这样，它比我们在 Project Zomboid 上所做的有点简化，但它说明了这一点。我们稍后将介绍一个更通用和可用的实现。

In short, we have here an ‘Enter Building’ behaviour that you can rely on to either get inside the building in question, or to inform its parent that it failed to. Perhaps there are no windows? In this case the topmost selector will fail, and perhaps a parent selector will tell the AI to head to another building?  
简而言之，我们这里有一个“进入建筑物”行为，您可以依靠它进入有问题的建筑物，或者通知其父级它未能进入。也许没有窗户？在这种情况下，最上面的选择器将失败，也许父选择器会告诉 AI 前往另一栋建筑？

A key factor in behaviour trees that has simplified AI development a huge deal for myself over previous attempts is that failure is no longer a critical full stop on whatever I’m trying to do (uhoh, the pathfind failed, WHAT NOW?), but just a natural and expected part of the decision making process that fits naturally in the paradigm of the AI system.  
行为树的一个关键因素是，与以前的尝试相比，对我自己来说，简化了人工智能开发的一个关键因素是，失败不再是我试图做的任何事情的关键句号（呃，寻路失败了，现在怎么办？），而只是决策过程中自然而然的、预期的部分，自然而然地适合人工智能系统的范式。

You can layer failsafes and alternate courses of action for every possible situation. An example with Project Zomboid would be the EnsureItemInInventory behaviour.  
您可以针对每种可能的情况分层故障保护和替代行动方案。Project Zomboid 的一个示例是 EnsureItemInInventory 行为。

This behaviour takes in an inventory item type, and uses a selector to determine from several courses of action to ensure an item is in the NPC's inventory, including recursive calls to the same behaviour with different item parameters.  
此行为采用物品栏物品类型，并使用选择器从多个操作方案中确定物品，以确保物品在 NPC 的物品栏中，包括使用不同物品参数递归调用相同行为。

First it'll check if the item is already in the character's main top level inventory. This is the ideal situation as nothing needs to be done. If it is, then the selector succeeds and thus the entire behaviour succeeds. EnsureItemInInventory has succeeded, and the item is there for use.  
首先，它会检查该物品是否已经在角色的主要顶级库存中。这是理想的情况，因为不需要做任何事情。如果是，则选择器成功，因此整个行为成功。EnsureItemInInventory 已成功，并且该物料可供使用。

If the item is not in the character's inventory, then they will check the contents of any bags or backpacks the character is carrying. If the item is found, then they will transfer the item from the bag into his top level inventory. This will then succeed, as the success criteria is met.  
如果该物品不在角色的物品栏中，那么他们将检查角色携带的任何包或背包的内容。如果找到该物品，那么他们会将该物品从袋子转移到他的顶级库存中。当满足成功标准时，这将成功。

If THIS fails, then a third branch of the selector will determine of the item is located in the building the character is currently residing in. If it is, then the character will travel to the location of the container holding the item and take it from the container. Again the criteria is met, so success!  
如果 THIS 失败，则选择器的第三个分支将确定该物品位于角色当前居住的建筑物中。如果是，那么角色将前往盛放物品的容器的位置并将其从容器中取出。再次满足标准，所以成功！

If THIS fails, then there is one more trick up the NPCs sleeve. It will then iterate a list of crafting recipes that result in the item they desire, and for each of these recipes it will iterate through each ingredient item, and will recursively call the EnsureItemInInventory behaviour for each of those items in turn. If each of these succeeds, then we know for a fact that the NPC now carries every ingredient required to craft their desired item. The character will then craft the item from those ingredients, before returning success as the criteria of having the item is met.  
如果这失败了，那么 NPC 袖子里还有一个技巧。然后，它将循环访问生成所需物品的制作配方列表，对于每个配方，它将遍历每个成分物品，并依次递归调用每个物品的 EnsureItemInInventory 行为。如果这些都成功了，那么我们就知道一个事实，即 NPC 现在携带了制作他们想要的物品所需的所有成分。然后，角色将用这些成分制作物品，然后在满足拥有物品的标准后返回成功。

If THIS fails, then the EnsureItemInInventory behaviour will fail, with no more fallbacks, and the NPC will just add that item to a list of desired items to look out for during looting missions and live without the item.  
如果 THIS 失败，则 EnsureItemInInventory 行为将失败，不再有回退，NPC 只会将该物品添加到在掠夺任务期间需要注意的所需物品列表中，并且没有该物品。

The result of this is that the NPC is suddenly capable of crafting any item in the game they desire if they have the ingredients required, or those ingredients can be obtained from the building.  
这样做的结果是，如果 NPC 拥有所需的材料，或者这些材料可以从建筑物中获得，那么他们突然能够在游戏中制作他们想要的任何物品。

Due to the recursive nature of the behaviour, if they don't have the ingredients themselves, then they will even attempt to craft them from even baser level ingredients, hunting the building if necessary, crafting multiple stages of items to be able to craft the item they actually need.  
由于行为的递归性质，如果他们自己没有成分，那么他们甚至会尝试用更基本的成分来制作它们，必要时狩猎建筑物，制作多个阶段的物品，以便能够制作他们真正需要的物品。


[Zomboid NPCs - YouTube](https://youtu.be/k-C6ooTbUO4)

Suddenly we have a quite complicated and impressive looking AI behaviour that actually boils down to relatively simple nodes layered on top of each other. The EnsureItemInInventory behaviour can then be used liberally throughout many other trees, whenever we need an NPC to ensure they have an item in their inventory.  
突然间，我们有了一个相当复杂和令人印象深刻的人工智能行为，它实际上归结为相对简单的节点层叠在一起。然后，EnsureItemInInventory 行为可以在许多其他树中自由使用，每当我们需要 NPC 来确保他们的库存中有物品时。

I'm sure at some point during development we'll continue this further with another fallback, and allow the NPCs to actually go out specifically in search of items they critically desire, choosing a looting target that has the highest chance of containing that item.  
我敢肯定，在开发过程中的某个时候，我们会通过另一个后备方案继续这样做，并允许 NPC 实际上专门出去寻找他们非常渴望的物品，选择一个最有可能包含该物品的掠夺目标。

Another failsafe that could be higher in the priority list may be to consider other items which may accomplish the same goal as the selected item. If one day we finally code in support for makeshift tools, then looking for less effective alternatives and hammering a nail in with a rock may trump sneaking across town into a zombie infested hardware store.  
另一个在优先级列表中可能更高的故障保护可能是考虑可能实现与所选项目相同目标的其他项目。如果有一天，我们最终编写代码来支持临时工具，那么寻找效果较差的替代品并用石头钉钉子可能比偷偷溜过城镇进入僵尸出没的五金店要好。

Due to the ease of extending the trees during development, its easy to create a simple behaviour that 'does the job', and then iteratively improve that NPC behaviour with extra branches via a selector to cater for more solid failsafes and fallbacks to reduce the likelihood of the behaviour failing. The crafting fallback was added much later down the line, and just goes to further equip NPCs with behaviours to further aid them in achieving their goals.  
由于在开发过程中扩展树很容易，因此很容易创建一个“完成工作”的简单行为，然后通过选择器使用额外的分支迭代改进该 NPC 行为，以满足更可靠的故障保护和后备，以降低行为失败的可能性。制作后备是在很久以后添加的，只是为了进一步装备 NPC 的行为，以进一步帮助他们实现目标。

Furthermore if prioritized carefully, these fallbacks, despite being essentially scripted behaviours, bestow the appearance of intelligent problem solving and natural decision making to the AI character.  
此外，如果仔细确定优先级，这些后备措施尽管本质上是脚本化的行为，但会给 AI 角色带来智能解决问题和自然决策的外观。

### Random Selectors / Sequences  
随机选择器/序列

I’m not going to dwell on these, as their behaviour will be obvious given the previous sections. Random sequences/selectors work identically to their namesakes, except the actual order the child nodes are processed is determined randomly. These can be used to add more unpredictability to an AI character in cases where there isn’t a clear preferable order of execution of possible courses of action.  
我不打算详述这些，因为鉴于前面的部分，它们的行为是显而易见的。随机序列/选择器的工作方式与其同名相同，只是子节点的实际处理顺序是随机确定的。这些可用于在可能的行动方案没有明确首选的执行顺序的情况下为 AI 角色增加更多的不可预测性。

## Decorator Nodes 装饰器节点

### Inverter 逆变器

We’ve already covered this one. Simply put they will invert or negate the result of their child node. Success becomes failure, and failure becomes success. They are most often used in conditional tests.  
我们已经介绍了这个问题。简单地说，它们将反转或否定其子节点的结果。成功就成了失败，失败就成了成功。它们最常用于条件测试。

### Succeeder 成功者

A succeeder will always return success, irrespective of what the child node actually returned. These are useful in cases where you want to process a branch of a tree where a failure is expected or anticipated, but you don’t want to abandon processing of a sequence that branch sits on. The opposite of this type of node is not required, as an inverter will turn a succeeder into a ‘failer’ if a failure is required for the parent.  
成功者将始终返回成功，而不管子节点实际返回什么。如果要处理预期或预期会发生故障的树分支，但又不想放弃处理该分支所在的序列，则这些方法非常有用。这种类型的节点的反面不是必需的，因为如果父节点需要失败，逆变器会将成功者变成“失败者”。

### Repeater 中继 器

A repeater will reprocess its child node each time its child returns a result. These are often used at the very base of the tree, to make the tree to run continuously. Repeaters may optionally run their children a set number of times before returning to their parent.  
每次其子节点返回结果时，中继器都会重新处理其子节点。这些通常用于树的最底部，以使树连续运行。中继器可以选择在返回给父母之前运行其子项的设定次数。

### Repeat Until Fail 重复直到失败

Like a repeater, these decorators will continue to reprocess their child. That is until the child finally returns a failure, at which point the repeater will return success to its parent.  
就像中继器一样，这些装饰者将继续重新处理他们的孩子。直到子项最终返回失败，此时中继器将成功返回给其父级。

## Data Context 数据上下文

The specifics of this are down to the actual implementation of the behaviour tree, the programming language used, and all manner of other things, so we’ll keep this all rather abstract and conceptual.  
具体细节取决于行为树的实际实现、使用的编程语言以及各种其他方面，因此我们将保持这些相当抽象和概念化。

When a behaviour tree is called on an AI entity, a data context is also created which acts as a storage for arbitrary variables that are interpreted and altered by the nodes (using string/object pair in a C# Dictionary or java HashMap, probably a C++ string/void* STL map, though its a long time since I've used C++ so there are probably better ways to handle this)  
当在 AI 实体上调用行为树时，还会创建一个数据上下文，该上下文充当由节点解释和更改的任意变量的存储（使用 C# 字典或 java HashMap 中的字符串/对象对，可能是 C++ 字符串/void* STL 映射，尽管我已经很长时间没有使用 C++ 了，所以可能有更好的方法来处理这个问题）

Nodes will be able to read or write into variables to provide nodes processed later with contextual data and allow the behaviour tree to act as a cohesive unit. As soon as you start exploiting this heavily, the flexibility and scope of behaviour trees becomes very impressive, and the true power at your fingertips becomes apparent. We’ll get to this in a while when we revisit our doors and windows behaviour.  
节点将能够读取或写入变量，为稍后处理的节点提供上下文数据，并允许行为树充当一个有凝聚力的单元。一旦你开始大量利用这一点，行为树的灵活性和范围就会变得非常令人印象深刻，而触手可及的真正力量就会变得显而易见。当我们重新审视我们的门窗行为时，我们会在一段时间内谈到这一点。

## Defining Leaf Nodes 定义叶节点

Again, the specifics of this are down to the actual implementation of the behaviour tree. In order to provide functionality to leaf nodes, to allow for game specific functionality to be added into behaviour trees, most systems have two functions that will need to be implemented.  
同样，这其中的细节取决于行为树的实际实现。为了向叶节点提供功能，允许将游戏特定的功能添加到行为树中，大多数系统都需要实现两个功能。

init - Called the first time a node is visited by its parent during its parents execution. For example a sequence will call this when its the node’s turn to be processed. It will not be called again until the next time the parent node is fired after the parent has finished processing and returned a result to its parent. This function is used to initialise the node and start the action the node represents. Using our walk example, it will retrieve the parameters and perhaps initiate the pathfinding job.  
init - 在父节点执行期间，节点的父节点首次访问节点时调用。例如，当轮到节点进行处理时，序列将调用此函数。在父节点完成处理并将结果返回给其父节点后，下次触发父节点时，才会再次调用它。此函数用于初始化节点并启动节点所表示的操作。使用我们的漫游示例，它将检索参数并可能启动寻路作业。

process - This is called every tick of the behaviour tree while the node is processing. If this function returns Success or Failure, then its processing will end and the result passed to its parent. If it returns Running it will be reprocessed next tick, and again and again until it returns a Success or Failure. In the Walk example, it will return Running until the pathfinding either succeeds or fails.  
process - 在节点处理时，这称为行为树的每个刻度。如果此函数返回 Success 或 Failure，则其处理将结束，并将结果传递给其父函数。如果它返回 Running，它将在下一个 tick 中重新处理，并一次又一次地重新处理，直到它返回 Success 或 Failure。在 Walk 示例中，它将返回 Running，直到寻路成功或失败。

Nodes can have properties associated with them, that may be explicitly passed literal parameters, or references to variables within the data context of the AI entity being controlled.  
节点可以具有与之关联的属性，这些属性可以显式传递文本参数，也可以引用所控制的 AI 实体的数据上下文中的变量。

I’m not going to go into the specifics of implementation, as this is not only language dependent but also behaviour tree implementation dependent, but the concept of parameters and storage of arbitrary data within the behaviour tree instance are fairly universal.  
我不打算讨论实现的细节，因为这不仅依赖于语言，还依赖于行为树实现，但是参数的概念和行为树实例中任意数据的存储是相当普遍的。

So for example, we may describe a Walk node as such:  
因此，例如，我们可以这样描述一个 Walk 节点：

Walk (character, destination)  
步行（角色、目的地）

- success:  Reached destination  
- success：到达目的地  
- failure:    Failed to reach destination  
- failure：无法到达目的地  
- running: En route - 跑步：途中

In this case Walk has two parameters, the character and the destination. While it may seem natural to always assume that the character who is running the AI behaviour is the subject of a node and therefore would not need to be passed explicitly as a parameter, it’s best not to make this assumption, despite ‘Walk’ being a pretty safe bet. As too many times, particularly on conditional nodes,  I’ve found myself having to recode nodes to cater for testing another characters state or interacting with them in some way. It’s always best to go the extra mile and pass the character the command applies to even if you’re fairly sure that only the AI running the behaviour would require it.  
在本例中，Walk 有两个参数，即字符和目的地。虽然总是假设运行 AI 行为的角色是节点的主题，因此不需要作为参数显式传递，但最好不要做出这种假设，尽管“步行”是一个非常安全的赌注。很多时候，特别是在条件节点上，我发现自己不得不重新编码节点以满足测试另一个字符状态或以某种方式与它们交互。最好加倍努力，传递命令所适用的字符，即使你相当确定只有运行该行为的 AI 才会需要它。

The passed location, as stated earlier, could be inputted manually with X, Y, Z coordinates. But more likely, the location would be stored in the context as a variable by another node, obtaining the location of some game object, or building, or perhaps calculating a safe place in cover in the NPCs vicinity.  
如前所述，可以通过 X、Y、Z 坐标手动输入传递的位置。但更有可能的是，该位置将由另一个节点作为变量存储在上下文中，获取某些游戏对象或建筑物的位置，或者计算 NPC 附近的安全掩体位置。

## Stacks 栈

When first looking into behaviour trees, its natural to constrain the scope of the nodes they use to character actions, or conditional tests about the character or their environment. With this limitation it’s sometimes difficult to see how powerful behaviour trees are.  
当第一次研究行为树时，很自然地会将它们使用的节点范围限制为角色动作，或关于角色或其环境的条件测试。由于这种限制，有时很难看出行为树有多强大。

It’s when it occurred to me to implement stack operations as nodes that their utility really became apparent to me. So I added the following node implementations to the game:  
当我想到将堆栈操作作为节点实现时，它们的效用对我来说才真正显现出来。因此，我在游戏中添加了以下节点实现：

PushToStack(item, stackVar)  
PushToStack（项目， stackVar）  
PopFromStack(stack, itemVar)  
PopFromStack（堆栈， itemVar）  
IsEmpty(stack) IsEmpty（堆栈）

That’s it, just these three nodes. All they needed was init/process functions implemented to create and modify a standard library stack object with just a few lines of code, and they open up a whole host of possibilities.  
就是这样，只有这三个节点。他们所需要的只是实现 init/process 函数，只需几行代码即可创建和修改标准库堆栈对象，并且它们开辟了大量可能性。

For example PushToStack creates a new stack if one doesn’t exist, and stores it in the passed variable name, and then pushes ‘item’ object onto it.  
例如，如果不存在新堆栈，则 PushToStack 会创建一个新堆栈，并将其存储在传递的变量名称中，然后将“item”对象推送到该堆栈上。

Similarly pop pops an item off the stack, and stores it in the itemVar variable, failing if the stack is already empty, and IsEmpty checks if the stack passed is empty and returns success if it is, and failure if its not.  
同样，pop 会从堆栈中弹出一个项目，并将其存储在 itemVar 变量中，如果堆栈已经为空，则失败，IsEmpty 检查传递的堆栈是否为空，如果为空，则返回 success，如果不是，则返回 failure。

With these nodes, we now have the capacity to iterate through a stack of objects like this:  
有了这些节点，我们现在有能力遍历一堆对象，如下所示：

![](assets/Pasted%20image%2020240707162532.png)

Using an Until Fail repeater, we can repeatedly pop an item from the stack and operate on it, until the point the stack is empty, at which point PopFromStack will return a fail and exit out of the Until Fail repeater.  
使用 Until Fail 中继器，我们可以从堆栈中反复弹出一个项目并对其进行操作，直到堆栈为空，此时 PopFromStack 将返回失败并退出 Until Fail 中继器。

Next, a couple of other vital utility nodes that I use regularly:  
接下来，我经常使用的其他几个重要的实用程序节点：

SetVariable(varName, object)  
SetVariable（varName， 对象）  
IsNull(object) IsNull（对象）

These allow us to set arbitrary variables throughout the behaviour tree in circumstances where the composites and decorators don’t allow us enough granularity to get information up the tree we require. We’ll hit a situation like this in a moment, though I don’t doubt there’s a way to organize it so it’s not required.  
这些允许我们在整个行为树中设置任意变量，在这种情况下，复合和装饰器不允许我们有足够的粒度来获取我们需要的信息。我们一会儿就会遇到这样的情况，尽管我不怀疑有一种方法可以组织它，所以它不是必需的。

Now supposing we added a node called GetDoorStackFromBuilding, where you passed a building object and it retrieved a list of exterior door objects in that building, newing and filling a Stack with the objects and setting the target variable. What could we do then using the things we’ve detailed above?  
现在假设我们添加了一个名为 GetDoorStackFromBuilding 的节点，您在其中传递了一个建筑对象，它检索了该建筑中外门对象的列表，用对象更新并填充堆栈并设置目标变量。那么，使用上面详述的内容，我们可以做些什么呢？

![](assets/Pasted%20image%2020240707162542.png)

Eek. This has gotten a little more complicated, and at first glance it may seem a bit difficult to ascertain what’s going on, but like any language eventually it becomes easier to read at a glance, and what you lose in readability you gain in flexibility.  
哎呀。这变得有点复杂，乍一看似乎有点难以确定发生了什么，但就像任何语言一样，最终它变得更容易一目了然，你在可读性方面失去了什么，你在灵活性上获得了什么。

So what does this do? Well it may be a little bit of a head mangler at first, but once you become familiar with the way the nodes operate and how the successes and failures transverse the tree, it becomes a lot easier to visualise. If necessary I may expand this section to show the walk through the tree, if my description proves insufficient.  
那么这有什么作用呢？好吧，一开始它可能有点头疼，但是一旦你熟悉了节点的运作方式以及成功和失败是如何横贯树的，它就会变得更容易可视化。如有必要，如果我的描述证明不够充分，我可能会扩展这一部分以显示穿过树的路径。

In short, it is a behaviour that will retrieve and then try to enter every single door into a building, and return success if the character succeeded in getting in any of the doors, and it will return failure if they did not.  
简而言之，这是一种行为，它将检索并尝试进入建筑物的每一扇门，如果角色成功进入任何一扇门，则返回成功，如果他们没有进入，它将返回失败。

First up it grabs a stack containing every doorway into the building. Then it calls the Until Fail repeater node which will continue to reprocess its child until its child returns a failure.  
首先，它抓取一堆包含进入建筑物的每个门口。然后，它调用 Until Fail 中继器节点，该节点将继续重新处理其子节点，直到其子节点返回失败。

That child, a sequence, will first pop a door from the stack, storing it in the door variable.  
这个子级，一个序列，将首先从堆栈中弹出一扇门，并将其存储在门变量中。

If the stack is empty because there are no doors, then this node will fail and break out of the Until Fail repeater with a success (Until Fail always succeeds), to continue the parent sequence, where we have an inverted IsNull check on ‘usedDoor’. This will fail if the usedDoor is null (which it will be, since it never got chance to set that variable), and this will cause the entire behaviour to fail.  
如果堆栈是空的，因为没有门，那么这个节点将失败，并以成功（直到失败总是成功）突破 Until Fail 中继器，继续父序列，我们在其中对 'usedDoor' 进行反转的 IsNull 检查。如果 usedDoor 为 null（这将是，因为它从未有机会设置该变量），这将失败，这将导致整个行为失败。

If the stack does manage to grab a door, it then calls another sequence (with an inverter) which will attempt to walk to the door, open it and walk through it.  
如果堆栈确实设法抓住了一扇门，它就会调用另一个序列（带有逆变器），该序列将尝试走到门前，打开门并穿过它。

If the NPC fails to get through the door by any means available to him (the door is locked, and the NPC is too weak to break it down), then the selector will fail, and will return fail to the parent, which is the Inverter, which inverts the failure into a success, which means it doesn't escape the Until Fail repeater, which in turn repeats and freshly re-calls its child sequence to pop the next door from the stack and the NPC will try the next door.  
如果 NPC 无法通过任何可用的方法通过门（门被锁住，并且 NPC 太弱而无法将其分解），那么选择器将失败，并将失败返回给父级，即逆变器，它将失败转化为成功，这意味着它不会逃脱直到失败中继器， 它反过来重复并重新调用其子序列以从堆栈中弹出隔壁，NPC 将尝试隔壁。

If the NPC succeeds in getting through a door, then it will set that door in the ‘usedDoor’ variable, at which point the sequence will return success. This success will be inverted into a failure so we can escape the Until Fail repeater.  
如果 NPC 成功通过一扇门，那么它会在“usedDoor”变量中设置该门，此时序列将返回成功。这种成功将被反转为失败，因此我们可以摆脱直到失败中继器。

In this circumstance, we then fail in the IsNull check on usedDoor, since it’s not null. This is inverted into a success, which causes the entire behaviour to succeed. The parent knows the NPC successfully found a door and got through it into the building.  
在这种情况下，我们在 usedDoor 的 IsNull 检查中失败，因为它不为 null。这被颠倒成成功，这导致整个行为成功。家长知道NPC成功地找到了一扇门，并通过它进入了大楼。

If it failed, the same process could be repeated with a GetWindowStackFromBuilding node, to repeat the process with windows. Or with a little stack manipulation with a few more nodes, perhaps you could call GetDoorStackFromBuilding and GetWindowStackFromBuilding  immediately after eachother, and append the windows to the end of the door stack, and process all of them in the same Until Fail, assuming that Open, Unlock, Smash, Close operated on a generic base of doors and windows, or run-time type checked the object they were operating on.  
如果失败，则可以使用 GetWindowStackFromBuilding 节点重复相同的过程，以在 Windows 中重复该过程。或者通过对更多节点进行一些堆栈操作，也许您可以立即调用 GetDoorStackFromBuilding 和 GetWindowStackFromBuilding，并将窗口附加到门堆栈的末尾，并在相同的 Until Fail 中处理所有窗口，假设 Open、Unlock、Smash、Close 在门窗的通用基础上运行， 或运行时类型检查它们正在操作的对象。

Finally, you may notice I’ve added a Succeeder decorator parenting the close door node. This is because it occurred to me that if an NPC smashed the door, they would no doubt fail to close it.  
最后，您可能会注意到我添加了一个 Succeeder 装饰器来设置关闭的门节点。这是因为我突然想到，如果一个NPC砸碎了门，他们无疑不会关上门。

Without the succeeder this would cause the sequence to fail before the usedDoor variable was set and move onto the next door. An alternate solution would be for Close Door to be designed to always succeed even if the door was smashed. However, we want to retain the ability to test success of closing a door (for example using the node within a ‘Secure Safehouse’ behaviour would deem a failure to close the door because it's no longer on its hinges as pretty pertinent to the situation!), so a Succeeder can ensure that the failure is ignored if that behaviour is required.  
如果没有 succeeder，这将导致序列在设置 usedDoor 变量之前失败并移动到下一个门。另一种解决方案是将 Close Door 设计为即使门被砸碎也能始终成功。但是，我们希望保留测试关门成功与否的能力（例如，在“安全安全屋”行为中使用节点会认为门关闭失败，因为它不再位于铰链上与情况非常相关！），因此成功者可以确保在需要该行为时忽略失败。

