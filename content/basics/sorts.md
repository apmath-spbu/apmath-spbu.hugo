---
title: "6. Сортировки"
date: 2025-02-23T13:44:51+03:00
draft: false
weight: 60
---

## Квадратичные сортировки

Существует множество различных алгоритмов, сортирующих массив длины $n$ за $\Theta\left(n^{2}\right)$. Мы поговорим лишь о двух из них.

### Сортировка выбором

Сортировка выбором (selection sort) на $i$-м шаге находит $i$-й по возрастанию элемент и ставит его на $i$-ю позицию. Поскольку первые $i-1$ элементов в этот момент уже стоят на своих позициях, достаточно просто найти минимальный элемент в подотрезке $[i, n)$.
```py
for i = 0..(n - 1):
    minPos = i
    for j = (i + 1)..(n - 1):
        if a[minPos] > a[j]:
            minPos = j
    swap(a[i], a[minPos])
```
&nbsp;
{{< video2 "https://github.com/apmath-spbu/manim-sorts/raw/refs/heads/main/SelectionSort.mp4" "my-5">}}

### Сортировка вставками

На $i$-м шаге сортировки вставками (insertion sort) первые $i$ элементов массива (образующие префикс длины $i$ ) расположены в отсортированном порядке. $i$-й шаг состоит в том, что $i$-й элемент массива вставляется в нужную позицию остортированного префикса.
```py
for i = 1..(n - 1):
    for (j = i; j > 0 and a[j] < a[j - 1]; --j):
        swap(a[j], a[j - 1])
```

#### Время работы

В обеих сортировках два вложенных цикла в худшем случае дают время работы $\Theta\left(n^{2}\right)$.
Сортировка выбором полезна тем, что делает $\Theta(n)$ операций swap. Это свойство пригождается, когда сортируются тяжёлые объекты, и каждая операция swap занимает много времени.

Инверсией называют такую пару элементов на позициях $i < j$, что $a_{i} > a_{j}$. Последовательность элементов является отсортированной тогда и только тогда, когда в ней нет инверсий. Время работы сортировки вставками можно оценить как $\Theta(n+\operatorname{Inv}(a))$, где $\operatorname{Inv}(a)$ - количество инверсий в массиве $a$, так как на каждом шаге внутреннего цикла количество инверсий в массиве уменьшается ровно на один. Значит, на отсортированном (или почти отсортированном) массиве время работы сортировки вставками составит $O(n)$.

#### Стабильность

Сортировка называется стабильной, если она оставляет равные элементы в исходном порядке. Обычно такое свойство сортировки нужно, когда помимо данных, по которым производится сортировка, в элементах массива хранятся какие-то дополнительные данные. Например, если дан список участников соревнований в алфавитном порядке, и хочется отсортировать их по убыванию набранных баллов так, чтобы участники с равным числом баллов всё ещё шли в алфавитном порядке.

Сортировка выбором стабильной не является (например, массив $[5,5,3,1]$ после первого шага изменится на $[1,5,3,5]$, при этом порядок пятёрок поменялся). Сортировка вставками стабильна, так как меняет местами только соседние элементы, образующие инверсию, поэтому ни в какой момент времени не поменяет порядок равных элементов.

✍️ Любую сортировку можно сделать стабильной, если вместо исходных элементов сортировать пары (элемент, его номер в исходном массиве), и при сравнении пар сначала сравнивать элементы, а при равенстве номера.

#### Применение на практике

Сейчас мы перейдём в алгоритмам сортировки, работающим за $\Theta(n \log n)$. Квадратичные сортировки, благодаря малой константе в оценке времени работы, работают быстрее более сложных алгоритмов на коротких массивах. На практике часто применяется гибридный подход: алгоритм сортировки, использующий метод "разделяй и властвуй", работает, пока массив не поделится на части достаточно малого размера, после чего на них запускается алгоритм квадратичной сортировки.

