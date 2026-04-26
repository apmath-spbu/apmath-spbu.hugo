---
linkTitle: "15.5. Задача о рюкзаке"
title: "15.5. Задача о рюкзаке"
date: 2026-04-25T09:30:00+03:00
weight: 50
draft: false
---

>[!def]
>**Задача о рюкзаке** (_knapsack problem_): есть рюкзак вместимости $W$ и $n$ предметов весов $w_1, \ldots, w_n$ и стоимостей $p_1, \ldots, p_n$. Найти подмножество предметов $A \subset \{1, \ldots, n\}$ максимальной суммарной стоимости, помещающееся в рюкзак: $\sum_{i \in A} w_i \leqslant W$.

Существует много различных вариаций этой задачи. Можно считать, что есть лишь одна копия каждого предмета (версия «без повторений»), а можно — что копий каждого предмета бесконечно много (версия «с повторениями»).

### Версия «с повторениями»

Пусть $k[j]$ — максимальная возможная суммарная стоимость при вместимости рюкзака $j$. Начальное состояние: $k[0]=0$. Переход — выбор последнего взятого предмета:
$$
k[j] = \max_{w_i \leqslant j}\bigl(k[j - w_i] + p_i\bigr).
$$
Ответ на задачу: $\max_{0 \leqslant j \leqslant W} k[j]$. Получаем решение за $O(nW)$ с $O(W)$ дополнительной памяти.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def knapsack_unbounded(W: int, weights: list[int], prices: list[int]) -> int:
    """Рюкзак с повторениями. Возвращает максимальную стоимость."""
    n = len(weights)
    k = [0] * (W + 1)
    for j in range(W + 1):
        for i in range(n):
            if weights[i] <= j:
                k[j] = max(k[j], k[j - weights[i]] + prices[i])
    return k[W]
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
using namespace std;

// Рюкзак с повторениями
int knapsackUnbounded(int W, vector<int>& w, vector<int>& p) {
    int n = w.size();
    vector<int> k(W + 1, 0);
    for (int j = 0; j <= W; j++)
        for (int i = 0; i < n; i++)
            if (w[i] <= j)
                k[j] = max(k[j], k[j - w[i]] + p[i]);
    return k[W];
}
```
{{% /tab %}}
{{< /tabs >}}

### Версия «без повторений»

Для того, чтобы не взять один предмет несколько раз, введём дополнительный параметр. Пусть $k[i, j]$ — максимальная возможная суммарная стоимость, если разрешается брать только предметы с номерами не больше $i$, а рюкзак имеет вместимость $j$. Начальные состояния: $k[0, j] = k[i, 0] = 0$. Переход: либо $i$-й предмет входит в ответ, либо нет.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def knapsack_01(W: int, weights: list[int], prices: list[int]) -> int:
    """Рюкзак без повторений, O(nW) памяти."""
    n = len(weights)
    k = [[0] * (W + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for j in range(W + 1):
            k[i][j] = k[i-1][j]
            if weights[i-1] <= j:
                k[i][j] = max(k[i][j], k[i-1][j - weights[i-1]] + prices[i-1])
    return k[n][W]
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
int knapsack01(int W, vector<int>& w, vector<int>& p) {
    int n = w.size();
    vector<vector<int>> k(n + 1, vector<int>(W + 1, 0));
    for (int i = 1; i <= n; i++)
        for (int j = 0; j <= W; j++) {
            k[i][j] = k[i-1][j];
            if (w[i-1] <= j)
                k[i][j] = max(k[i][j], k[i-1][j - w[i-1]] + p[i-1]);
        }
    return k[n][W];
}
```
{{% /tab %}}
{{< /tabs >}}

### Оптимизация памяти

При вычислении $k[i, j]$ нужны только значения $k[i-1, q]$ с $q \leqslant j$. Если перебирать $j$ в порядке **убывания**, можно обойтись одномерным массивом: при обработке состояния $(i, j)$ в $k[0..j]$ хранятся значения $k[i-1, 0], \ldots, k[i-1, j]$, а в $k[j+1..W]$ — значения $k[i, j+1], \ldots, k[i, W]$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def knapsack_01_opt(W: int, weights: list[int], prices: list[int]) -> int:
    """Рюкзак без повторений, O(W) памяти."""
    n = len(weights)
    k = [0] * (W + 1)
    for i in range(n):
        for j in range(W, weights[i] - 1, -1):  # убывание!
            k[j] = max(k[j], k[j - weights[i]] + prices[i])
    return k[W]
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
int knapsack01Opt(int W, vector<int>& w, vector<int>& p) {
    int n = w.size();
    vector<int> k(W + 1, 0);
    for (int i = 0; i < n; i++)
        for (int j = W; j >= w[i]; j--)  // убывание!
            k[j] = max(k[j], k[j - w[i]] + p[i]);
    return k[W];
}
```
{{% /tab %}}
{{< /tabs >}}

>[!props]
>Задача о рюкзаке NP-трудна в общем виде (зависимость от $W$), но алгоритм DP работает за $O(nW)$ — это **псевдополиномиальное** время, так как $W$ экспоненциально по числу битов в его представлении. Восстановление ответа в версии с одномерным массивом невозможно напрямую; однако можно применить идею [алгоритма Хиршберга]({{% relref "basics/dynamic_programming/hirschbergs_algorithm" %}}) и восстановить ответ, используя $O(W + \log n)$ дополнительной памяти.
