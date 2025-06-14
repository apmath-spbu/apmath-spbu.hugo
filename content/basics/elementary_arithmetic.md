---
title: "2. Элементарная арифметика"
date: 2025-02-15T22:36:51+03:00
draft: false
weight: 20
---

Современные компьютеры умеют за одну элементарную операцию складывать два 32(или 64)-битных числа. Часто (например, в криптографии) приходится работать с куда более длинными числами. Поговорим о том, как проводить с ними элементарные арифметические операции.

Для удобства будем считать, что на вход алгоритмам даются натуральные числа в двоичной записи. Мы будем работать с числами, имеющими двоичную запись длины $n$ (возможно, с ведущими нулями).

✍️ В произвольном случае можно применить соответствующий алгоритм для $n$ равного максимуму из длин чисел, а в конце определить длину записи результата применения операции (удалить ведущие нули), что потребует $O(n)$ операций и не повлияет на оценку сложности алгоритма.

### 2.1 Сложение

Используем всем знакомый со школы способ сложения чисел в столбик:
```py
add(a, b, n): # a и b - двоичные записи чисел
    int c[n + 1] = 0 # создаём и заполняем нулями массив, куда запишем ответ
    for i = 0..n - 1:
        c[i] = a[i] + b[i]
        if c[i] >= 2:
            c[i + 1] += 1, c[i] -= 2
    return c
```

Время работы алгоритма - $O(n)$, существенно быстрее нельзя, потому что столько времени занимает уже считывание входных данных или вывод ответа.

✍️ Аналогичный алгоритм можно написать для чисел, записанных в $b$-ичной системе счисления. Если сумма трёх $b$-ичных чисел помещается в 32(64)-битный тип данных, то алгоритм всё ещё будет корректен. При этом $n$-битное число будет иметь примерно $\frac{n}{\log b}$ цифр в $b$-ичной записи, то есть алгоритм будет работать за $O\left(\frac{n}{\log b}\right)=O(n)$, так как $\frac{1}{\log b}$ - это константа. Тем не менее, это может дать ускорение в несколько десятков раз, что безусловно бывает полезно на практике.

### 2.2 Умножение

Вспомним теперь и школьное умножение чисел в столбик (заметим лишь, что ответ имеет длину не больше $2 n$, поскольку $\left.\left(2^{n}-1\right) \cdot\left(2^{n}-1\right)<2^{2 n}\right)$ :
```py
multiply(a, b, n): # a и b - двоичные записи чисел
    int c[2 * n] = 0 # создаём и заполняем нулями массив, куда запишем ответ
    for i = 0..n - 1:
        for j = 0..n - 1:
            c[i + j] += a[i] * b[j]
	for i = 0..2 * n - 2:
	    if c[i] >= 2:
	        c[i + 1] += c[i] / 2
	        c[i] %= 2
	return c
```

Из-за двух вложенных циклов время работы этого алгоритма - уже $O\left(n^{2}\right)$.
Приведём альтернативный рекурсивный алгоритм умножения двух чисел, пользующийся следующим правилом:

$$
a \cdot b= \begin{cases}2 \cdot\left(a \cdot\left\lfloor\frac{b}{2}\right\rfloor\right), & \text { если } b \text { чётно, } \\ a+2 \cdot\left(a \cdot\left\lfloor\frac{b}{2}\right\rfloor\right), & \text { иначе. }\end{cases}
$$

```py
multiply(a, b): # a и b - двоичные записи чисел
    if b == 0:
        return 0
    c = multiply(a, b / 2) # деление нацело
    if b % 2 == 0:
        return 2 * c
    else:
        return 2 * c + a
```

В этой схематичной записи под делением на два имеется ввиду битовый сдвиг вправо (то есть взятие двоичной записи без младшего бита), под умножением на два - битовый сдвиг влево (добавление нуля в начало битовой записи). Остаток по модулю два - это младший бит числа.

Алгоритм произведёт $O(n)$ рекурсивных вызовов, поскольку при каждом вызове длина битовой записи $b$ уменьшается на один. В каждом вызове функции происходят битовый сдвиг влево, битовый сдвиг вправо, и, возможно сложение - всего $O(n)$ элементарных операций. Таким образом, общее время работы снова $O\left(n^{2}\right)$.

Заметим, что если длины битовых записей $a$ и $b$ равны $n$ и $m$, то время работы обоих алгоритмов можно оценить как $O(n m)$.

### 2.3 Деление

Пусть теперь мы хотим поделить $a$ на $b$, то есть найти такие $q, r$, что $a=q b+r$ и $0 \leqslant r < b$. Здесь работает похожая идея: обозначим за $q^{\prime}, r^{\prime}$ результат деления $\left\lfloor\frac{a}{2}\right\rfloor$ на $b$, тогда:

