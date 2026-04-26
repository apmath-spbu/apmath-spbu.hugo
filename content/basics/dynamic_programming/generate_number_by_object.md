---
linkTitle: "15.9. Генерация номера по объекту"
title: "15.9. Генерация номера по объекту и объекта по номеру"
date: 2026-04-25T09:30:00+03:00
draft: false
weight: 90
---

Научимся сопоставлять комбинаторному объекту (например, перестановке) его номер в лексикографически упорядоченном списке всех объектов того же типа; или, наоборот, генерировать объект по его номеру.

Это бывает полезно, если хочется закодировать объект как можно меньшим количеством бит, а также если хочется использовать объект в качестве индекса массива (например, если при применении метода динамического программирования состояние описывается комбинаторным объектом).

>[!def]
>**Факторадическая система счисления**: номер перестановки $p_1, \ldots, p_n$ в лексикографическом порядке — это сумма $\sum_{k=1}^{n} c_k \cdot (n-k)!$, где $c_k$ — количество элементов $p_{k+1}, \ldots, p_n$, меньших $p_k$. Всего перестановок длины $n$ ровно $n!$.

## Номер по перестановке

Как вычислить номер перестановки $p_{1}, \ldots, p_{n}$ чисел $1, \ldots, n$ в списке всех перестановок длины $n$, упорядоченных лексикографически? Например, у нас есть упорядоченный лексикографически список перестановок длины 3:

$$
\begin{array}{|l|l|}
\hline 0 & 1,2,3 \\
\hline 1 & 1,3,2 \\
\hline 2 & 2,1,3 \\
\hline 3 & 2,3,1 \\
\hline 4 & 3,1,2 \\
\hline 5 & 3,2,1 \\
\hline
\end{array}
$$

Номер перестановки $p$ — это количество перестановок, лексикографически меньших $p$. Пусть $q$ — одна из таких перестановок. Тогда $q_1 = p_1, \ldots, q_{k-1} = p_{k-1}$, $x = q_k < p_k$ для некоторого $k$. При этом для фиксированных $k$, $x < p_k$ существует $(n-k)!$ различных перестановок $q$ (оставшиеся $n-k$ чисел могут идти в любом порядке).

Алгоритм: переберём $k$ — позицию самого левого несовпадения $q$ и $p$, переберём $x < p_k$ — значение $q_k$, просуммируем количество перестановок $q$ по всем таким $k, x$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def perm_to_num(p: list[int], factorial: list[int]) -> int:
    """
    p — перестановка чисел 1..n (0-индексированная: p[0]..p[n-1]).
    factorial[k] = k!
    Возвращает лексикографический номер перестановки.
    """
    n = len(p)
    used = [False] * (n + 1)
    num = 0
    for k in range(n):
        for x in range(1, p[k]):
            if not used[x]:
                num += factorial[n - 1 - k]
        used[p[k]] = True
    return num
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
using namespace std;

// p — перестановка 1..n, factorial[k] = k!
long long permToNum(vector<int>& p, vector<long long>& factorial) {
    int n = p.size();
    vector<bool> used(n + 1, false);
    long long num = 0;
    for (int k = 0; k < n; k++) {
        for (int x = 1; x < p[k]; x++)
            if (!used[x])
                num += factorial[n - 1 - k];
        used[p[k]] = true;
    }
    return num;
}
```
{{% /tab %}}
{{< /tabs >}}

## Правильные скобочные последовательности

>[!def]
>**Правильная скобочная последовательность** (ПСП) из $2n$ символов — это последовательность скобок `(` и `)`, в которой баланс (разность числа открывающих и закрывающих) любого префикса неотрицателен, а баланс всей последовательности равен нулю. Всего ПСП длины $2n$ ровно $C_n = \frac{1}{n+1}\binom{2n}{n}$ (числа Каталана).

Ниже представлен лексикографически упорядоченный список ПСП длины 8:

$$
\begin{array}{|c|c|c|c|}
\hline 0 & (((()))) & 7 & (())(()) \\
\hline 1 & ((()())) & 8 & (())()() \\
\hline 2 & ((())()) & 9 & ()((())) \\
\hline 3 & ((()))() & 10 & ()(()()) \\
\hline 4 & (()(())) & 11 & ()(())() \\
\hline 5 & (()()()) & 12 & ()()(()) \\
\hline 6 & (()())() & 13 & ()()()() \\
\hline
\end{array}
$$

## Номер по ПСП

Будем искать номер ПСП $a$ длины $2n$ тем же методом: пусть $b$ лексикографически меньше $a$, причём $b_1 = a_1, \ldots, b_{k-1} = a_{k-1}$; `(` $= b_k < a_k =$ `)`. Сколько существует таких ПСП $b$?

Поскольку баланс каждого префикса $b$ неотрицателен, баланс каждого суффикса $b$ неположителен. Тогда, если перевернуть суффикс $b_{k+1}, \ldots, b_{2n}$ и заменить скобки на противоположные, получится скобочная последовательность длины $2n - k$, баланс любого префикса которой неотрицателен, а баланс её целиком совпадает с балансом $b_1, \ldots, b_k$. Предподсчитаем количество таких последовательностей для каждой длины и каждого значения баланса динамическим программированием.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def build_cnt(maxn: int) -> list[list[int]]:
    """
    cnt[l][b] = число скобочных последовательностей длины l и баланса b,
    у которых все префиксы имеют неотрицательный баланс.
    """
    cnt = [[0] * (maxn + 1) for _ in range(2 * maxn + 1)]
    cnt[0][0] = 1
    for l in range(1, 2 * maxn + 1):
        for b in range(l + 1):
            cnt[l][b] = cnt[l-1][b+1] if b + 1 <= l else 0  # ')'
            if b > 0:
                cnt[l][b] += cnt[l-1][b-1]                  # '('
    return cnt

def psp_to_num(a: str, cnt: list[list[int]]) -> int:
    """Возвращает лексикографический номер ПСП a."""
    n = len(a) // 2
    num = 0
    balance = 0
    for k, ch in enumerate(a):
        remaining = len(a) - k - 1
        if ch == ')':
            num += cnt[remaining][balance + 1]
            balance -= 1
        else:
            balance += 1
    return num
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
using namespace std;

// cnt[l][b] = число допустимых скобочных последовательностей длины l и баланса b
vector<vector<long long>> buildCnt(int maxN) {
    int sz = 2 * maxN + 1;
    vector<vector<long long>> cnt(sz, vector<long long>(sz + 1, 0));
    cnt[0][0] = 1;
    for (int l = 1; l < sz; l++)
        for (int b = 0; b <= l; b++) {
            if (b + 1 <= l) cnt[l][b] += cnt[l-1][b+1];  // ')'
            if (b > 0)      cnt[l][b] += cnt[l-1][b-1];   // '('
        }
    return cnt;
}

long long pspToNum(const string& a, vector<vector<long long>>& cnt) {
    int m = a.size();
    long long num = 0;
    int balance = 0;
    for (int k = 0; k < m; k++) {
        int remaining = m - k - 1;
        if (a[k] == ')') {
            num += cnt[remaining][balance + 1];
            balance--;
        } else {
            balance++;
        }
    }
    return num;
}
```
{{% /tab %}}
{{< /tabs >}}

