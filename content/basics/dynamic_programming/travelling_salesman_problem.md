---
linkTitle: "15.8. Задача коммивояжёра"
title: "15.8. Задача коммивояжёра и DP по подмножествам"
date: 2026-04-25T09:30:00+03:00
draft: false
weight: 80
---

>[!def]
>**Задача коммивояжёра** (_travelling salesman problem, TSP_): дан полный взвешенный граф на $n$ вершинах. Найти **гамильтонов цикл** (цикл, проходящий по каждой вершине ровно один раз) минимальной длины. Расстояние между вершинами $u$ и $v$ обозначим $d_{u,v}$.

>[!props]
>Задача коммивояжёра NP-трудна. Всего различных маршрутов $(n-1)!$, поэтому полный перебор возможен лишь при малых $n$. Динамическим программированием задачу можно решить за $O(2^n \cdot n^2)$, что значительно быстрее $O(n!)$, хотя по-прежнему экспоненциально.

Естественная подзадача — нахождение «префикса» маршрута (первых нескольких рёбер, начиная из вершины 0). Состояние параметризуется парой $(A, v)$, где $A$ — подмножество вершин, содержащее вершину 0, $v \in A$ — номер последней вершины в префиксе.

Начальные состояния: $l[\{0\}, 0] = 0$; $l[A, 0] = \infty$ при $|A| > 1$. Переход — перебор последнего ребра:
$$
l[A, v] = \min_{\substack{u \in A,\, u \neq v}} \bigl(l[A \setminus \{v\}, u] + d_{u,v}\bigr).
$$

Ответ: $\min_{v > 0} \bigl(l[\text{all}, v] + d_{v,0}\bigr)$.

Прежде чем перейти к реализации, рассмотрим технику работы с множествами как с числами (битовые маски).

## Работа с множествами

Пронумеруем все подмножества $n$-элементного множества $U = \{0, \ldots, n-1\}$ числами от $0$ до $2^n - 1$: подмножеству $A$ сопоставим $\operatorname{mask}(A) = \sum_{i \in A} 2^i$. Основные операции:

- $\operatorname{mask}(A \cup B) = \operatorname{mask}(A) \mid \operatorname{mask}(B)$
- $\operatorname{mask}(A \cap B) = \operatorname{mask}(A) \mathbin{\&} \operatorname{mask}(B)$
- $\operatorname{mask}(A \setminus B) = \operatorname{mask}(A) \mathbin{\&} {\sim}\operatorname{mask}(B)$
- $\operatorname{mask}(U) = (1 \ll n) - 1$
- $\operatorname{mask}(\{k\}) = 1 \ll k$
- $k \in A \Leftrightarrow (\operatorname{mask}(A) \gg k) \mathbin{\&} 1 = 1$

Все битовые операции осуществляются за $O(1)$.

### Размер подмножества

Количество единичных бит в числе $x$ равняется сумме единичных бит в $\lfloor x/2 \rfloor$ и значения младшего бита $x$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def compute_sizes(n: int) -> list[int]:
    """size[mask] = |A|, где mask = mask(A)."""
    size = [0] * (1 << n)
    for mask in range(1, 1 << n):
        size[mask] = size[mask >> 1] + (mask & 1)
    return size
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
using namespace std;

vector<int> computeSizes(int n) {
    vector<int> sz(1 << n, 0);
    for (int mask = 1; mask < (1 << n); mask++)
        sz[mask] = sz[mask >> 1] + (mask & 1);
    return sz;
    // В GCC: __builtin_popcount(mask) делает то же за O(1)
}
```
{{% /tab %}}
{{< /tabs >}}

### Сумма элементов подмножества

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def subset_sums(a: list[int]) -> list[int]:
    """s[mask] = сумма a[i] для i in mask. За O(2^n)."""
    n = len(a)
    s = [0] * (1 << n)
    x = 0  # номер старшего бита текущего mask
    for mask in range(1, 1 << n):
        if mask == (1 << (x + 1)):
            x += 1
        s[mask] = s[mask - (1 << x)] + a[x]
    return s
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
vector<long long> subsetSums(vector<long long>& a) {
    int n = a.size();
    vector<long long> s(1 << n, 0);
    int x = 0;
    for (int mask = 1; mask < (1 << n); mask++) {
        if (mask == (1 << (x + 1))) x++;
        s[mask] = s[mask - (1 << x)] + a[x];
    }
    return s;
}
```
{{% /tab %}}
{{< /tabs >}}

### Сумма по подмножествам (SOS DP)

