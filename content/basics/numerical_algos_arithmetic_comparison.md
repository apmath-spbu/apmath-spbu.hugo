---
title: "9. Арифметика сравнений"
date: 2025-03-15T19:04:59+03:00
weight: 90
draft: false
---


Начиная с этой части, при оценке сложности алгоритмов будем использовать обозначение $M(n)$, имея в виду сложность умножения двух чисел длины $n$. Можно показать (с помощью метода Ньютона), что деление нацело имеет ту же сложность, что и умножение, поэтому для деления отдельного обозначения вводить не будем.

### Сложение и умножение по модулю

Сложение и умножение по $n$-битному модулю $N$ имеет ту же сложность, что и обычные сложение и умножение, то есть $O(n)$ и $O(M(n))$ : нужно произвести вычисление без модуля, при этом результат будем иметь не более $2 n$ бит, после чего вычислить остаток от деления результата на $N$. В случае сложения результат меньше $2 N$, поэтому достаточно просто (возможно) вычесть $N$, что требует ещё $O(n)$ операций и не увеличивает оценку времени работы. В случае умножения осуществляем деление с остатком за $O(M(n))$.

### Возведение в степень по модулю $N$

Воспользуемся той же идеей, что и в рекурсивном алгоритме умножения:

$$
a^{b}= \begin{cases}\left(a^{\left\lfloor\frac{b}{2}\right\rfloor}\right)^{2}, & \text { если } b \text { чётно, } \\ a \cdot\left(a^{\left\lfloor\frac{b}{2}\right\rfloor}\right)^{2}, & \text { иначе. }\end{cases}
$$

```py
modExp(a, b, N): # a и b - двоичные записи чисел, N - модуль
    if b == 0:
        return 1
    c = modExp(a, b / 2, N) # деление нацело
    if b % 2 == 0:
        return c ** 2 mod N
    else:
        return a * c ** 2 mod N
```

Если $n$ - максимальная длина чисел $a, b, N$, то происходит $O(n)$ рекурсивных вызовов, на каждом из которых не более двух умножений по модулю $N$. Получаем оценку сложности $O(n \cdot M(n))$.

### Алгоритм Евклида

Алгоритм Евклида находит наибольший общий делитель (НОД, greatest common divisor, $\operatorname{gcd}$) двух чисел $a$ и $b$.

>[!lemma]
>Для любых $a, b \geqslant 0$ выполняется $\operatorname{gcd}(a, b)=\operatorname{gcd}(a \bmod b, b)$.
>{{% notice style="prove" expanded="true" %}}
Ясно, что любой общий делитель $a$ и $b$ является и делителем $a-b$. Наоборот, любой общий делитель $a-b$ и $b$ является делителем $a$. Тогда $\operatorname{gcd}(a, b)=$ $\operatorname{gcd}(a-b, b)$. Остаётся $\left\lfloor\frac{a}{b}\right\rfloor$ раз вычесть $b$ из $a$.
{{% /notice %}}

Алгоритм Евклида пользуется вышеописанным правилом, пока не окажется, что $b=0$. Ясно, что $\operatorname{gcd}(a, 0)=a$ для любого $a$.
```py
gcd(a, b): # a, b >= 0
    if b == 0:
        return a
    return gcd(b, a % b)
gcd(a, b): # нерекурсивная версия
    while b > 0:
        a %=b
        swap(a, b)
    return a
```

Оценим время работы алгоритма:
>[!lemma]
>Если $a \geqslant b \geqslant 0$, то $a \bmod b<\frac{a}{2}$.
>>[!prove]+
>>Если $b \leqslant \frac{a}{2}$, то $a \bmod b < b \leqslant \frac{a}{2}$. Если $b > \frac{a}{2}$, то $a \bmod b=a-b < \frac{a}{2}$.

