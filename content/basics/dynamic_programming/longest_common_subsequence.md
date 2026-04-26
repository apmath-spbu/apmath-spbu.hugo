---
linkTitle: "15.1. Наибольшая общая подпоследовательность"
title: "15.1. Наибольшая общая подпоследовательность"
date: 2026-04-25T09:30:00+03:00
weight: 10
draft: false
---

>[!def]
>**Подпоследовательность** (_subsequence_) последовательности $a_1, \ldots, a_n$ — это последовательность, полученная удалением нуля или более элементов без изменения порядка оставшихся. **Наибольшая общая подпоследовательность** (НОП, _longest common subsequence, LCS_) последовательностей $a$ и $b$ — это подпоследовательность максимальной длины, являющаяся подпоследовательностью обеих.

Пусть даны две последовательности чисел $a_{1}, \ldots, a_{n}$ и $b_{1}, \ldots, b_{m}$. Требуется найти последовательность $c$ как можно большей длины, которая была бы подпоследовательностью и $a$, и $b$. Например, для последовательностей $2,1,2,3,1,2$ и $2,3,2,2,1$ возможные ответы — $2,2,2$; $2,3,2$; $2,3,1$ и $2,2,1$.

Пусть $l[i, j]$ — длина НОП последовательностей $a_{1}, \ldots, a_{i}$ и $b_{1}, \ldots, b_{j}$. Начальные значения: $l[i, 0] = l[0, j] = 0$. Нас интересует $l[n, m]$.

Как вычислить $l[i, j]$? Посмотрим на $a_{i}$ и $b_{j}$: либо один из них не входит в ответ (то есть $l[i, j]=l[i-1, j]$ или $l[i, j]=l[i, j-1]$), либо они оба совпадают с последним элементом ответа, тогда $l[i, j]=l[i-1, j-1]+1$. Последний случай возможен лишь при $a_{i}=b_{j}$. Поскольку нас интересует наибольшая общая подпоследовательность, нужно взять максимум по всем возможным переходам. Если перебирать состояния в порядке увеличения $i$, а потом $j$, то к моменту рассмотрения состояния $(i, j)$ состояния $(i-1, j)$, $(i, j-1)$ и $(i-1, j-1)$ уже будут рассмотрены. Получаем решение за $O(nm)$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def lcs_table(a: list, b: list) -> list[list[int]]:
    """Возвращает таблицу l[i][j] — длина НОП a[:i] и b[:j]."""
    n, m = len(a), len(b)
    l = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            l[i][j] = max(l[i-1][j], l[i][j-1])
            if a[i-1] == b[j-1]:
                l[i][j] = max(l[i][j], l[i-1][j-1] + 1)
    return l
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
using namespace std;

