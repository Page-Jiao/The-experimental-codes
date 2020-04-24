# 信息安全导论第三次实验报告

+ 焦培淇 &nbsp; &nbsp; PB17151767

## 实验目的

+ 将课堂上所讲的缓冲区溢出攻击知识融入实践。
+ 了解现代操作系统应对缓冲区溢出攻击的措施。

## 实验内容

1. 初始化步骤：了解如何关闭操作系统地址虚拟化，gcc编译器的堆栈保护措施以及生成带有可执行栈的可执行文件。
2. 编译运行shellcode，确保shellcode运行正常。
3. 利用root用户编译stack.c文件，并修改文件权限。
4. 在关闭地址虚拟化的情况下，利用exploit.c文件生成badfile并通过stack可执行文件获取具有root权限的shell。
5. 打开地址虚拟化，再次尝试攻击，观察结果。
6. 开启gcc栈保护措施，再次尝试攻击。
7. 编译生成不带可执行栈的文件，再次尝试攻击。

## 实验步骤

### 初始化

切换到root用户，运行以下命令，关闭系统地址随机化。

    sysctl -w kernel.randomize_va_space=0
![关闭地址虚拟化](./images/1.jpg)

### 编译运行call_shellcode.c

![callshellcode](./images/call_shellcode.jpg)

可见成功获取shell

### 利用root用户编译stack.c文件并修改权限

![stack](./images/stack.jpg)

### 利用exploit.c文件生成badfile，并运行stack以获取具有root权限的shell

![task1](./images/task1.jpg)

通过查看id可知，已经获取具有root权限的shell

### 开启地址虚拟化，再次尝试攻击

![task2](./images/tasks2.jpg)

可见在开启地址虚拟化的情况下，攻击失败。

采用循环不断运行该程序，结果如下

![fail](./images/task2_fail.jpg)

可见在地址虚拟化的保护下，暴力的攻击取得成功的概率也比较小

### 开启gcc栈保护措施，再次尝试攻击

首先关闭地址随机化，并开启保护措施重新编译stack.c

![task3](./images/task3.jpg)

再次运行./stack，结果如下：

![result](./images/task3_result.jpg)

可见报两个错误，第一个是因分配空间不足引起的"stack smashing detected"，第二个是段错误。

### 编译生成不带可执行栈的程序，再次尝试攻击

首先重新编译程序如下：

![tasks4](./images/task4.jpg)

运行stack结果如下：

![result](./images/task4_result.jpg)

可见报段错误信息。此处因为带有不可执行栈，因此shellcode部分并不在栈中，因此修改返回地址后并不能跳入shellcode执行，因此出现段错误。