$$
(q, r)= \begin{cases}\left(2 \cdot q^{\prime}+\left\lfloor\frac{2 \cdot r^{\prime}}{b}\right\rfloor, 2 \cdot r^{\prime}-\left\lfloor\frac{2 \cdot r^{\prime}}{b}\right\rfloor \cdot b\right), & \text { если } a \text { чётно, } \\ \left(2 \cdot q^{\prime}+\left\lfloor\frac{2 \cdot r^{\prime}+1}{b}\right\rfloor, 2 \cdot r^{\prime}+1-\left\lfloor\frac{2 \cdot r^{\prime}+1}{b}\right\rfloor \cdot b\right), & \text { иначе. }\end{cases}
$$

При этом $\left\lfloor\frac{2 \cdot r^{\prime}}{b}\right\rfloor,\left\lfloor\frac{2 \cdot r^{\prime}+1}{b}\right\rfloor \leqslant 1$. Получаем следующий рекурсивный алгоритм:
```py
divide(a, b): # a и b - двоичные записй чисел
    if a == 0:
        return 0, 0 # q = r = 0
    q, r = divide(a / 2, b) # деление нацело
    q = 2 * q, r = 2 * r
    if a % 2 == 1:
        r += 1
    if r >= b:
        q += 1, r -= b
    return q, r
```

Снова имеем $O(n)$ рекурсивных вызовов, в каждом из которых происходит константное число битовых сдвигов и сложений (вычитаний), поэтому время работы снова оценивается как $O\left(n^{2}\right)$.

Альтернативный способ - школьное деление в столбик:
```py
divide(a, b): # a и b - двоичные записи чисел
    n = len(a), m = len(b)
    q=0
    for i = (n - m)..0:
        # умножение на 2 ** k - битовый сдвиг числа на k влево
        c = b * 2 ** i
        if a >= c:
            a = a - c
            q = q + 2 **i
    return q, a
```

Время работы, как и в предыдущем случае, оценивается как $O\left(n^{2}\right)$. Есть и более точная в некоторых случаях оценка: если длины битовых записей $a$ и $b$ равны $n$ и $m$, то количество итераций цикла не превосходит $n-m+1$, поэтому получаем оценку $O(n(n-m+1))$.

### 2.4 Алгоритм Карацубы

