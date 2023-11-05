---
layout: post
title: 将int以字节的形式放在vector中
subtitle: 二进制数据刷入内存中
date: 2023-05-28 10:22:00
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags: [C++,vector]
typora-copy-images-to: ../img/post
typora-root-url: ../
---

# 将int以字节的形式放在vector中

```cpp
void PushIntToCharVecInternal(std::vector<char>& buf,int num){
	buf.push_back(num);
	buf.push_back(num>>8);
	buf.push_back(num>>16);
	buf.push_back(num>>24);
}

void GetIntByCharVecInternal(const char* buf,int offset,int& num){
	num = 0;
	memcpy(&num, buf + offset, 4);
}
```

备注：

- 一般情况下int是占4 byte的；
- PushIntToCharVecInternal函数中需要注意当前系统是大端还是小端

使用以下方法也可以：[也可以直接强转为char\*，然后插入]

```cpp
	std::vector<char> numVec;
	int numA = -114;
	void* numAPtr = (void*)&numA;
	numVec.insert(numVec.end(), (char*)numAPtr, (char*)numAPtr + 4);
	int numAGet = *(int*)numVec.data();
```

## 将整形数据放入QByteArray中

```cpp
//1.写入的过程：
QByteArray headerarray, jsonarray;//jsonarray是有值的
unsigned size = jsonarray.size();
headerarray = QByteArray((char*)(void*)&size, sizeof(unsigned));

//2.读取的过程，其中bData是二进制数据，pickEnd - pickStart的值为unsigned的大小
int jsonSize = *(unsigned*)(void*)(bData.mid(pickStart, pickEnd - pickStart).constData());

//3.另外的一个例子：
bool bOk;
unsigned char a0 = (unsigned char)QString("0xdd").toUInt(&bOk, 16);
unsigned char a1 = 0xdd; 
QByteArray b;
b.append((char*)(void*)&a1, sizeof(unsigned char));
int a2 = (int)*(unsigned char*)(void*)b.mid(0, 1).constData();
//经过测试，其中a0,a1,a2的值是一致的
```

> 对于需要序列化的内容，通常使用QT的QDataStream来进行序列化，不需要自己去处理二进制数据，且不需要考虑大端或小端的问题

## 使用ChatGPT得到的回复

要将一个 `int` 值以字节的形式放入一个 `std::vector` 中，您可以使用位运算和类型转换来完成。下面是一个示例代码：

```cpp
#include <iostream>
#include <vector>

int main() {
    int value = 123456789;

    // 将 int 值以字节的形式存储在 vector 中
    std::vector<unsigned char> byteVector;
    for (int i = 0; i < sizeof(value); ++i) {
        unsigned char byte = (value >> (i * 8)) & 0xFF;
        byteVector.push_back(byte);
    }

    // 打印 vector 中的字节
    for (const auto& byte : byteVector) {
        std::cout << static_cast<int>(byte) << " ";
    }
    std::cout << std::endl;

    return 0;
}
```

在上述示例中，我们首先定义了一个 `int` 值 `value`，然后使用一个 `for` 循环将其以字节的形式存储在 `std::vector<unsigned char>` 中。每次迭代中，我们使用位移和位掩码运算将 `int` 值中的每个字节提取出来，并将其存储在 `byteVector` 中。

最后，我们遍历 `byteVector`，打印每个字节的整数值。

请注意，字节的顺序取决于系统的字节顺序（大端序或小端序）。以上示例中的代码适用于小端序的系统。如果您的系统是大端序，需要适当地调整字节的顺序。

> 在分享的过程中不分问题会询问ChatGPT，以此来得到一个比较好的答案，但是这个举动可能会污染互联网的答案集合，因为有的时候AI的回复并不准确。