Пусть для каждого подмножества $A$ дано число $f_A$; требуется для каждого $A$ вычислить $g(A) = \sum_{B \subseteq A} f_B$.

Наивный перебор всех пар $(A, B)$ работает за $O(4^n)$. Перебор только подмножеств $A$ в порядке убывания — за $O(3^n)$ (так как количество пар $(A, B)$ с $B \subseteq A$ равно $3^n$). Оптимальное решение через DP:

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def sum_over_subsets(f: list[int], n: int) -> list[int]:
    """
    Возвращает g[mask] = sum of f[B] for all B subset of mask.
    Время O(2^n * n), память O(2^n).
    """
    g = list(f)
    for k in range(n):
        for mask in range(1 << n):
            if (mask >> k) & 1:
                g[mask] += g[mask ^ (1 << k)]
    return g

def sum_over_subsets_slow(f: list[int], n: int) -> list[int]:
    """Перебор подмножеств за O(3^n)."""
    g = [0] * (1 << n)
    for A in range(1 << n):
        g[A] = f[0]  # пустое подмножество
        B = A
        while B > 0:
            g[A] += f[B]
            B = (B - 1) & A
    return g
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
// SOS DP: O(2^n * n)
vector<long long> sumOverSubsets(vector<long long>& f, int n) {
    vector<long long> g(f);
    for (int k = 0; k < n; k++)
        for (int mask = 0; mask < (1 << n); mask++)
            if ((mask >> k) & 1)
                g[mask] += g[mask ^ (1 << k)];
    return g;
}

// Перебор подмножеств: O(3^n)
vector<long long> sumOverSubsetsSlow(vector<long long>& f, int n) {
    vector<long long> g(1 << n, 0);
    for (int A = 0; A < (1 << n); A++) {
        g[A] = f[0];
        for (int B = A; B > 0; B = (B - 1) & A)
            g[A] += f[B];
    }
    return g;
}
```
{{% /tab %}}
{{< /tabs >}}

>[!props]
>Количество пар $(A, B)$ с $B \subseteq A$ равно $3^n$: каждый из $n$ элементов либо не входит в $A$ ($\notin A$), либо входит в $A \setminus B$, либо входит в $B$. SOS DP улучшает это до $O(2^n \cdot n)$ за счёт «добавления» элементов по одному.

## Реализация задачи коммивояжёра

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def tsp(n: int, d: list[list[int]]) -> int:
    """
    n — число вершин, d[u][v] — расстояние.
    Вершина 0 — стартовая. Возвращает длину минимального гамильтонова цикла.
    """
    INF = float('inf')
    full = (1 << n) - 1
    # l[mask][v] = минимальная длина пути через вершины mask, заканчивающегося в v
    l = [[INF] * n for _ in range(1 << n)]
    l[1][0] = 0  # начинаем в вершине 0, mask = {0} = 1

    for mask in range(1, 1 << n, 2):  # только нечётные (содержат 0)
        for v in range(1, n):
            if not (mask >> v) & 1:
                continue
            prev_mask = mask ^ (1 << v)
            for u in range(n):
                if u == v or not (prev_mask >> u) & 1:
                    continue
                if l[prev_mask][u] + d[u][v] < l[mask][v]:
                    l[mask][v] = l[prev_mask][u] + d[u][v]

    return min(l[full][v] + d[v][0] for v in range(1, n))
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
#include <climits>
using namespace std;

int tsp(int n, vector<vector<int>>& d) {
    const int INF = INT_MAX / 2;
    int full = (1 << n) - 1;
    // l[mask][v] = мин. длина пути через mask, заканчивающегося в v
    vector<vector<int>> l(1 << n, vector<int>(n, INF));
    l[1][0] = 0;

    for (int mask = 1; mask < (1 << n); mask += 2) {  // нечётные
        for (int v = 1; v < n; v++) {
            if (!((mask >> v) & 1)) continue;
            int prevMask = mask ^ (1 << v);
            for (int u = 0; u < n; u++) {
                if (u == v || !((prevMask >> u) & 1)) continue;
                if (l[prevMask][u] != INF)
                    l[mask][v] = min(l[mask][v], l[prevMask][u] + d[u][v]);
            }
        }
    }

    int res = INF;
    for (int v = 1; v < n; v++)
        if (l[full][v] != INF)
            res = min(res, l[full][v] + d[v][0]);
    return res;
}
```
{{% /tab %}}
{{< /tabs >}}

Восстановление ответа осуществляется стандартными методами: для каждого состояния запоминаем, из какого состояния в него был сделан оптимальный переход.