>[!corollar] 
>Время работы алгоритма Евклида на числах длины не более $n$ есть $O(n \cdot M(n))$.
>>[!prove]+
>>За каждые две итерации алгоритма $a$ и $b$ уменьшаются хотя бы вдвое, поэтому число итераций не превосходит $2 n$. На каждой происходит одно деление с остатком, имеющее сложность $O(M(n))$.

Если использовать алгоритм деления в столбик, можно показать оценку получше:
>[!theorem] 
>Время работы использующего деление в столбик алгоритма Евклида на числах длины не более $n$ есть $O\left(n^{2}\right)$.
>{{% notice style="prove" expanded="true" %}}
Вспомним, что если мы пользуемся алгоритмом деления в столбик, то остаток от деления $k$-битного числа $a$ на $l$-битное число $b$ вычисляется за $O(k(k-l+1)$ ).

Пусть в процессе выполнения алгоритма Евклида мы работали с числами $z_{1}=a, z_{2}=$ $b, z_{3}=a \bmod b, \ldots, z_{k+1}=z_{k-1} \bmod z_{k}=0$, имеющими длины $n_{1}, n_{2}, \ldots, n_{k}, n_{k+1}$. Суммарное время выполнения всех делений -

$$
\sum_{i=1}^{k-1} O\left(n_{i}\left(n_{i}-n_{i+1}+1\right)\right)=O\left(n k+n \cdot \sum_{i=1}^{k-1}\left(n_{i}-n_{i+1}\right)\right)=O\left(n k+n\left(n_{1}-n_{k}\right)\right)=O\left(n^{2}\right)
$$

{{% /notice %}}

### Расширенный алгоритм Евклида

Расширенный алгоритм Евклида одновременно с $d=\operatorname{gcd}(a, b)$ находит такие $x$ и $y$, что $a x+b y=d$. Эти $x$ и $y$ можно использовать как сертификат, подтверждающий, что $d$ действительно НОД $a$ и $b$ :

>[!lemma]
>Если $a$ и $b$ делятся на $d$, и $d=a x+b y$ для некоторых $x, y$, то $d=\operatorname{gcd}(a, b)$.
>>[!prove]
>>$a$ и $b$ делятся на $d$, тогда $d \leqslant \operatorname{gcd}(a, b)$. С другой стороны $a$ и $b$ делятся на $\operatorname{gcd}(a, b)$, тогда и $d=a x+b y$ делится на $\operatorname{gcd}(a, b)$, то есть $d \geqslant \operatorname{gcd}(a, b)$.

Такие $x$ и $y$ всегда можно найти следующим алгоритмом:
```py
extendedEuclid(a, b): # возвращает x,y такие, что ax + by = gcd(a, b)
    if b == 0:
        return 1, 0
    x, y = extendedEuclid(b, a % b)
    return y, x - (a / b) * y # деление нацело
```

>[!corollar]
>Вышеописанный алгоритм возвращает такие $x, y$, что $a x+b y=$ $\operatorname{gcd}(a, b)$.
>{{% notice style="prove" expanded="true" %}}
Докажем утверждение индукцией по $b$.

База. Если $b=0$, то $a=a \cdot 1+b \cdot 0$.

Переход. Пусть рекурсивный вызов вернул $x, y$. По предположению индукции выполняется равенство $\operatorname{gcd}(b, a \bmod b)=b \cdot x+(a \bmod b) \cdot y$.

Тогда $\operatorname{gcd}(a, b)=\operatorname{gcd}(b, a \bmod b)=b \cdot x+(a \bmod b) \cdot y=b \cdot x+\left(a-\left\lfloor\frac{a}{b}\right\rfloor b\right) \cdot y=$ $a \cdot y+b \cdot\left(x-\left\lfloor\frac{a}{b}\right\rfloor y\right)$.

{{% /notice %}}

Ясно, что число итераций этого алгоритма совпадает с числом итераций обычного алгоритма Евклида (так как рекурсивные переходы устроены точно так же). Чтобы оценить время работы расширенного алгоритма Евклида, нужно ещё понять, насколько большими могут быть $x$ и $y$ :

