---
layout: post
title: 为什么C++代码中要谨慎使用min()  max()  abs()
subtitle: 提前避免函数重定义问题
date: 2023-05-28 10:17:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [C++,重定义]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# 为什么C++代码中要谨慎使用min()  max()  abs()

在 C++ 代码中，虽然可以使用 `min()`、`max()` 和 `abs()` 等函数来进行最小值、最大值和绝对值的计算，但需要谨慎使用它们的原因有以下几点：

1. 名字冲突：`min()`、`max()` 和 `abs()` 是标准库中的函数名，但它们也可能与用户定义的变量、函数或宏冲突。为了避免命名冲突，有时候需要使用作用域解析运算符来明确指定使用的函数，如 `std::min()`、`std::max()` 和 `std::abs()`。

2. 潜在的宏定义：这些函数名也被广泛用作宏定义，其定义方式可能与标准库提供的函数不同，例如使用宏展开来实现，而不是真正的函数调用。这可能导致预期之外的行为或潜在的问题。

3. 类型不匹配：这些函数在处理不同类型的数据时，可能会出现类型不匹配的问题。例如，`min()` 和 `max()` 函数对于某些特殊类型的比较可能会导致不正确的结果，或者对自定义类型的比较可能需要自定义比较函数或运算符重载。

4. 潜在的副作用：这些函数在实际调用时可能具有副作用，例如在宏定义中可能会有一些附加操作。这可能对代码的可读性、可维护性和可预测性产生负面影响。

为了避免这些潜在的问题，有时候可以考虑使用其他方式来实现最小值、最大值和绝对值的计算，例如使用条件表达式、标准库中的其他函数或自定义的函数，以便更加清晰、准确和可控地进行数值操作。同时，对于特定的数据类型和需求，也可以根据具体情况自行实现相应的最小值、最大值和绝对值的功能。

## 如何规避

使用静态方法重写这几个函数，如下：

```cpp
static inline double _fun_max_d(double a, double b) {
  return a > b ? a : b;
}
```

## 静态内联函数

静态内联函数（`static inline` 函数）具有以下优势和劣势：

优势：
1. 减少函数调用开销：内联函数在编译时会被直接插入到调用处，而不是通过函数调用的方式执行。这可以减少函数调用的开销，包括参数传递、栈帧的创建和销毁等操作。

2. 提高执行速度：由于内联函数直接插入到调用处，避免了函数调用的开销，因此可以提高程序的执行速度。对于短小的函数代码，内联可以减少跳转和返回的开销。

3. 编译器优化：内联函数可以为编译器提供更多的优化机会。编译器可以在编译时对内联函数进行优化，例如常量折叠、循环展开等，以提高代码执行效率。

劣势：
1. 代码膨胀：内联函数会将函数体插入到调用处，这可能会导致代码膨胀。对于函数体较大的函数，内联会增加可执行文件的大小，可能会导致缓存命中率下降，从而降低性能。

2. 增加可执行文件大小：由于内联函数会被复制多次插入到调用处，因此会增加可执行文件的大小。如果有多个调用点，内联函数的多个副本可能会导致代码冗余。

3. 编译时间增加：内联函数需要在每个调用点进行展开，这可能会增加编译时间，特别是对于较大的内联函数或在多个源文件中频繁调用的内联函数。

静态内联函数在适当的情况下可以提供性能优势，减少函数调用开销并提高执行速度。然而，需要根据具体的情况权衡优劣，并根据实际需求和性能测试来决定是否使用内联函数。在一些情况下，编译器会自动进行内联优化，因此显式声明内联函数并不总是必要的。

## 补充一个小知识点：使用printf输出地址

要在 C 语言中打印变量的地址，可以使用 `%p` 格式说明符和 `&` 运算符来实现。以下是一个示例：

```c
#include <stdio.h>

int main() {
    int num = 42;
    float pi = 3.14159;
    char ch = 'A';

    printf("Address of num: 0x%p\n", (void*)&num);
    printf("Address of pi: 0x%p\n", (void*)&pi);
    printf("Address of ch: 0x%p\n", (void*)&ch);

    return 0;
}
```

上述代码中，`%p` 格式说明符用于打印地址，`(void*)` 强制转换将地址转换为 `void*` 类型，以与 `%p` 保持一致。使用 `&` 运算符可以获取变量的地址。每个变量的地址都会被打印出来。

注意，打印地址时需要将地址转换为 `void*` 类型，因为 `printf` 函数的参数类型是可变的，需要使用 `void*` 类型来接受地址参数。