// Возвращает таблицу l[i][j] — длина НОП a[0..i) и b[0..j)
vector<vector<int>> lcsTable(vector<int>& a, vector<int>& b) {
    int n = a.size(), m = b.size();
    vector<vector<int>> l(n + 1, vector<int>(m + 1, 0));
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            l[i][j] = max(l[i-1][j], l[i][j-1]);
            if (a[i-1] == b[j-1])
                l[i][j] = max(l[i][j], l[i-1][j-1] + 1);
        }
    return l;
}
```
{{% /tab %}}
{{< /tabs >}}

Значения $l$ для последовательностей $2,1,2,3,1,2$ и $2,3,2,2,1$:

$$
\begin{array}{|cc|c|c|c|c|c|c|}
\hline & & & \color{blue}{2} & \color{blue}{3} & \color{blue}{2} & \color{blue}{2} & \color{blue}{1} \\
                      &   & 0 & 1 & 2 & 3 & 4 & 5 \\
\hline                & 0 & 0 & 0 & 0 & 0 & 0 & 0 \\
\hline\color{blue}{2} & 1 & 0 & 1 & 1 & 1 & 1 & 1 \\
\hline\color{blue}{1} & 2 & 0 & 1 & 1 & 1 & 1 & 2 \\
\hline\color{blue}{2} & 3 & 0 & 1 & 1 & 2 & 2 & 2 \\
\hline\color{blue}{3} & 4 & 0 & 1 & 2 & 2 & 2 & 2 \\
\hline\color{blue}{1} & 5 & 0 & 1 & 2 & 2 & 2 & 3 \\
\hline\color{blue}{2} & 6 & 0 & 1 & 2 & 3 & 3 & 3 \\
\hline
\end{array}
$$

### Восстановление ответа

Пусть требуется узнать не только длину НОП, но и найти саму подпоследовательность. Откатываемся из конечного состояния $(n, m)$, переходя по оптимальным переходам и добавляя символ в ответ, когда переход идёт «по диагонали».

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def lcs_restore(a: list, b: list, l: list[list[int]]) -> list:
    """Восстанавливает саму НОП по таблице l."""
    i, j = len(a), len(b)
    ans = []
    while i > 0 and j > 0:
        if a[i-1] == b[j-1] and l[i][j] == l[i-1][j-1] + 1:
            ans.append(a[i-1])
            i -= 1; j -= 1
        elif l[i][j] == l[i-1][j]:
            i -= 1
        else:
            j -= 1
    return ans[::-1]
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
vector<int> lcsRestore(vector<int>& a, vector<int>& b,
                       vector<vector<int>>& l) {
    int i = a.size(), j = b.size();
    vector<int> ans;
    while (i > 0 && j > 0) {
        if (a[i-1] == b[j-1] && l[i][j] == l[i-1][j-1] + 1) {
            ans.push_back(a[i-1]);
            i--; j--;
        } else if (l[i][j] == l[i-1][j]) {
            i--;
        } else {
            j--;
        }
    }
    reverse(ans.begin(), ans.end());
    return ans;
}
```
{{% /tab %}}
{{< /tabs >}}

### Оптимизация памяти

Пусть нас интересует только длина НОП, тогда можно обойтись $O(\min(m, n))$ дополнительной памяти. При вычислении $i$-й строки таблицы мы используем только $i$-ю и $(i-1)$-ю строки, поэтому все предыдущие строки можно не хранить.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def lcs_length_opt(a: list, b: list) -> int:
    """O(min(m, n)) памяти."""
    n, m = len(a), len(b)
    if n < m:
        a, b = b, a
        n, m = m, n
    l = [[0] * (m + 1) for _ in range(2)]
    for i in range(1, n + 1):
        cur, prev = i % 2, 1 - i % 2
        for j in range(1, m + 1):
            l[cur][j] = max(l[prev][j], l[cur][j-1])
            if a[i-1] == b[j-1]:
                l[cur][j] = max(l[cur][j], l[prev][j-1] + 1)
    return l[n % 2][m]
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
int lcsLengthOpt(vector<int> a, vector<int> b) {
    int n = a.size(), m = b.size();
    if (n < m) { swap(a, b); swap(n, m); }
    vector<vector<int>> l(2, vector<int>(m + 1, 0));
    for (int i = 1; i <= n; i++) {
        int cur = i % 2, prev = 1 - cur;
        fill(l[cur].begin(), l[cur].end(), 0);
        for (int j = 1; j <= m; j++) {
            l[cur][j] = max(l[prev][j], l[cur][j-1]);
            if (a[i-1] == b[j-1])
                l[cur][j] = max(l[cur][j], l[prev][j-1] + 1);
        }
    }
    return l[n % 2][m];
}
```
{{% /tab %}}
{{< /tabs >}}

>[!props]
>Алгоритм DP для НОП работает за $\Theta(nm)$ в худшем случае. Задача тесно связана с [расстоянием Левенштейна]({{% relref "basics/dynamic_programming/levenshtein_distance" %}}) и является основой [алгоритма Хиршберга]({{% relref "basics/dynamic_programming/hirschbergs_algorithm" %}}).
