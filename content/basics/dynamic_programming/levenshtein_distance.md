---
title: "Расстояние Левенштейна"
date: 2025-04-24T16:21:19+03:00
draft: false
weight: 20
---

_Расстояние Левенштейна_ (_редакционное расстояние_) между двумя последовательностями это минимальное количество операций вставки, удаления и замены символа, с помощью которых можно из одной последовательности получить другую.

Расстояние Левенштейна между $a_{1}, \ldots, a_{n}$ и $b_{1}, \ldots, b_{m}$ можно вычислить алгоритмом, практически полностью совпадающим с алгоритмом поиска НОП: пусть $d[i, j]$ - расстояние Левенштейна между последовательностями $a_{1}, \ldots, a_{i}$ и $b_{1}, \ldots, b_{j}$. Тогда $d[i, 0]=i$, $d[0, j]=j$, а при $i, j>0$ верно

$$
d[i, j]=\min \left\{\begin{array}{l}
l[i-1, j]+1 \\
l[i, j-1]+1 \\
l[i-1, j-1]+\chi\left(a_{i}, b_{j}\right)
\end{array}\right.
$$

где $\chi(x, y)=0$ при $x=y, \chi(x, y)=1$ иначе. Первый случай соответствует удалению $a_{i}$, второй - вставке в последовательность $a$ символа $b_{j}$ после $a_{i}$, третий - замене $a_{i}$ на $b_{j}$ (или бездействию в случае $a_{i}=b_{j}$ ).

Восстановление ответа делается полностью аналогично восстановлению ответа в алгоритме поиска НОП. Если требуется найти лишь расстояние, но не последовательность действий, то снова достаточно $O(\min (m, n))$ дополнительной памяти.
```py
for i = 0..n:
    for j = 0..m:
        if i == 0 or j == 0:
            d[i, j] = max(i, j)
            continue
        d[i, j] = min(d[i - 1, j], d[i, j - 1]) + 1
        if a[i] == b[j]:
            d[i, j] = min(d[i, j], d[i - 1, j - 1])
        else:
            d[i, j] = min(d[i, j], d[i - 1, j - 1] + 1)
```

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
