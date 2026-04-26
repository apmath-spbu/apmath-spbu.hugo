---
linkTitle: "15. Динамическое программирование"
title: "15. Динамическое программирование"
date: 2026-04-25T09:30:00+03:00
weight: 160
draft: false
---

Динамическое программирование — один из наиболее мощных методов алгоритмического проектирования, позволяющий решать задачи, в которых наивный полный перебор работает экспоненциально долго.

>[!def]
>**Динамическое программирование** (_dynamic programming, DP_) — метод решения задачи путём разбиения её на **состояния** (подзадачи), вычисляемые с помощью **переходов** из более простых состояний. Состояния вычисляются в топологическом порядке графа зависимостей: каждое состояние решается ровно один раз, результат запоминается и переиспользуется.

>[!props]
>Ключевые компоненты динамического программирования:
>1. **Состояния** — описание подзадачи (например, $\operatorname{dist}[v]$, $l[i,j]$, $k[\text{mask}, v]$).
>2. **Переходы** — формула пересчёта состояния через предыдущие (рёбра графа зависимостей).
>3. **Начальные состояния** — база, значения которой известны явно.
>4. **Порядок вычислений** — топологическая сортировка графа зависимостей (циклов быть не должно).
>5. **Восстановление ответа** — запоминание оптимального перехода для каждого состояния, либо повторный перебор переходов.

## Поиск кратчайшего пути в ациклическом ориентированном графе

Пусть перед нами стоит задача поиска кратчайших путей от вершины $s$ до всех остальных вершин в [ациклическом ориентированном графе]({{% relref "basics/graphs/graph_depth_search" %}}). Конечно, можно воспользоваться одним из уже изученных алгоритмов. Есть, однако, и более простое решение с линейным временем работы.

Для любой вершины $v \neq s$ верно следующее равенство:
$$
\operatorname{dist}[v]=\min \left\{\operatorname{dist}[u]+w_{e}: e=(u, v) \in E\right\}
$$

Будем перебирать вершины в порядке топологической сортировки. Тогда все значения $\operatorname{dist}$, встречающиеся в выражении справа, к моменту рассмотрения вершины $v$ уже будут найдены.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def dag_shortest_path(n: int, s: int,
                      in_edges: list[list[tuple[int, int]]],
                      top_order: list[int]) -> list[float]:
    """
    in_edges[v] = [(u, w), ...] — входящие рёбра вершины v.
    top_order — вершины в порядке топологической сортировки.
    """
    dist = [float('inf')] * n
    dist[s] = 0
    for v in top_order:
        if v == s:
            continue
        for u, w in in_edges[v]:
            if dist[u] + w < dist[v]:
                dist[v] = dist[u] + w
    return dist
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <climits>
using namespace std;

// in_edges[v] = {(u, w), ...} — входящие рёбра вершины v
// top_order — вершины в порядке топологической сортировки
vector<long long> dagShortestPath(int n, int s,
    vector<vector<pair<int,int>>>& inEdges,
    vector<int>& topOrder) {
    const long long INF = 1e18;
    vector<long long> dist(n, INF);
    dist[s] = 0;
    for (int v : topOrder) {
        if (v == s) continue;
        for (auto [u, w] : inEdges[v])
            if (dist[u] != INF)
                dist[v] = min(dist[v], dist[u] + (long long)w);
    }
    return dist;
}
```
{{% /tab %}}
{{< /tabs >}}

Алгоритм рассматривает подзадачи вычисления $\operatorname{dist}[v]$ в порядке увеличения сложности; каждую текущую подзадачу он сводит к нескольким подзадачам попроще, которые уже решены.

## Метод динамического программирования

Метод динамического программирования так и устроен: задача, которую нужно решить, сводится к подзадачам попроще, те — к подзадачам ещё попроще, и так далее. После этого все подзадачи решаются в правильном порядке. Какой порядок правильный? Построим на подзадачах ориентированный граф: вершины — это подзадачи, а ребро из $a$ в $b$ есть, если для решения подзадачи $b$ требуется сначала решить $a$. Тогда правильный порядок — это топологическая сортировка этого графа. Этот граф, как правило, не строится явно; правильный порядок часто виден сразу.

На самом деле мы уже встречались с методом динамического программирования: полиномиальный алгоритм вычисления чисел Фибоначчи, [алгоритмы Флойда и Беллмана-Форда]({{% relref "basics/graphs/graph_shortest_path_algos" %}}), решето Эратосфена — все эти алгоритмы можно интерпретировать как динамическое программирование.

## Способ вычисления переходов

Во многих задачах переходы можно вычислять двумя способами: «вперёд» и «назад». Так, при поиске кратчайшего пути в ациклическом ориентированном графе вместо того, чтобы смотреть «назад» на входящие в вершину рёбра и пересчитывать текущее состояние через предыдущие, мы могли бы смотреть «вперёд» на исходящие из вершины рёбра и пересчитывать следующие состояния через текущее.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def dag_shortest_path_forward(n: int, s: int,
                               edges: list[list[tuple[int, int]]],
                               top_order: list[int]) -> list[float]:
    """edges[v] = [(u, w), ...] — исходящие рёбра вершины v."""
    dist = [float('inf')] * n
    dist[s] = 0
    for v in top_order:
        if dist[v] == float('inf'):
            continue
        for u, w in edges[v]:
            dist[u] = min(dist[u], dist[v] + w)
    return dist
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
vector<long long> dagShortestPathFwd(int n, int s,
    vector<vector<pair<int,int>>>& edges,
    vector<int>& topOrder) {
    const long long INF = 1e18;
    vector<long long> dist(n, INF);
    dist[s] = 0;
    for (int v : topOrder) {
        if (dist[v] == INF) continue;
        for (auto [u, w] : edges[v])
            dist[u] = min(dist[u], dist[v] + (long long)w);
    }
    return dist;
}
```
{{% /tab %}}
{{< /tabs >}}

