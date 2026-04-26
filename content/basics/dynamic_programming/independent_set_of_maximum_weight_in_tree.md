---
linkTitle: "15.7. Независимое множество в дереве"
title: "15.7. Независимое множество максимального веса в дереве"
date: 2026-04-25T09:30:00+03:00
weight: 70
draft: false
---

>[!def]
>**Независимое множество** (_independent set_) графа — множество вершин, никакие две из которых не соединены ребром. **Задача о максимальном независимом множестве** (_maximum weight independent set_): дано дерево, каждая вершина $v$ которого имеет вес $w_v$; найти независимое множество максимального суммарного веса.

>[!props]
>На общем графе задача о максимальном независимом множестве NP-трудна. На деревьях она решается за линейное время динамическим программированием по поддеревьям.

✍️ Невзвешенная версия (все веса равны единице) решается жадным алгоритмом.

### Динамическое программирование по поддеревьям

Выберем любую вершину $r$ в качестве корня дерева. Каждой вершине $v$ соответствует подзадача поиска независимого множества максимального веса в поддереве $v$; обозначим искомое множество за $I_v$. Как выразить решение для $v$ через подзадачи попроще?

- Если $v$ **не входит** в $I_v$: $I_v$ = объединение $I_u$ по всем детям $u$ вершины $v$.
- Если $v$ **входит** в $I_v$: никто из детей $v$ в $I_v$ входить не может. Тогда $I_v = \{v\}$ плюс объединение $I_u$ по всем «внукам» (детям детей) $v$.

Пусть $I[v] = \sum_{u \in I_v} w_u$ и $J[v] = \sum_{u\text{ — ребёнок }v} I[u]$.

Тогда:
$$
I[v] = \max\!\left(J[v],\; w_v + \sum_{u\text{ — ребёнок }v} J[u]\right).
$$

Все значения $I$, $J$ легко вычислить одним запуском [DFS]({{% relref "basics/graphs/graph_depth_search" %}}) из $r$. Получаем решение за $O(V+E)$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def max_weight_independent_set(n: int, w: list[int],
                                adj: list[list[int]]) -> int:
    """
    n — число вершин, w[v] — вес вершины v.
    adj[v] — список соседей. Корень = 0.
    Возвращает максимальный вес независимого множества.
    """
    I = [0] * n
    J = [0] * n

    def dfs(v: int, parent: int):
        I[v] = w[v]
        J[v] = 0
        for u in adj[v]:
            if u == parent:
                continue
            dfs(u, v)
            I[v] += J[u]
            J[v] += I[u]
        I[v] = max(I[v], J[v])

    dfs(0, -1)
    return I[0]
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
#include <functional>
using namespace std;

int maxWeightIS(int n, vector<int>& w, vector<vector<int>>& adj) {
    vector<int> I(n), J(n);

    function<void(int, int)> dfs = [&](int v, int par) {
        I[v] = w[v]; J[v] = 0;
        for (int u : adj[v]) {
            if (u == par) continue;
            dfs(u, v);
            I[v] += J[u];
            J[v] += I[u];
        }
        I[v] = max(I[v], J[v]);
    };

    dfs(0, -1);
    return I[0];
}
```
{{% /tab %}}
{{< /tabs >}}

### Восстановление ответа

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def restore_is(v: int, parent: int, skip: bool,
               I: list[int], J: list[int],
               adj: list[list[int]], result: list[int]):
    """
    skip=True означает, что вершина v точно не входит в ответ.
    """
    child_skip = False
    if not skip and I[v] > J[v]:  # v входит в ответ
        result.append(v)
        child_skip = True  # дети v в ответ не входят
    for u in adj[v]:
        if u == parent:
            continue
        restore_is(u, v, child_skip, I, J, adj, result)
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
void restoreIS(int v, int par, bool skip,
               vector<int>& I, vector<int>& J,
               vector<vector<int>>& adj, vector<int>& result) {
    bool childSkip = false;
    if (!skip && I[v] > J[v]) {
        result.push_back(v);
        childSkip = true;
    }
    for (int u : adj[v]) {
        if (u == par) continue;
        restoreIS(u, v, childSkip, I, J, adj, result);
    }
}
```
{{% /tab %}}
{{< /tabs >}}