### Сортировка слиянием (Merge sort)

Сортировка слиянием (Von Neumann, 1945) использует метод "разделяй и властвуй" следующим образом: массив делится на две части, каждая из них сортируется рекурсивно, после чего две отсортированных части сливаются при помощи метода двух указателей.
```py
mergeSort(a, l, r): # coртирует a[l, r)
    if r - l <= 1:
        return
    m = (l + r) / 2
    mergeSort(a, l, m)
    mergeSort(a, m, r)
    merge(a, l, m, r)

# merge использует вспомогательный массив buf достаточно большого размера
merge(a, l, m, r): # сливает два отсортированных отрезка а[l, m) и а[m, r)
    for (i = l, j = m, k = 0; i < m or j < r; ):
        if i == m or (j < r and a[i] > a[j]):
            buf[k] = a[j]
            k += 1, j += 1
        else:
            buf[k] = a[i]
            k += 1, i += 1
    for i = 0..(r - l - 1):
            a[l + i] = buf[i]
```

Время работы сортировки слиянием можно оценить с помощью рекуррентного соотношения $T(n)=2 \cdot T\left(\frac{n}{2}\right)+\Theta(n)$. По [основной теореме о рекуррентных соотношениях]({{% relref "basics/recurrence_relation" %}}) получаем $T(n)=\Theta(n \log n)$.

Сортировка слиянием стабильна (поскольку функция merge не меняет относительный порядок равных элементов).

Недостатком сортировки слиянием является то, что она требует $\Theta(n)$ дополнительной памяти (вспомогательный массив в merge).

### Быстрая сортировка (Quicksort)

Быстрая сортировка (Hoare, 1959) также использует метод "разделяй и властвуй", но немного по-другому. Возьмём какой-нибудь элемент массива - $x$. Поделим массив на три части так, что в первой все элементы меньше $x$, во второй равны $x$, в третьей больше $x$ (это можно сделать за линейное от длины массива время, например, с помощью трёх вспомогательных массивов). Остаётся рекурсивно отсортировать первую и третью части.
```py
quickSort(a):
    if len(a) <= 1:
        return
    x = randomElement(a) # x - случайный элемент а
    a --> l (< x), m (= x), r (> x) # делим а на три части
    return quickSort(l) + m + quickSort(r)
```

На практике, чтобы алгоритм работал быстрее и использовал меньше дополнительной памяти, используют более хитрый способ деления массива на части:
```py
# partition выбирает x - случайный элемент a[l, r],
# переставляет местами элементы a[l, r] и возвращает m (l <= m < r) такое, что
# все элементы a[l, m] меньше или равны x, все элементы a[m + 1, r] больше или равны x
partition(a, l, r) -> int:
    p = random(l, r), x = a[p]
    swap(a[p], a[l]) # теперь x стоит на l-й позиции
    i = l, j = r
    while i <= j:
        while a[i] < x:
            i += 1
            while a[j] > x:
                j -= 1
            if i >= j:
            break
            swap(a[i], a[j])
            i += 1, j -= 1
        return j

quickSort(a, l, r): # coртирует a[l, r]
        if l == r:
            return
    m = partition(a, l, r)
    quickSort(a, l, m)
    quickSort(a, m + 1, r)
```

>[!props]
>Функция partition работает корректно, то есть $i$ и $j$ не выходят за границы $l, r$, функция возвращает такое $m$, что $l \leqslant m < r$, все элементы $a[l, m]$ меньше или равны $x$, все элементы $a[m+1, r]$ больше или равны $x$.
>{{% notice style="prove" expanded="true" %}}
Заметим, что в любой момент времени все элементы $a[l, i)$ меньше или равны $x$, все элементы $a(j, r]$ больше или равны $x$.