Иногда оказывается, что один из способов по тем или иным причинам удобнее другого. Рассмотрим для примера такую модельную задачу: пусть $dp[1]=1$, и мы хотим для каждого $x$ от 2 до $n$ вычислить
$$
dp[x]=\sum_{\substack{d < x \\ d \mid x}} dp[d].
$$

Для того, чтобы считать переходы назад, нам придётся найти все делители каждого числа. Считать же переходы вперёд очень просто: для фиксированного $d$ значение $dp[d]$ нужно добавить ко всем кратным $d$, не большим $n$. Суммарное время работы составит $O\!\left(\sum_{d=1}^{n} n/d\right) = O(n \log n)$.

## Восстановление ответа

В задаче о кратчайшем пути может требоваться найти не просто длину пути, но и сам путь. Есть два стандартных способа восстановления ответа.

Первый: для каждого состояния запомнить, из какого состояния в него был сделан оптимальный переход. Тогда, пользуясь запомненными ссылками, можно откатиться от конечного состояния к начальному и восстановить весь путь.

Второй: ничего не запоминать, а для нахождения оптимального перехода просто перебрать все переходы заново.

## Ленивое динамическое программирование

Вычисление переходов назад можно делать лениво: напишем рекурсивную функцию, делающую рекурсивные вызовы от состояний, которые нужны для вычисления текущего. При этом будем запоминать уже вычисленные значения. Пример ленивого решения задачи поиска кратчайшего пути в ациклическом ориентированном графе:

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
import sys
sys.setrecursionlimit(10**6)

def make_find_dist(in_edges: list[list[tuple[int, int]]]):
    n = len(in_edges)
    dist = [-1.0] * n

    def find_dist(v: int) -> float:
        if dist[v] != -1:
            return dist[v]
        dist[v] = float('inf')
        for u, w in in_edges[v]:
            dist[v] = min(dist[v], find_dist(u) + w)
        return dist[v]

    return find_dist, dist

# Использование:
# find_dist, dist = make_find_dist(in_edges)
# dist[s] = 0
# for v in range(n):
#     find_dist(v)
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <functional>
#include <climits>
using namespace std;

vector<long long> lazyDAGShortestPath(int n, int s,
    vector<vector<pair<int,int>>>& inEdges) {
    const long long INF = 1e18, UNVISITED = -1;
    vector<long long> dist(n, UNVISITED);
    dist[s] = 0;

    function<long long(int)> findDist = [&](int v) -> long long {
        if (dist[v] != UNVISITED) return dist[v];
        dist[v] = INF;
        for (auto [u, w] : inEdges[v])
            dist[v] = min(dist[v], findDist(u) + w);
        return dist[v];
    };

    for (int v = 0; v < n; v++) findDist(v);
    return dist;
}
```
{{% /tab %}}
{{< /tabs >}}

>[!props]
>Ленивая версия полезна, когда нужно вычислить значение не всех состояний, а одного конкретного. Модельный пример: вычисление $\gcd(a, b)$ через соотношение $\gcd(a, b) = \gcd(b, a \bmod b)$ требует лишь $O(\log n)$ состояний, поэтому ленивый подход значительно эффективнее полного вычисления всей таблицы.

### Задачи

Далее рассматриваются примеры задач и их решения методом динамического программирования:

### Сводка задач и алгоритмов

| Задача | Время | Память |
|--------|-------|--------|
| [15.1. Наибольшая общая подпоследовательность]({{% relref "basics/dynamic_programming/longest_common_subsequence" %}}) | $O(nm)$ | $O(nm)$ / $O(\min(m,n))$ |
| [15.2. Расстояние Левенштейна]({{% relref "basics/dynamic_programming/levenshtein_distance" %}}) | $O(nm)$ | $O(nm)$ |
| [15.3. Алгоритм Хиршберга]({{% relref "basics/dynamic_programming/hirschbergs_algorithm" %}}) | $O(nm)$ | $O(m + \log n)$ |
| [15.4. Наибольшая возрастающая подпоследовательность]({{% relref "basics/dynamic_programming/longest_increasing_subsequence" %}}) | $O(n \log n)$ | $O(n)$ |
| [15.5. Задача о рюкзаке]({{% relref "basics/dynamic_programming/knapsack_problem" %}}) | $O(nW)$ | $O(W)$ |
| [15.6. Произведение матриц]({{% relref "basics/dynamic_programming/matrices_multiplication" %}}) | $O(n^3)$ | $O(n^2)$ |
| [15.7. НМВ в дереве]({{% relref "basics/dynamic_programming/independent_set_of_maximum_weight_in_tree" %}}) | $O(V+E)$ | $O(V)$ |
| [15.8. Задача коммивояжёра]({{% relref "basics/dynamic_programming/travelling_salesman_problem" %}}) | $O(2^n n^2)$ | $O(2^n n)$ |
| [15.9. Генерация по объекту]({{% relref "basics/dynamic_programming/generate_number_by_object" %}}) | $O(n^2)$ | $O(n)$ |
| [15.10. Рекуррентные соотношения]({{% relref "basics/dynamic_programming/recurrence_relations_solving_by_raising_matrix_to_power" %}}) | $O(k^3 \log n)$ | $O(k^2)$ |
