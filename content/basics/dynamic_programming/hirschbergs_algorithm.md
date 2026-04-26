---
linkTitle: "15.3. Алгоритм Хиршберга"
title: "15.3. Алгоритм Хиршберга"
date: 2026-04-25T09:30:00+03:00
weight: 30
draft: false
---

В предыдущих двух алгоритмах ([НОП]({{% relref "basics/dynamic_programming/longest_common_subsequence" %}}) и [расстояние Левенштейна]({{% relref "basics/dynamic_programming/levenshtein_distance" %}})) мы имели альтернативу: либо умеем восстанавливать ответ (используя $O(nm)$ памяти), либо можем позволить себе $O(\min(m, n))$ дополнительной памяти, но теряем возможность восстановления. Алгоритм Хиршберга позволяет восстанавливать ответ, используя $O(\min(m, n) + \log(\max(m, n)))$ дополнительной памяти. Идея алгоритма применима не только в этих двух, но и во многих других задачах.

>[!theorem]
>Алгоритм Хиршберга вычисляет НОП двух последовательностей длин $n$ и $m$ за время $O(nm)$, используя $O(m + \log n)$ дополнительной памяти.

Для определённости будем решать задачу о поиске НОП. Применим метод «разделяй и властвуй»: отдельно решим задачу для последовательностей $a_{1}, \ldots, a_{n/2}$ и $b_{1}, \ldots, b_{m}$, и для последовательностей $a_{n}, \ldots, a_{n/2+1}$ и $b_{m}, \ldots, b_{1}$. И ту, и другую задачу решим, используя $O(m)$ дополнительной памяти.

Пусть в результате $l[j]$ — длина НОП $a_{1}, \ldots, a_{n/2}$ и $b_{1}, \ldots, b_{j}$; $r[j]$ — длина НОП $a_{n}, \ldots, a_{n/2+1}$ и $b_{m}, \ldots, b_{m+1-j}$. Тогда длина НОП $a_{1}, \ldots, a_{n}$ и $b_{1}, \ldots, b_{m}$ — это максимум $l[j]+r[m-j]$ по $0 \leqslant j \leqslant m$.

Пусть максимальное значение достигается на $j_{\max}$. Сделаем рекурсивные запуски алгоритма от $a_{1}, \ldots, a_{n/2}$ и $b_{1}, \ldots, b_{j_{\max}}$ и от $a_{n/2+1}, \ldots, a_{n}$ и $b_{j_{\max}+1}, \ldots, b_{m}$, чтобы восстановить половинки ответа.

>[!prove]+
>Глубина рекурсии составит $O(\log n)$, каждый рекурсивный запуск может переиспользовать одни и те же $O(m)$ дополнительной памяти, значит, всего понадобится $O(m + \log n)$ дополнительной памяти.
>
>Осталось понять, почему оценка времени работы по-прежнему равна $O(mn)$. Посмотрим на все рекурсивные вызовы на глубине $k$. Во всех них первая последовательность имеет длину $O(n/2^k)$, а сумма длин вторых последовательностей по всем вызовам на глубине $k$ равна $m$. Значит, суммарное время работы рекурсивных вызовов на глубине $k$ равно $O(mn/2^k)$. Тогда суммарное время работы всех вызовов есть $\sum_{k} O(mn/2^k) = O(mn)$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def get_lcs_row(a: list, b: list) -> list[int]:
    """Возвращает последнюю строку таблицы НОП за O(m) памяти."""
    m = len(b)
    l = [[0] * (m + 1) for _ in range(2)]
    for i, ai in enumerate(a, 1):
        cur, prev = i % 2, 1 - i % 2
        for j in range(1, m + 1):
            l[cur][j] = max(l[prev][j], l[cur][j-1])
            if ai == b[j-1]:
                l[cur][j] = max(l[cur][j], l[prev][j-1] + 1)
    return l[len(a) % 2]

def hirschberg(a: list, b: list) -> list:
    """Возвращает НОП списков a и b, используя O(m + log n) памяти."""
    n, m = len(a), len(b)
    if n == 0:
        return []
    if n == 1:
        return [a[0]] if a[0] in b else []
    mid = n // 2
    l = get_lcs_row(a[:mid], b)
    r = get_lcs_row(a[mid:][::-1], b[::-1])
    j_max = max(range(m + 1), key=lambda j: l[j] + r[m - j])
    return hirschberg(a[:mid], b[:j_max]) + hirschberg(a[mid:], b[j_max:])
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
#include <numeric>
using namespace std;

vector<int> getLCSRow(vector<int>& a, vector<int>& b) {
    int n = a.size(), m = b.size();
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
    return l[n % 2];
}

vector<int> hirschberg(vector<int> a, vector<int> b) {
    int n = a.size(), m = b.size();
    if (n == 0) return {};
    if (n == 1) {
        for (int x : b) if (x == a[0]) return {a[0]};
        return {};
    }
    int mid = n / 2;
    vector<int> aL(a.begin(), a.begin() + mid);
    vector<int> aR(a.begin() + mid, a.end());
    vector<int> bRev(b.rbegin(), b.rend());
    vector<int> aRRev(aR.rbegin(), aR.rend());

    auto l = getLCSRow(aL, b);
    auto r = getLCSRow(aRRev, bRev);

    int jMax = 0;
    for (int j = 1; j <= m; j++)
        if (l[j] + r[m-j] > l[jMax] + r[m-jMax])
            jMax = j;

    vector<int> bL(b.begin(), b.begin() + jMax);
    vector<int> bR(b.begin() + jMax, b.end());
    auto left  = hirschberg(aL, bL);
    auto right = hirschberg(aR, bR);
    left.insert(left.end(), right.begin(), right.end());
    return left;
}
```
{{% /tab %}}
{{< /tabs >}}

### Альтернативный способ

Другой способ, работающий по тем же причинам: будем действовать как обычно при восстановлении ответа, но запоминать будем не предыдущее состояние, а состояние на оптимальном пути от начального с $i = n/2$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def hirschberg_alt(a: list, b: list) -> list:
    """Альтернативная реализация алгоритма Хиршберга."""
    n, m = len(a), len(b)
    if n == 0:
        return []
    if n == 1:
        return [a[0]] if a[0] in b else []

    mid = n // 2
    # l[cur][j] = длина НОП; mid_j[j] = позиция в b на половине пути
    INF = -1
    l = [[0] * (m + 1) for _ in range(2)]
    mid_j = [[0] * (m + 1) for _ in range(2)]

    for i in range(1, n + 1):
        cur, prev = i % 2, 1 - i % 2
        for j in range(m + 1):
            l[cur][j] = l[prev][j]
            mid_j[cur][j] = mid_j[prev][j]
            if j > 0 and l[cur][j-1] > l[cur][j]:
                l[cur][j] = l[cur][j-1]
                mid_j[cur][j] = mid_j[cur][j-1]
            if i > 0 and j > 0 and a[i-1] == b[j-1] and l[prev][j-1] + 1 > l[cur][j]:
                l[cur][j] = l[prev][j-1] + 1
                mid_j[cur][j] = mid_j[prev][j-1]
            if i == mid:
                mid_j[cur][j] = j

    j_max = mid_j[n % 2][m]
    return hirschberg(a[:mid], b[:j_max]) + hirschberg(a[mid:], b[j_max:])
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
// Альтернативная реализация через запоминание mid-позиции
// Основная идея: при i == n/2 запомнить текущую позицию j как mid_j
// (реализация аналогична основной версии, см. выше)
```
{{% /tab %}}
{{< /tabs >}}
