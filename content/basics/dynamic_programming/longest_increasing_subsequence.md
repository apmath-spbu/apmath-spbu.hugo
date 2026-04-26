---
linkTitle: "15.4. Наибольшая возрастающая подпоследовательность"
title: "15.4. Наибольшая возрастающая подпоследовательность"
date: 2026-04-25T09:30:00+03:00
weight: 40
draft: false
---

>[!def]
>**Наибольшая возрастающая подпоследовательность** (НВП, _longest increasing subsequence, LIS_) последовательности $a_1, \ldots, a_n$ — это подпоследовательность максимальной длины, в которой каждое следующее число строго больше предыдущего.

Дана последовательность чисел $a_{1}, \ldots, a_{n}$. Требуется найти возрастающую подпоследовательность максимально возможной длины.

### Решение за $O(n^2)$

Пусть $l_i$ — максимально возможная длина возрастающей подпоследовательности, **заканчивающейся** в $a_i$. Тогда
$$
l_{i} = 1 + \max_{\substack{0 \leqslant j < i,\\ a_{j} < a_{i}}} l_{j}
$$
(максимум по пустому множеству считаем равным нулю). Ответ на задачу — максимальное значение $l_i$ по всем $i$. Восстановление ответа делается стандартными методами. Получаем решение за $O(n^2)$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def lis_n2(a: list[int]) -> int:
    """Возвращает длину НВП за O(n^2)."""
    n = len(a)
    l = [1] * n
    for i in range(n):
        for j in range(i):
            if a[j] < a[i]:
                l[i] = max(l[i], l[j] + 1)
    return max(l)
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
using namespace std;

int lisN2(vector<int>& a) {
    int n = a.size();
    vector<int> l(n, 1);
    for (int i = 0; i < n; i++)
        for (int j = 0; j < i; j++)
            if (a[j] < a[i])
                l[i] = max(l[i], l[j] + 1);
    return *max_element(l.begin(), l.end());
}
```
{{% /tab %}}
{{< /tabs >}}

### Решение за $O(n \log n)$

Будем поддерживать дополнительный массив: пусть
$$
x[k] = \min_{\substack{j \leqslant i,\\ l_j = k}} a_j
$$
(минимум по пустому множеству — бесконечность). Тогда $l_i = 1 + \max_{k:\, x[k] < a_i} k$.

>[!theorem]
>Элементы массива $x[i]$ идут в строгом порядке возрастания: для любого $k > 1$ выполняется $x[k-1] < x[k]$.
>>[!prove]+
>>Если $x[k] \neq \infty$, то $x[k] = a_j$ для некоторого $j$ такого, что $l_j = k$. Существует $q < j$: $l_q = k - 1$, $a_q < a_j$. Тогда $x[k-1] \leqslant a_q < a_j = x[k]$.

Поскольку элементы массива $x$ идут в порядке возрастания, $l_i$ можно найти двоичным поиском за $O(\log n)$. При переходе от $i$ к $i+1$ массив $x$ меняется не более чем в одной ячейке: $x[l_i] = \min(x[l_i], a_i)$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
import bisect

def lis_nlogn(a: list[int]) -> int:
    """Возвращает длину НВП за O(n log n)."""
    x = []  # x[k] = минимальный конец возрастающей подпоследовательности длины k+1
    for v in a:
        pos = bisect.bisect_left(x, v)
        if pos == len(x):
            x.append(v)
        else:
            x[pos] = v
    return len(x)
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
using namespace std;

int lisNlogN(vector<int>& a) {
    vector<int> x;  // x[k] = минимальный конец подпоследовательности длины k+1
    for (int v : a) {
        auto it = lower_bound(x.begin(), x.end(), v);
        if (it == x.end())
            x.push_back(v);
        else
            *it = v;
    }
    return x.size();
}
```
{{% /tab %}}
{{< /tabs >}}

### Восстановление ответа

Для восстановления вместе с массивом $x$ будем поддерживать массив списков `pos`: в момент присвоения $x[l_i] = a_i$ допишем $i$ в конец списка $\operatorname{pos}[l_i]$. Чтобы найти предыдущий элемент в НВП, заканчивающейся в позиции $i$, нужно найти максимальный элемент в $\operatorname{pos}[l_i - 1]$, меньший $i$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
import bisect

def lis_restore(a: list[int]) -> list[int]:
    """Возвращает саму НВП (одну из возможных)."""
    n = len(a)
    x = []       # концы подпоследовательностей
    l = [0] * n  # l[i] = длина НВП, заканчивающейся в a[i]
    pos = []     # pos[k] = список индексов с l[i] == k+1, в порядке добавления

    for i, v in enumerate(a):
        p = bisect.bisect_left(x, v)
        if p == len(x):
            x.append(v)
            pos.append([])
        else:
            x[p] = v
        l[i] = p + 1
        pos[p].append(i)

    # Восстановление
    ans = []
    cur_len = len(x)
    bound = n
    for k in range(cur_len - 1, -1, -1):
        # найти наибольший индекс в pos[k], меньший bound
        lst = pos[k]
        j = bisect.bisect_left(lst, bound) - 1
        ans.append(a[lst[j]])
        bound = lst[j]
    return ans[::-1]
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
using namespace std;

vector<int> lisRestore(vector<int>& a) {
    int n = a.size();
    vector<int> x;
    vector<int> l(n);
    vector<vector<int>> pos;  // pos[k] = индексы с l[i] == k+1

    for (int i = 0; i < n; i++) {
        int p = (int)(lower_bound(x.begin(), x.end(), a[i]) - x.begin());
        if (p == (int)x.size()) {
            x.push_back(a[i]);
            pos.push_back({});
        } else {
            x[p] = a[i];
        }
        l[i] = p + 1;
        pos[p].push_back(i);
    }

    // Восстановление
    vector<int> ans;
    int curLen = x.size(), bound = n;
    for (int k = curLen - 1; k >= 0; k--) {
        auto& lst = pos[k];
        int j = (int)(lower_bound(lst.begin(), lst.end(), bound) - lst.begin()) - 1;
        ans.push_back(a[lst[j]]);
        bound = lst[j];
    }
    reverse(ans.begin(), ans.end());
    return ans;
}
```
{{% /tab %}}
{{< /tabs >}}
