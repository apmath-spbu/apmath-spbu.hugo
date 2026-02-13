---
title: "3. Рекурентные соотношения"
date: 2025-02-13T09:30:00+03:00
draft: false
weight: 30
---


## Основная теорема о рекуррентных соотношениях

Алгоритм Карацубы - пример применения метода "разделяй и властвуй" ("divide-and-conquer"), с которым мы ещё не раз встретимся.

Идея этого метода состоит в том, чтобы свести решение задачи к решению нескольких подзадач в несколько раз меньшего размера, после чего восстановить решение исходной задачи с помощью решений подзадач. Сейчас мы докажем достаточно общую теорему, применимую к оценке многих алгоритмов, использующих метод "разделяй и властвуй".

>[!theorem] Основная теорема о рекуррентных соотношениях
>Пусть $T(n)=a \cdot T\left(\left\lceil\frac{n}{b}\right\rceil\right)+\Theta\left(n^{c}\right)$, где $a>0, b>1, c \geqslant 0$. Тогда
>
>$$T(n)= \begin{cases}\Theta\left(n^{c}\right), & \text { если } c > \log_{b} a \\ \Theta\left(n^{c} \log n\right), & \text { если } c=\log _{b} a \\ \Theta\left(n^{\log _{b} a}\right), & \text { если } c < \log_{b} a\end{cases}$$
>{{% notice style="prove" expanded="true" %}}
Пусть мы уже доказали утверждение теоремы для чисел вида $n=b^{k}$. Рассмотрим такую функцию $k(n)$, что для любого $n$ верно $b^{k(n)-1} < n \leqslant b^{k(n)}$. При уменьшении $n$ количество веток в дереве рекурсии и их размер могли только уменьшиться, поэтому

$$
T(n) = O \left(T\left(b^{k(n)}\right)\right)= \begin{cases}O\left(b^{k(n) c}\right)=O\left(n^{c}\right), & \text { если } c>\log _{b} a \\ O\left(b^{k(n) c} \log \left(b^{k(n)}\right)\right)=O\left(n^{c} \log n\right), & \text { если } c=\log _{b} a \\ O\left(b^{k(n) \log _{b} a}\right)=O\left(n^{\log _{b} a}\right), & \text { если } c < \log _{b} a\end{cases}
$$

(мы пользуемся тем, что $b^{k(n)} = b \cdot b^{k(n)-1} < b n = O(n)$ ).
Доказательство же точной асимптотической оценки $(\Theta)$ для произвольного $n$ требует ещё некоторого количества технических выкладок, которые мы опустим. Желающие могут прочитать их в главе 4.6 в Кормене[^1].