>[!corollar]
Если $a, b>0$, то для возвращаемых алгоритмом $x$ и $y$ верно, что $|x| \leqslant b,|y| \leqslant a$.
>{{% notice style="prove" expanded="true" %}}
Снова воспользуемся индукцией по $b$.

База. При $b=0$ алгоритм возвращает $x=1, y=0$ (случай $b=0$ не подходит под условие предложения, но нужен нам как база индукции).

Переход. Если $a \bmod b=0$, то extendedEuclid(b, a mod b) вернул $x^{\prime}=1, y^{\prime}=0$. Тогда extendedEuclid(a, b) вернёт $x=0 \leqslant b, y=1 \leqslant a$.

Если же $a \bmod b \neq 0$, то по предположению индукции extendedEuclid(b, a mod b) вернул такие $x^{\prime}, y^{\prime}$, что $\left|x^{\prime}\right| \leqslant a \bmod b,\left|y^{\prime}\right| \leqslant b$. Тогда extendedEuclid(a, b) вернёт $|x|=\left|y^{\prime}\right| \leqslant b,|y|=\left|x^{\prime}-\left\lfloor\frac{a}{b}\right\rfloor y^{\prime}\right| \leqslant\left|x^{\prime}\right|+\left\lfloor\frac{a}{b}\right\rfloor\left|y^{\prime}\right| \leqslant a \bmod b+\left\lfloor\frac{a}{b}\right\rfloor b=a$.

{{% /notice %}}

Пусть длина битовой записи $a$ и $b$ не превосходит $n$. Поскольку $a$ и $b$ только уменьшаются при рекурсивных вызовах, ясно, что все числа, возникающие в процессе промежуточных вычислений, имеют длину не более $n$. Теперь уже ясно, что оценка времени работы алгоритма Евклида $O(n \cdot M(n))$ остаётся верной и для расширенной версии.

Покажем, что остаётся верной и оценка $O\left(n^{2}\right)$ :
>[!corollar]
Время работы использующего деление в столбик расширенного алгоритма Евклида на числах длины не более $n$ есть $O\left(n^{2}\right)$.
>{{% notice style="prove" expanded="true" %}}
Для того, чтобы повторить доказательство теоремы 9.3, достаточно показать, что суммарное время работы всех операций, кроме рекурсивного вызова, в extendedEuclid(a,b) на числах длины $n$ и $m$ соответственно, есть $O(n(n-m+1))$.

Частное $\left\lfloor\frac{a}{b}\right\rfloor$ можно вычислить одновременно с остатком $a \bmod b$ за $O(n(n-m+1))$. Также нужно произвести умножение $\left\lfloor\frac{a}{b}\right\rfloor$ на $y$, но, поскольку длина $\left\lfloor\frac{a}{b}\right\rfloor$ не превосходит $n-m+1$, а длина $y$ не превосходит $n$, это умножение имеет ту же сложность, что и деление выше. Помимо умножения и деления, происходит ещё лишь линейное от $n$ число действий.

{{% /notice %}}

### Нахождение обратного по модулю $N$

Число, обратное к $а$ по модулю $N\left(\right.$ об. $\left.a^{-1}\right)$ - это такое $x$, что $a x \equiv 1(\bmod N)$.
Такое $x$ существует тогда и только тогда, когда $a x+N y=1$ для некоторого $y$. Как мы уже знаем, такое уравнение имеет решение только когда $\operatorname{gcd}(a, N)=1$, то есть когда $a$ взаимно просто с $N$.

С помощью расширенного алгоритма Евклида мы можем за $O\left(n^{2}\right)$ проверить, существует ли обратное к $a$ по модулю $N$, и если существует, то найти его.

Если для числа $a$ существует обратное по модулю $N$ число $a^{-1}$, то можно осуществлять деление на $a$ по модулю $N$ : это равносильно умножению на $a^{-1}$.