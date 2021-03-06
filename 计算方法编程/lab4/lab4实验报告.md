# 计算方法第四次实验报告

+ 焦培淇 &nbsp; &nbsp; PB17151767

## 实验结果

### Jacobi迭代法

迭代步数285次

迭代结果：

x = [9.999932986346156, 17.99987140174, 23.99982023540007, 27.99978363251892, 29.999764558444305, 29.999764558444305, 27.99978363251892, 23.99982023540007, 17.99987140174, 9.999932986346156]

### Gauss-Seidel迭代法

迭代步数152

x = [9.999962267140672, 17.99993052423946, 23.99990681539073, 27.999892384753743, 29.999887641293157, 29.99989219261026, 27.999904939695735, 23.99992422024755, 17.999947985323615, 9.999973992661808]

### 精确解

x = [10, 18, 24, 28, 30, 30, 28, 24, 18, 10}

## 结果分析

1. 从两种迭代算法的公式中可以看出：Jacobi迭代算法的公式较为简单，等式左边统一都是此次迭代后的新值，等式右边统一都是此次迭代后的旧值，因此非常易于编程。而Gauss-Seidel迭代算法的公式就比较复杂，等式右边既有新值又有旧值。
2. 从上述的结果可以看出，Gauss-Seidel迭代法的收敛速度明显高于Jacobi迭代法，同时Gauss-Seidel迭代算法中，存在由新的x<sup>(k+1)</sup>取代x<sup>(k)</sup>的情况，因此可以减少一半x的存储空间。

## 实验结论

Gauss-Seidel迭代算法的收敛速度比Jacobi迭代算法的收敛速度快，因此在使用迭代法求
线性方程组组时，使用Gauss-Seidel迭代算法往往效果更好，但是要注意有些方程组，使用Gauss-Seidel迭代算法会发散，这时就要使用Jacobi迭代算法才能得到一个收敛的解。