[^1]: [Introduction to Algorithms (Fourth Edition)](https://dl.ebooksworld.ir/books/Introduction.to.Algorithms.4th.Leiserson.Stein.Rivest.Cormen.MIT.Press.9780262046305.EBooksWorld.ir.pdf)

Теперь считаем, что $n=b^{k}$ для некоторого $k$.
Раскроем рекуррентность:

$$
\begin{gathered}
T(n)=a \cdot T\left(\frac{n}{b}\right)+\Theta\left(n^{c}\right)=\Theta\left(n^{c}+a \cdot\left(\frac{n}{b}\right)^{c}\right)+a^{2} T\left(\frac{n}{b^{2}}\right)= \\
=\cdots=\Theta\left(n^{c} \cdot\left(1+\frac{a}{b^{c}}+\left(\frac{a}{b^{c}}\right)^{2}+\cdots+\left(\frac{a}{b^{c}}\right)^{k-1}\right)\right)+a^{k} T(1)= \\
=\Theta\left(n^{c} \cdot\left(1+\frac{a}{b^{c}}+\left(\frac{a}{b^{c}}\right)^{2}+\cdots+\left(\frac{a}{b^{c}}\right)^{k}\right)\right)
\end{gathered}
$$

(последнее слагаемое $a^{k} T(1)=\Theta\left(a^{k}\right)=\Theta\left(n^{c} \cdot\left(\frac{a}{b^{c}}\right)^{k}\right)$, так как $\left.T(1)=\Theta(1), n=b^{k}\right)$.
Получаем геометрическую прогрессию со знаменателем $q=\frac{a}{b^{c}}$.

Если $c>\log _{b} a$, то $q < 1$, тогда

$$
T(n)=\Theta\left(n^{c} \cdot \frac{1-q^{k+1}}{1-q}\right)=\Theta\left(n^{c} \cdot \frac{1}{1-q}\right)=\Theta\left(n^{c}\right)
$$

Если $c=\log _{b} a$, то $q=1$, тогда

$$
T(n)=\Theta\left(n^{c} \cdot(k+1)\right)=\Theta\left(n^{c} \log _{b} n\right)=\Theta\left(n^{c} \log n\right)
$$

Наконец, если $c < \log _{b} a$, то $q>1$, тогда

$$
T(n)=\Theta\left(n^{c} \cdot\left(q^{k}+\frac{q^{k}-1}{q-1}\right)\right)=\Theta\left(n^{c} q^{k}\right)=\Theta\left(a^{k}\right)=\Theta\left(a^{\log _{b} n}\right)=\Theta\left(n^{\log _{b} a}\right)
$$


{{% /notice %}}


В алгоритме Карацубы $a=3, b=2, c=1$, это соответствует третьему случаю теоремы, который и даёт $T(n)=\Theta\left(n^{\log _{2} 3}\right)$.

#### Оцените следующие алгоритмы

{{% notice style="ex" title="Пример 1" expanded="false" %}}
```cpp
void foo(int* array, int n) {
    int sum = 0;
    int product = 1;
    for (int i = 0; i < n; i++) {
        sum += array[i];
    }
    for (int i = 0; i < n; i++) {
        product += array[i];
    }

    std::cout << sum << ", " << product;
}
```
{{% /notice %}}

{{% notice style="ex" title="Пример 2" expanded="false" %}}
```cpp
void printPairs(int* arr, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            std::cout << arr[i] << ", " << arr[j] << std::endl;
        }
    }
}
```
{{% /notice %}}

{{% notice style="ex" title="Пример 3" expanded="false" %}}

```cpp
void printPairs(int* arr, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            std::cout << arr[i] << ", " << arr[j] << std::endl;
        }
    }
}
```
{{% /notice %}}

{{% notice style="ex" title="Пример 4" expanded="false" %}}

```cpp
void printUnorderedPairs(int* arrA, int n, int* arrB, int m) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            if (arrA[i] < arrB[j]) {
                std::cout << arr[i] << ", " << arr[j] << std::endl;
            }
        }
    }
}
```
{{% /notice %}}

{{% notice style="ex" title="Пример 5" expanded="false" %}}
```cpp
void printUnorderedPairs(int* arrA, int n, int* arrB, int m) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            for (int j = 0; j < 100000; j++) {
                std::cout << arr[i] << ", " << arr[j] << std::endl;
            }
        }
    }
}
```
{{% /notice %}}

{{% notice style="ex" title="Пример 6" expanded="false" %}}
```cpp
void reverse(int* arr, int n) {
    for (int i = 0; i < n / 2; i++) {
        int other = n - i - 1;
        int temp = arr[i];
        arr[i] = arr[other];
        arr[other] = temp
    }
}
```
{{% /notice %}}

{{% notice style="ex" title="Пример 7" expanded="false" %}}
```cpp
bool isPrime(int n) {
    for (int x = 2; x * x <= n; x++) {
        if (n % x == 0) {
            return false;
        }
    }

    return true;
}
```
{{% /notice %}}

{{% notice style="ex" title="Пример 8" expanded="false" %}}
```cpp
int factorial(int n) {
    if (n < 0) {
        return -1;
    } else if (n == 0) {
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}
```
{{% /notice %}}

{{% notice style="ex" title="Пример 9" expanded="false" %}}
```cpp
int fib(int n) {
    if (n <= 0) return 0;
    else if (n == 1) return 1;
    else fib(n - 1) + fib(n - 2);
}
```
{{% /notice %}}