## Перестановка по номеру

Вернёмся к перестановкам и решим обратную задачу: найти перестановку с заданным номером `num`.

Для любого $x$ от 1 до $n$ существует $(n-1)!$ перестановок, начинающихся с $x$. Тогда первый символ искомой перестановки — минимальное $x$ такое, что накопленное число не превышает `num`. Далее повторяем те же рассуждения для следующих позиций.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def num_to_perm(num: int, n: int, factorial: list[int]) -> list[int]:
    """Возвращает перестановку 1..n с лексикографическим номером num."""
    used = [False] * (n + 1)
    p = []
    for k in range(n):
        for x in range(1, n + 1):
            if used[x]:
                continue
            if num < factorial[n - 1 - k]:
                p.append(x)
                used[x] = True
                break
            num -= factorial[n - 1 - k]
    return p
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
vector<int> numToPerm(long long num, int n, vector<long long>& factorial) {
    vector<bool> used(n + 1, false);
    vector<int> p;
    for (int k = 0; k < n; k++) {
        for (int x = 1; x <= n; x++) {
            if (used[x]) continue;
            if (num < factorial[n - 1 - k]) {
                p.push_back(x);
                used[x] = true;
                break;
            }
            num -= factorial[n - 1 - k];
        }
    }
    return p;
}
```
{{% /tab %}}
{{< /tabs >}}

## ПСП по номеру

Будем ставить на очередную позицию открывающую скобку, если номер ПСП меньше количества способов закончить ПСП после постановки этой скобки; иначе ставим закрывающую скобку и уменьшаем номер на количество «пропущенных» ПСП.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def num_to_psp(num: int, n: int,
               cnt: list[list[int]]) -> str:
    """Возвращает ПСП длины 2n с лексикографическим номером num."""
    result = []
    balance = 0
    for k in range(2 * n):
        remaining = 2 * n - k - 1
        # сколько ПСП начинается с '(' на этой позиции?
        ways_open = cnt[remaining][balance + 1] if balance + 1 <= remaining else 0
        if num < ways_open:
            result.append('(')
            balance += 1
        else:
            num -= ways_open
            result.append(')')
            balance -= 1
    return ''.join(result)
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
string numToPSP(long long num, int n,
                vector<vector<long long>>& cnt) {
    string result;
    int balance = 0;
    for (int k = 0; k < 2 * n; k++) {
        int remaining = 2 * n - k - 1;
        long long waysOpen = (balance + 1 <= remaining)
                             ? cnt[remaining][balance + 1] : 0;
        if (num < waysOpen) {
            result += '(';
            balance++;
        } else {
            num -= waysOpen;
            result += ')';
            balance--;
        }
    }
    return result;
}
```
{{% /tab %}}
{{< /tabs >}}

>[!props]
>Тот же метод (перебрать позицию и значение первого несовпадения, просуммировать количество способов «закончить» объект) работает с любым комбинаторным объектом, для которого можно эффективно подсчитать количество объектов с фиксированным префиксом.