На первой итерации внешнего цикла в момент проверки условия на $13$-ой строке верно, что $i=l \leqslant j$. Значит либо мы сразу выйдем из внешнего цикла (если $i=j=l < r$ ), либо выполнятся $15-16$ строки, после чего всегда будет верно, что $a[l] \leqslant x, a[r] \geqslant x, j < r$. При этом 15-16 строки выполнились только при $i < j$, тогда даже после их выполнения $i$, $j$ не вышли за границы $l$, $r$.

Отдельно отметим, что после первой итерации внешнего цикла точно выполняется неравенство $j < r$.

На всех последующих итерациях внешнего цикла после выполнения $9-12$ строк будут верны неравенства $j \geqslant l, i \leqslant r$ (так как $a[l] \leqslant x, a[r] \geqslant x$ ). При этом если условие на

13-й строке не выполняется (то есть $i < j$ ), то даже после выполнения $15-16$ строк $i, j$ не выйдут за границы $l, r$.

Наконец, по итогам выполнения функции $l \leqslant m=j < r$, все элементы $a[m+1, r]=$ $a(j, r]$ больше или равны $x$, все элементы $a[l, m]=a[l, j]$ меньше или равны $x$ (так как это верно для элементов $a[l, i), j \leqslant i$, причём $j=i$ только если мы вышли из внешнего цикла на $14$-ой строке, что возможно, только если $a[j]=x$ ).
{{% /notice %}}

Заметим, что такая реализация является нестабильной сортировкой.

#### Оценка времени работы

В худшем случае массив каждый раз будет делиться очень неравномерно, и почти все элементы будут попадать в одну из частей. Время работы в худшем случае можно оценить с помощью рекуррентного соотношения $T(n)=T(n-1)+\Theta(n)$, раскрыв которое, получаем $T(n)=\sum_{i=1}^{n} \Theta(i)=\Theta\left(n^{2}\right)$.

В лучшем же случае массив каждый раз будет делиться на две примерно равные части. Получаем рекуррентное соотношение $T(n)=2 \cdot T\left(\frac{n}{2}\right)+\Theta(n)$, тогда по [основной теореме о рекуррентных соотношениях]({{% relref "basics/recurrence_relation" %}}) получаем $T(n)=\Theta(n \log n)$.

Оказывается, время работы алгоритма в среднем намного ближе к лучшему случаю, чем к худшему. Для того, чтобы это доказать, нам понадобится терминология из теории вероятностей.
{{% notice style="def" %}}
Математическое ожидание случайной величины $X$, принимающей значение $x_{1}$ с вероятностью $p_{1}, x_{2}$ с вероятностью $p_{2}, \ldots, x_{n}$ с вероятностью $p_{n}$ $\left(p_{1}+\cdots+p_{n}=1\right)$ есть

$$
\mathbb{E} X=\sum_{i=1}^{n} p_{i} x_{i} .
$$

{{% /notice %}}

>[!theorem]
>Математическое ожидание времени работы алгоритма быстрой сортировки есть $O(n \log n)$.
>{{% notice style="prove" expanded="true" %}}
Мы докажем теорему только в случае, когда все элементы массива попарно различны. Кроме того, будем рассматривать версию алгоритма, делящую массив на три части (элементы меньше $x$; элементы, равные $x$; элементы больше $x$ ).

Для удобства будем использовать индексы элементов не в исходном, а в уже отсортированном массиве: пусть отсортированный массив имеет вид $z_{1}, z_{2}, \ldots, z_{n}$, исходный массив $a$ - это какая-то перестановка элементов $z_{i}$.

Время работы алгоритма быстрой сортировки пропорционально количеству выполненных сравнений. Обозначим количество выполненных сравнений за $T(n)$, достаточно оценить его математическое ожидание.

$z_{i}$ и $z_{j}$ могли сравниваться, только если на каком-то шаге алгоритма один из них был выбран в качестве $x$. Заметим, что такой элемент не участвует в последующих рекурсивных вызовах, поэтому каждую пару элементов алгоритм сравнит не более, чем один раз.

