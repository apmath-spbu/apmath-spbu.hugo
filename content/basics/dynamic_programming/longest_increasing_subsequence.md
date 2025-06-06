---
title: "Наибольшая возрастающая подпоследовательность"
date: 2025-04-24T17:19:09+03:00
draft: false
weight: 40
---

Дана последовательность чисел $a_{1}, \ldots, a_{n}$. Требуется найти возрастающую подпоследовательность (такую, что каждое следующее число в ней строго больше предыдущего) максимально возможной длины - _наибольшую возрастающую подпоследовательность_ (НВП, _longest increasing subsequence_).

### Решение за $O\left(n^{2}\right)$
Пусть $l_{i}$ - максимально возможная длина возрастающей подпоследовательности, заканчивающейся в $a_{i}$. Тогда

$$
l_{i}=1+\max _{\substack{0 \leqslant j < i, a_{j} < a_{i}}} l_{j}
$$

(максимум по пустому множеству считаем равным нулю).
Ответ на задачу - максимальное значение $l_{i}$ по всем $i$. Восстановление ответа делается стандартными методами. Получаем решение за $O\left(n^{2}\right)$.
```
fill(l, 1)
for i = 1..(n - 1):
    for j = 0..(i - 1):
        if a[j] < a[i]:
            l[i] = max(l[i], l[j] + 1)
```

### Решение за $O(n \log n)$
Будем поддерживать дополнительный массив: пусть

$$
x[i, k]=\min _{\substack{j < i, l_{j}=k}} a_{j}
$$

(здесь минимум по пустому множеству - бесконечность). Тогда

$$
l_{i}=1+\max _{k: x[i, k] < a_{i}} k .
$$

Как это помогает решить задачу быстрее? Заметим, что элементы одномерного массива $x[i]$ идут в порядке возрастания: для любого $k>1$ выполняется $x[i, k-1] < x[i, k]$ (если, конечно, оба элемента не равны бесконечности). Почему это так? Если $x[i, k] \neq \infty$, то $x[i, k]=a_{j}$ для некоторого $j$ такого, что $l_{j}=k$. Существует $q < j: l_{q}=l_{j}-1=k-1$, $a_{q} < a_{j}$. Тогда $x[i, k-1] \leqslant a_{q} < a_{j}=x[i, k]$.

Поскольку элементы массива $x[i]$ идут в порядке возрастания, $l_{i}$ теперь можно найти двоичным поиском по массиву $x[i]$ за $O(\log n)$. Последнее замечание: массивы $x[i+1]$ и $x[i]$ отличаются не более, чем в одной ячейке: $x\left[i+1, l_{i}\right]=a_{i} \leqslant x\left[i, l_{i}\right]$. В любой момент мы используем только один из массивов $x[i]$, поэтому будем использовать одномерный массив вместо двумерного; на каждом шаге у него нужно изменить не более одной ячейки.
```py
fill(l, 1)
fill(x, inf)
x[1] = a[0]
for i = 1..(n - 1):
    l[i] = lower_bound(x + 1, x + n, a[i]) - x
    x[l[i]] = a[i]
```

### Восстановление ответа

Если нужно восстановить ответ, вместе с массивом $x$ будем поддерживать массив списков pos: вначале все списки пустые; в момент, когда мы делаем присвоение $x\left[l_{i}\right]=a_{i}$, допишем $i$ в конец списка $\operatorname{pos}\left[l_{i}\right]$. Теперь для того, чтобы найти предыдущий элемент в НВП, заканчивающейся в $i$-й позиции, нужно найти максимальный элемент в $\operatorname{pos}\left[l_{i}\right]$, меньший $i$. Поскольку суммарный размер списков pos не превышает $n$, это можно делать простым проходом по списку.