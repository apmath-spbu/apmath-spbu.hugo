---
linkTitle: "15.6. Произведение матриц"
title: "15.6. Оптимальный порядок перемножения матриц"
date: 2026-04-25T09:30:00+03:00
weight: 60
draft: false
---

>[!def]
>**Задача об оптимальном порядке перемножения матриц** (_matrix chain multiplication_): дано $n$ матриц $A_1 \times \cdots \times A_n$, где $A_i$ имеет размер $m_{i-1} \times m_i$. Матрицы умножаются по определению: произведение матриц $m \times n$ и $n \times p$ требует $O(mnp)$ действий. Требуется выбрать порядок умножений (расстановку скобок), минимизирующий суммарное число действий.

Пусть, например, мы перемножаем матрицы размеров $100 \times 10$, $10 \times 20$ и $20 \times 2$. Порядок $(A_1 \times A_2) \times A_3$ требует $100 \cdot 10 \cdot 20 + 100 \cdot 20 \cdot 2 = 24000$ действий, а порядок $A_1 \times (A_2 \times A_3)$ — лишь $10 \cdot 20 \cdot 2 + 100 \cdot 10 \cdot 2 = 2400$.

### Динамическое программирование по подотрезкам

Посмотрим на последнюю операцию умножения: мы перемножим $A_1 \times \cdots \times A_j$ и $A_{j+1} \times \cdots \times A_n$ для некоторого $j$. Операции до этого соответствуют оптимальному вычислению этих двух матриц — получаются две независимые подзадачи для **подотрезков** исходной последовательности.

Пусть $c[l, r]$ — минимальное количество операций, необходимое для вычисления $A_l \times \cdots \times A_r$. Начальные состояния: $c[i, i] = 0$. Переход — перебор последней пары умножаемых матриц:
$$
c[l, r] = \min_{l \leqslant i < r} \bigl(c[l, i] + c[i+1, r] + m_{l-1} \cdot m_i \cdot m_r\bigr).
$$

Состояния рассматриваем в порядке увеличения длины подотрезка. Получаем решение за $O(n^3)$, $O(n^2)$ дополнительной памяти.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def matrix_chain(m: list[int]) -> tuple[list[list[int]], list[list[int]]]:
    """
    m[i] — размеры: матрица A_i имеет размер m[i-1] x m[i].
    Возвращает (c, split), где c[l][r] — минимум операций,
    split[l][r] — оптимальная точка разбиения.
    """
    n = len(m) - 1
    INF = float('inf')
    c = [[INF] * (n + 1) for _ in range(n + 1)]
    split = [[0] * (n + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        c[i][i] = 0
    for s in range(1, n):          # длина подотрезка
        for l in range(1, n - s + 1):
            r = l + s
            for i in range(l, r):
                cost = c[l][i] + c[i+1][r] + m[l-1] * m[i] * m[r]
                if cost < c[l][r]:
                    c[l][r] = cost
                    split[l][r] = i
    return c, split
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <climits>
#include <algorithm>
using namespace std;

// m[i] — размеры: A_i имеет размер m[i-1] x m[i]
// Возвращает (c, split): c[l][r] = минимум операций,
// split[l][r] = оптимальная точка разбиения
pair<vector<vector<long long>>, vector<vector<int>>>
matrixChain(vector<int>& m) {
    int n = m.size() - 1;
    vector<vector<long long>> c(n + 1, vector<long long>(n + 1, LLONG_MAX));
    vector<vector<int>> sp(n + 1, vector<int>(n + 1, 0));
    for (int i = 1; i <= n; i++) c[i][i] = 0;
    for (int s = 1; s < n; s++)
        for (int l = 1; l + s <= n; l++) {
            int r = l + s;
            for (int i = l; i < r; i++) {
                long long cost = c[l][i] + c[i+1][r]
                               + (long long)m[l-1] * m[i] * m[r];
                if (cost < c[l][r]) {
                    c[l][r] = cost;
                    sp[l][r] = i;
                }
            }
        }
    return {c, sp};
}
```
{{% /tab %}}
{{< /tabs >}}

>[!props]
>Восстановление ответа (оптимального порядка скобок) делается стандартными методами по массиву `split`. Эту задачу умеют решать за $O(n \log n)$ (Hu, Shing, 1984). Тот же подход «DP по подотрезкам» применяется в задачах об [оптимальном двоичном дереве поиска]({{% relref "basics/binary_trees/bst_operations" %}}) и разборе контекстно-свободных грамматик. Задача тесно связана с [возведением матрицы в степень]({{% relref "basics/dynamic_programming/recurrence_relations_solving_by_raising_matrix_to_power" %}}).