Пусть $\Gamma$ - множество всех возможных сценариев выполнения алгоритма, $p(A)$ вероятность того, что произошёл сценарий $A \in \Gamma$. Для каждой пары $i, j$ введём величину $\chi(A, i, j)$, равную единице, если $z_{i}$ и $z_{j}$ сравнивались в сценарии $A$, и нулю, если не сравнивались. Математическое ожидание количества выполненных алгоритмом сравнений равняется

$$
\mathbb{E} T(n)=\sum_{A \in \Gamma}\left(p(A) \sum_{1 \leqslant i < j \leqslant n} \chi(A, i, j)\right)=\sum_{1 \leqslant i < j \leqslant n} \sum_{A \in \Gamma} p(A) \chi(A, i, j) .
$$

Остаётся для каждой пары $1 \leqslant i < j \leqslant n$ посчитать $\sum_{A \in \Gamma} p(A) \chi(A, i, j)$, то есть вероятность, с которой $z_{i}$ и $z_{j}$ сравнивались между собой.

Посмотрим на момент, в который $z_{i}$ и $z_{j}$ при делении массива попали в разные части. Заметим, что массив, который делился на части в этот момент, после сортировки будет являться подотрезком отсортированного массива $z$, тогда вместе с $z_{i}$ и $z_{j}$ он содержит весь подотрезок $z[i, j]$.

Поскольку $z_{i}$ и $z_{j}$ при делении попали в разные части, в качестве $x$ точно был выбран один из элементов $z[i, j]$. При этом $z_{i}$ и $z_{j}$ сравнивались между собой только если в качестве $x$ был выбран один из них. Поскольку $x$ выбирается среди всех элементов равновероятно, вероятность того, что между $z_{i}$ и $z_{j}$ произошло сравнение, равняется $\frac{2}{j-i+1}$. Получаем

$$
\begin{aligned}
\mathbb{E} T(n)= & \sum_{1 \leqslant i < j \leqslant n} \sum_{A \in \Gamma} p(A) \chi(A, i, j)=\sum_{i=1}^{n-1} \sum_{j=i+1}^{n} \frac{2}{j-i+1}\xlongequal{\left(k=j-i\right)} \\
& =\sum_{i=1}^{n-1} \sum_{k=1}^{n-i} \frac{2}{k+1} < 2 n \sum_{k=1}^{n} \frac{1}{k}=O(n \log n)
\end{aligned}
$$

Последний переход можно понять, например, следующим способом:

$$
\begin{gathered}
\sum_{k=1}^{n} \frac{1}{k}=\frac{1}{1}+\left(\frac{1}{2}+\frac{1}{3}\right)+\left(\frac{1}{4}+\frac{1}{5}+\frac{1}{6}+\frac{1}{7}\right)+\cdots< \\
< \\
\frac{1}{1}+\left(\frac{1}{2}+\frac{1}{2}\right)+\left(\frac{1}{4}+\frac{1}{4}+\frac{1}{4}+\frac{1}{4}\right)+\cdots \leqslant\left\lfloor\log _{2} n\right\rfloor+1 .
\end{gathered}
$$

{{% /notice %}}


✍️ Отсюда следует и более сильное утверждение: время работы алгоритма есть $O(n \log n)$ с вероятностью, близкой в единице. Это следует из следующего утверждения, известного как неравенство Маркова: для неотрицательной случайной величины $X$ с математическим ожиданием $\mathbb{E}(X)$ вероятность того, что $X>k \cdot \mathbb{E}(X)$, не превосходит $\frac{1}{k}$. Это верно, так как в противном случае математическое ожидание $X$ оказалось бы больше $\frac{1}{k} \cdot k \cdot \mathbb{E}(X)=\mathbb{E}(X)$.
В нашем случае, например, для $k=100$ получаем, что с вероятностью $99 \%$ время работы не превосходит $O(100 \cdot n \log n)=O(n \log n)$.

