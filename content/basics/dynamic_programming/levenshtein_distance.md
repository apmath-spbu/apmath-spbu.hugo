---
linkTitle: "15.2. Расстояние Левенштейна"
title: "15.2. Расстояние Левенштейна"
date: 2026-04-25T09:30:00+03:00
weight: 20
draft: false
---

>[!def]
>**Расстояние Левенштейна** (_редакционное расстояние_, _edit distance_) между двумя последовательностями — это минимальное количество операций **вставки**, **удаления** и **замены** одного символа, с помощью которых можно из одной последовательности получить другую.

Расстояние Левенштейна между $a_{1}, \ldots, a_{n}$ и $b_{1}, \ldots, b_{m}$ можно вычислить алгоритмом, практически полностью совпадающим с алгоритмом поиска [НОП]({{% relref "basics/dynamic_programming/longest_common_subsequence" %}}): пусть $d[i, j]$ — расстояние Левенштейна между последовательностями $a_{1}, \ldots, a_{i}$ и $b_{1}, \ldots, b_{j}$. Тогда $d[i, 0]=i$, $d[0, j]=j$, а при $i, j>0$ верно

$$
d[i, j]=\min \left\{\begin{array}{l}
d[i-1, j]+1 \\
d[i, j-1]+1 \\
d[i-1, j-1]+\chi\left(a_{i}, b_{j}\right)
\end{array}\right.
$$

где $\chi(x, y)=0$ при $x=y$, $\chi(x, y)=1$ иначе. Первый случай соответствует удалению $a_{i}$, второй — вставке в последовательность $a$ символа $b_{j}$ после $a_{i}$, третий — замене $a_{i}$ на $b_{j}$ (или бездействию в случае $a_{i}=b_{j}$).

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def edit_distance(a: list, b: list) -> list[list[int]]:
    """Возвращает таблицу d[i][j] — расстояние Левенштейна a[:i] и b[:j]."""
    n, m = len(a), len(b)
    d = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(n + 1):
        d[i][0] = i
    for j in range(m + 1):
        d[0][j] = j
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            d[i][j] = min(d[i-1][j] + 1, d[i][j-1] + 1)
            cost = 0 if a[i-1] == b[j-1] else 1
            d[i][j] = min(d[i][j], d[i-1][j-1] + cost)
    return d
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
using namespace std;

// Возвращает таблицу d[i][j] — расстояние Левенштейна a[0..i) и b[0..j)
vector<vector<int>> editDistance(vector<int>& a, vector<int>& b) {
    int n = a.size(), m = b.size();
    vector<vector<int>> d(n + 1, vector<int>(m + 1, 0));
    for (int i = 0; i <= n; i++) d[i][0] = i;
    for (int j = 0; j <= m; j++) d[0][j] = j;
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            d[i][j] = min(d[i-1][j] + 1, d[i][j-1] + 1);
            int cost = (a[i-1] == b[j-1]) ? 0 : 1;
            d[i][j] = min(d[i][j], d[i-1][j-1] + cost);
        }
    return d;
}
```
{{% /tab %}}
{{< /tabs >}}

Восстановление ответа делается полностью аналогично восстановлению ответа в алгоритме поиска НОП. Если требуется найти лишь расстояние, но не последовательность действий, то снова достаточно $O(\min(m, n))$ дополнительной памяти.

Значения $d$ для последовательностей $2,1,2,3,1,2$ и $2,3,2,2,1$:

$$
\begin{array}{|cc|c|c|c|c|c|c|}
\hline & & & \color{blue}{2} & \color{blue}{3} & \color{blue}{2} & \color{blue}{2} & \color{blue}{1} \\
                      &   & 0 & 1 & 2 & 3 & 4 & 5 \\
\hline                & 0 & 0 & 1 & 2 & 3 & 4 & 5 \\
\hline\color{blue}{2} & 1 & 1 & 0 & 1 & 2 & 3 & 4 \\
\hline\color{blue}{1} & 2 & 2 & 1 & 1 & 2 & 3 & 4 \\
\hline\color{blue}{2} & 3 & 3 & 2 & 2 & 1 & 2 & 3 \\
\hline\color{blue}{3} & 4 & 4 & 3 & 2 & 2 & 2 & 3 \\
\hline\color{blue}{1} & 5 & 5 & 4 & 3 & 3 & 3 & 2 \\
\hline\color{blue}{2} & 6 & 6 & 5 & 4 & 3 & 3 & 3 \\
\hline
\end{array}
$$

Последовательность операций, соответствующая расстоянию Левенштейна:

$$
\begin{array}{|cccccc|}
\hline 2 & \color{blue}{1} & 2 & 3 & 1 & 2 \\
\hline 2 & \color{blue}{3} & 2 & \color{blue}{3} & 1 & 2 \\
\hline 2 & 3 & 2 & \color{blue}{2} & 1 & \color{blue}{2} \\
\hline 2 & 3 & 2 & 2 & 1 & \\
\hline
\end{array}
$$

>[!props]
>Расстояние Левенштейна применяется в системах проверки орфографии, сравнении биологических последовательностей ДНК, системах diff для сравнения файлов, а также в алгоритмах нечёткого поиска строк.