Можно ли перемножать числа быстрее? Оказывается, что да! Следующий алгоритм был придуман советским математиком [Анатолием Карацубой](https://ru.wikipedia.org/wiki/%D0%9A%D0%B0%D1%80%D0%B0%D1%86%D1%83%D0%B1%D0%B0,_%D0%90%D0%BD%D0%B0%D1%82%D0%BE%D0%BB%D0%B8%D0%B9_%D0%90%D0%BB%D0%B5%D0%BA%D1%81%D0%B5%D0%B5%D0%B2%D0%B8%D1%87) в 1962 году.

Будем для удобства считать, что длина битовой записи чисел $n$ - степень двойки (если это не так, добавим ведущих нулей, при этом длина чисел увеличится не более чем вдвое, что не повлияет на асимптотическую оценку).

Разобьём каждое из чисел на две равных половины: $a=2^{\frac{n}{2}} a_{l}+a_{r}, b=2^{\frac{n}{2}} b_{l}+b_{r}$.
Заметим, что

$$
a b=\left(2^{\frac{n}{2}} a_{l}+a_{r}\right) \cdot\left(2^{\frac{n}{2}} b_{l}+b_{r}\right)=2^{n} a_{l} b_{l}+2^{\frac{n}{2}}\left(a_{l} b_{r}+a_{r} b_{l}\right)+a_{r} b_{r}
$$

Напишем рекурсивный алгоритм, пользующийся этим равенством: найдём четыре произведения вдвое более коротких чисел ( $a_{l} b_{l}, a_{l} b_{r}, a_{r} b_{l}, a_{r} b_{r}$ ) рекурсивно, после чего вычислим с их помощью $a b$. Для этого нам понадобится сделать константное число сложений и битовых сдвигов (и то, и другое делается за $\Theta(n)$ ). Обозначим за $T(n)$ время работы алгоритма на $n$-битовых числах, тогда мы получаем следующее рекуррентное соотношение:

$$
\begin{equation*}
T(n)=4 \cdot T\left(\frac{n}{2}\right)+\Theta(n) \tag{2.1}
\end{equation*}
$$

Совсем скоро мы докажем теорему, из которой следует, что $T(n)=\Theta\left(n^{2}\right)$. Пока мы не получили никакого выигрыша по сравнению с предыдущими алгоритмами умножения. Но оказывается, что этот алгоритм можно ускорить, заметив, что

$$
a_{l} b_{r}+a_{r} b_{l}=\left(a_{l}+b_{l}\right) \cdot\left(a_{r}+b_{r}\right)-a_{l} b_{l}-a_{r} b_{r} .
$$

Значит, достаточно рекурсивно вычислить три произведения, и время работы алгоритма будет удовлетворять уже

$$
\begin{equation*}
T(n)=3 \cdot T\left(\frac{n}{2}\right)+\Theta(n) \tag{2.2}
\end{equation*}
$$

Время работы такого алгоритма по той же теореме можно оценить уже как $\Theta\left(n^{\log _{2} 3}\right)=$ $\Theta\left(n^{1.585 \ldots}\right)$.

✍️ Строго говоря, длина чисел $a_{l}+b_{l}, a_{r}+b_{r}$ может оказаться равна $\frac{n}{2}+1$. Чтобы честно получить рекуррентное соотношение 2.2, можно за линейное время свести умножение $\left(\frac{n}{2}+1\right)$-битных чисел к умножению $\frac{n}{2}$-битных. На самом деле можно показать, что соотношение $T(n)=3 \cdot T\left(\frac{n}{2}+1\right)+\Theta(n)$ даёт такую же асимптотическую оценку.
```py
multiply(a, b): # a и b - двоичные записи чисел
    n = max(len(a), len(b))
    if n == 1:
        return [a[0] * b[0]] # число из одного бита
    a --> al, ar # делим число а на две равные части
    b --> bl, br # делим число b на две равные части
    x = multiply(al, bl)
    y = multiply(ar, br)
    z = multiply(al + ar, bl + br)
    # умножение на 2 ** k - битовый сдвиг числа на k влево
    return x * 2 ** n + (z - x - y) * 2 ** (n / 2) + y
```

На практике, дойдя в рекурсии до $16(32)$-битных чисел, уже стоит воспользоваться стандартной операцией умножения.

Существуют и более быстрые методы умножения чисел (например, метод, основанный на быстром преобразовании Фурье), но о них мы поговорим позже.

#### Пример
Рассмотрим произведение $1234 * 4321$.

Задача делится на 3 подзадачи:
1. $a_{l} b_{l} = 12 \cdot 43$
2. $a_{r} b_{r} = 34 \cdot 21$
3. $e = \left(a_{l}+b_{l}\right) \cdot\left(a_{r}+b_{r}\right)-a_{l} b_{l}-a_{r} b_{r} = \left(12 + 34\right) \cdot \left(43 + 21\right) - a_{l} b_{l} - a_{r} b_{r}$

Первая подзадача ($a_{l} b_{l} = 12 \cdot 43$) в свою очередь также резделяется на 3 подпроблемы:
- $a_{l}^\prime b_{l}^\prime = 1 \cdot 4 = 4$
- $a_{r}^\prime b_{r}^\prime = 2 \cdot 3 = 6$
- $\left(a_{l}^\prime+b_{l}^\prime\right) \cdot\left(a_{r}^\prime+b_{r}^\prime\right)-a_{l}^\prime b_{l}^\prime-a_{r} b_{r}^\prime = \left(1 + 2\right) \cdot \left(4 + 3\right) - 4 - 6 = 11$
- Ответ: $4 \cdot 10^2 + 11 \cdot 10 + 6 = 516$

Вторая подзадача ($a_{r} b_{r} = 34 \cdot 21$):
- $a_{l}^{\prime\prime} b_{l}^{\prime\prime} = 3 \cdot 2 = 6$
- $a_{r}^{\prime\prime} b_{r}^{\prime\prime} = 4 \cdot 1 = 4$
- $\left(a_{l}^{\prime\prime}+b_{l}^{\prime\prime}\right) \cdot\left(a_{r}^{\prime\prime}+b_{r}^{\prime\prime}\right)-a_{l}^{\prime\prime} b_{l}^{\prime\prime}-a_{r} b_{r}^{\prime\prime} = \left(3 + 4\right) \cdot \left(2 + 1\right) - 6 - 4 = 11$
- Ответ: $6 \cdot 10^2 + 11 \cdot 10 + 4 = 714$

Третья подзадача ($e = 46 \cdot 64 - 516 - 714$). Аналогично вычисляем $46 \cdot 64$:
- $4 \cdot 6 = 24$
- $6 \cdot 4 = 24$
- $\left(4 + 6 \right) \cdot (6 + 4) - 24 - 24 = 52$
- Ответ: $24 \cdot 10^2 + 52 \cdot 10 + 24 - 516 - 714 = 1714$

Финальный ответ: $1234 \cdot 4321 = 516 \cdot 10^4 + 1714 \cdot 10^2 + 714 = 5,332,114$