Взятие случайного элемента - достаточно медленная операция, поэтому на практике вместо случайного элемента часто берут какой-то конкретный, например самый левый, самый правый, или средний; также часто используют средний по значению из этих трёх. Для подобных версий алгоритма можно построить массив, на котором сортировка будет работать за $\Theta\left(n^{2}\right)$. С этим борются разными способами, например, когда глубина рекурсии превышает $\log n$, переключаются на какой-нибудь другой алгоритм сортировки.

На практике алгоритм быстрой сортировки оказывается одним из самых быстрых и часто используемых. Встроенная в C++ сортировка - [std::sort](https://en.cppreference.com/w/cpp/algorithm/sort), использует алгоритм Introsort, который начинает сортировать массив алгоритмом быстрой сортировки, на большой глубине рекурсии переключается на heapsort (который мы скоро изучим), а массивы совсем небольшой длины сортирует сортировкой вставками.

### Поиск $k$-й порядковой статистики
$k$-я порядковая статистика на массиве из $n$ элементов - это $k$-й по возрастанию элемент. Например, при $k=1$ это минимум, при $k=n$ - максимум. Медиана - это элемент, который оказался бы в середине массива, если бы его отсортировали. Если длина массива чётна, то в нём есть две медианы на позициях $\left\lfloor\frac{n+1}{2}\right\rfloor$ и $\left\lceil\frac{n+1}{2}\right\rceil$. Для определённости под медианой будем иметь в виду $\left\lfloor\frac{n+1}{2}\right\rfloor$-ю порядковую статистику.

Минимум и максимум в массиве очень легко ищется за $O(n)$ одним проходом по всем элементам массива. $k$-й по возрастанию элемент так просто уже не найти.

Можно отсортировать массив за $O(n \log n)$, тогда $k$-я порядковая статистика окажется на $k$-й позиции (если нумеровать элементы массива, начиная с единицы). Однако существуют и более быстрые алгоритмы, находящие $k$-ю порядковую статистику для произвольного $k$ за $O(n)$.

Вернёмся к алгоритму быстрой сортировки. Когда мы поделили массив на две части, можно понять, в какой из этих частей находится $k$-й по возрастанию элемент: если размер левой части хотя бы $k$, то он находится в ней, иначе он находится в правой части. Тогда, если нас интересует не весь отсортированный массив, а только $k$-й по возрастанию элемент, можно сделать рекурсивный запуск только от той части, в которой он лежит.
```py
kthElement(a, l, r, k): # находит k-ю порядковую статистику в a[l, r]
    if l == r:
        return a[l]
    m = partition(a, l, r)
    if m - l + 1 >= k:
        return kthElement(a, l, m, k)
    else:
        return kthElement(a, m + 1, r, k - (m - l + 1))
```

В худшем случае такой алгоритм будет работать по-прежнему за $\Theta\left(n^{2}\right)$. Однако оказывается, что оценка среднего времени работы после такой оптимизации улучшается с $O(n \log n)$ до $O(n)$.

>[!theorem]
>Математическое ожидание времени работы алгоритма kthElement есть $O(n)$.
>{{% notice style="prove" expanded="true" %}}
Мы докажем теорему в случае, когда все элементы массива попарно различны.

Будем говорить, что алгоритм находится в $j$-й фазе, если размер текущего отрезка массива не больше $\left(\frac{3}{4}\right)^{j} n$, но строго больше $\left(\frac{3}{4}\right)^{j+1} n$. Оценим время работы алгоритма в каждой фазе отдельно.

Назовём элемент центральным, если хотя бы четверть элементов в текущем отрезке массива меньше его, и хотя бы четверть больше. Если в качестве разделителя $x$ был выбран центральный элемент, то размер отрезка, от которого будет сделан рекурсивный запуск, будет не больше $\frac{3}{4}$ от размера текущего отрезка, то есть текущая фаза алгоритма точно закончится. При этом вероятность выбрать центральный элемент равна $\frac{1}{2}$ (так как ровно половина элементов отрезка являются центральными). Тогда математическое ожидание количества рекурсивных запусков, сделанных в течение $j$-й фазы, не превосходит

$$
1+\frac{1}{2}\left(1+\frac{1}{2}(1+\cdots)\right)=1+\frac{1}{2}+\frac{1}{4}+\cdots=2 .
$$

При этом каждая итерация алгоритма на $j$-й фазе совершает $O\left(\left(\frac{3}{4}\right)^{j} n\right)$ действий. Математическое ожидание времени работы алгоритма равняется сумме математических ожиданий времён работы каждой фазы, которая не превосходит

$$
\sum_{j} O\left(\left(\frac{3}{4}\right)^{j} n\right) \cdot 2=O\left(n \cdot \sum_{j}\left(\frac{3}{4}\right)^{j}\right)=O\left(n \cdot \frac{1}{1-3 / 4}\right)=O(n)
$$

{{% /notice %}}

В C++ есть встроенная реализация этого алгоритма - [std::nth_element](https://en.cppreference.com/w/cpp/algorithm/nth_element).

✍️ Алгоритм можно модифицировать так, чтобы он работал за $O(n)$ в худшем случае. Это делается так: поделим массив на $n / 5$ групп по 5 элементов, в каждой за $O(1)$ найдём медиану. Теперь рекурсивным запуском алгоритма найдём медиану среди этих медиан, и уже её будем использовать в качестве разделителя. Тогда в половине групп хотя бы 3 элемента окажутся меньше разделителя, а в другой половине хотя бы 3 элемента окажутся больше разделителя. Значит каждая из частей, на которые поделился массив, будет иметь размер хотя бы $3 n / 10$. Получаем в худшем случае рекуррентное соотношение $T(n)=\Theta(n)+T(n / 5)+T(7 n / 10)$. Можно показать, что в этом случае верно $T(n)=\Theta(n)$.

### Оценка снизу на время работы сортировки сравнениями

Алгоритм сортировки сравнениями может копировать сортируемые объекты и сравнивать их друг с другом, но никак не использует внутреннюю структуру объектов. Все сортировки, изученные нами до этого момента, являются сортировками сравнения. Можно показать, что никакая сортировка сравнениями не может в общем случае работать быстрее, чем за $\Theta(n \log n)$.

>[!theorem]
Любой алгоритм сортировки сравнениями имеет время работы $\Omega(n \log n)$ в худшем случае.
>{{% notice style="prove" expanded="true" %}}
Алгоритм сортировки сравнениями должен уметь корректно сортировать любую перестановку чисел от 1 до $n$. Пусть алгоритм на каждой перестановке делает не более $k$ сравнений. Заметим, что если зафиксировать результаты всех сравнений в ходе работы алгоритма, то он будет выдавать всегда одну и ту же перестановку данного на вход массива.

>✍️ Это не совсем верно для алгоритмов, использующих случайные числа (например, для алгоритма быстрой сортировки), поскольку сама последовательность сравнений может зависеть от того, какие случайные числа выпали. Однако это верно, если зафиксировать последовательность случайных чисел, которую получает алгоритм. Поскольку алгоритм должен корректно работать на любой данной ему последовательности случайных чисел, дальнейшие рассуждения остаются верны.

Поскольку алгоритм делает не более $k$ сравнений, и равенств не бывает (поскольку мы сортируем перестановки), существует не более $2^{k}$ различных перестановок данного на вход массива, которые он может выдать. Поскольку алгоритм корректно сортирует произвольную перестановку, получаем $2^{k} \geqslant n!$. Тогда

$$
k \geqslant \log (n!) \geqslant \log \left(\left(\frac{n}{2}\right)^{n / 2}\right)=\frac{n}{2} \log \frac{n}{2}=\Omega(n \log n)
$$

{{% /notice %}}

Тем не менее, если обладать какой-то дополнительной информацией о свойствах сортируемых объектов, иногда можно воспользоваться этими свойствами, чтобы отсортировать объекты быстрее, чем за $\Theta(n \log n)$.

### Сортировка подсчётом

Если известно, что все числа во входном массиве целые, неотрицательные и меньше некоторого $k$, то их можно отсортировать за $\Theta(n+k)$ (при этом понадобится $\Theta(k)$ вспомогательной памяти). Для этого посчитаем, сколько раз встретилось каждое число от 1 до $k$, после чего просто выпишем каждое число в ответ столько раз, сколько он встречалось в исходном массиве.
```py
int c[k]
countingSort(a, n):
    for i = 0..(k - 1):
        c[i] = 0
    for i = 0..(n - 1):
        c[a[i]] += 1
    p = 0
    for i = 0..(k - 1):
        for j = 0..(c[i] - 1):
            a[p] = i
            p += 1
```

Ясно, что таким же образом можно сортировать целые числа, лежащие в диапазоне $[L, R)$, за $\Theta(n+(R-L))$.

Если воспользоваться ещё одним вспомогательным массивом, сортировку можно сделать стабильной:
```py
int c[k]
countingSort(a, n):
    for i = 0..(k - 1):
        c[i] = 0
    for i = 0..(n - 1):
        c[a[i]] += 1
    for i = 1..(k - 1):
        c[i] += c[i - 1]
    # теперь с[i] - количество элементов массива, не превосходящих i
    int b[n]
    for i = (n - 1)..0:
        c[a[i]] -= 1
        b[c[a[i]]] = a[i]
    for i = 0..(n - 1):
        a[i] = b[i]
```

Стабильная сортировка подсчётом пригодится нам в следующем алгоритме сортировки.

### Поразрядная сортировка (Radix sort)

Пусть дан массив из $n$ чисел, записанных в $k$-ичной системе счисления и имеющих не более $d$ разрядов каждое. Отсортируем числа сортировкой подсчётом $d$ раз - сначала по младшему разряду, потом по следующему, и так далее, в конце - по старшему разряду. При этом будем пользоваться стабильной версией сортировки подсчётом.

После первого шага числа будут отсортированы по 0-му разряду, после второго по 1-му разряду, а при равенстве цифр в 1-м разряде - по 0-му. В конце числа будут отсортированы по $(d-1)$-му разряду, при равенстве цифр в $(d-1)$-м разряде - по ( $d-2)$-му,..., при равенстве цифр во всех разрядах, кроме 0-го - по 0-му. Значит числа просто окажутся отсортированы в порядке возрастания.
```py
radixSort(a, n, d):
    for i = 0..(d - 1):
        countingSort(a, n, i) # стабильная сортировка подсчётом по i-му разряду
```

Каждый шаг алгоритма работает за $\Theta(n+k)$, тогда время работы всего алгоритма $\Theta(d(n+k))$. Поразрядная сортировка является стабильной.

С помощью поразрядной сортировки можно сортировать любые объекты, которые можно лексикографически упорядочить. Так, можно лексикографически отсортировать $n$ строк длины $d$ каждая, в записи которых используется $k$ различных символов, за $\Theta(d(n+k))$.

Пусть нам даны $n$ неотрицательных целых чисел, меньших $m$. Если мы переведём их в $k$-ичную систему счисления, то сможем отсортировать их поразрядной сортировкой за $\Theta\left(\left(1+\log _{k} m\right)(n+k)\right)$ (используя $\Theta\left(n\left(1+\log _{k} m\right)+k\right)$ дополнительной памяти). При $n=k$ получаем время работы $\left.\Theta\left(n+n \log _{n} m\right)\right)=\Theta\left(n+n \frac{\log m}{\log n}\right)$.