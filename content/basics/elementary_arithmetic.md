---
title: "2. Элементарная арифметика"
date: 2026-02-13T09:30:00+03:00
draft: false
weight: 20
---

Современные компьютеры умеют за одну элементарную операцию складывать два 32(или 64)-битных числа. Часто (например, в криптографии) приходится работать с куда более длинными числами. Поговорим о том, как проводить с ними элементарные арифметические операции.

Для удобства будем считать, что на вход алгоритмам даются натуральные числа в двоичной записи. Мы будем работать с числами, имеющими двоичную запись длины $n$ (возможно, с ведущими нулями).

✍️ В произвольном случае можно применить соответствующий алгоритм для $n$ равного максимуму из длин чисел, а в конце определить длину записи результата применения операции (удалить ведущие нули), что потребует $O(n)$ операций и не повлияет на оценку сложности алгоритма.

### Сложение

Используем всем знакомый со школы способ сложения чисел в столбик:
{{< tabs >}}
{{% tab color="blue" title="python" %}}
```py
def add(a: List[int], b: List[int], n: int) -> List[int]:
    """
    Add two binary numbers represented as lists of digits.
    
    Args:
        a: First binary number as list of digits (LSB at index 0)
        b: Second binary number as list of digits (LSB at index 0)
        n: Length of the input arrays
        
    Returns:
        List[int]: Binary sum with length n+1 (LSB at index 0)
    """
    # Create result array of length n+1, filled with zeros
    c: List[int] = [0] * (n + 1)
    
    # Add digits with carry propagation
    for i in range(n):
        c[i] += a[i] + b[i]
        if c[i] >= 2:
            c[i + 1] += c[i] // 2  # Carry to next position
            c[i] = c[i] % 2         # Keep only the remainder
    
    return c
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
/**
 * Add two binary numbers represented as vectors of digits.
 * 
 * @param a First binary number as vector of digits (LSB at index 0)
 * @param b Second binary number as vector of digits (LSB at index 0)
 * @param n Length of the input vectors
 * @return Binary sum as vector with length n+1 (LSB at index 0)
 */
std::vector<int> add(const std::vector<int>& a, const std::vector<int>& b, int n) {
    // Create result vector of length n+1, filled with zeros
    std::vector<int> c(n + 1, 0);
    
    // Add digits with carry propagation
    for (int i = 0; i < n; ++i) {
        c[i] += a[i] + b[i];
        if (c[i] >= 2) {
            c[i + 1] += c[i] / 2;  // Carry to next position
            c[i] = c[i] % 2;        // Keep only the remainder
        }
    }
    
    return c;
}
```
{{% /tab %}}
{{< /tabs >}}

Время работы алгоритма - $O(n)$, существенно быстрее нельзя, потому что столько времени занимает уже считывание входных данных или вывод ответа.

✍️ Аналогичный алгоритм можно написать для чисел, записанных в $b$-ичной системе счисления. Если сумма трёх $b$-ичных чисел помещается в 32(64)-битный тип данных, то алгоритм всё ещё будет корректен. При этом $n$-битное число будет иметь примерно $\frac{n}{\log b}$ цифр в $b$-ичной записи, то есть алгоритм будет работать за $O\left(\frac{n}{\log b}\right)=O(n)$, так как $\frac{1}{\log b}$ - это константа. Тем не менее, это может дать ускорение в несколько десятков раз, что безусловно бывает полезно на практике.

### Умножение

Вспомним теперь и школьное умножение чисел в столбик (заметим лишь, что ответ имеет длину не больше $2 n$, поскольку $\left.\left(2^{n}-1\right) \cdot\left(2^{n}-1\right)<2^{2 n}\right)$ :
{{< tabs >}}
{{% tab color="blue" title="python" %}}
```py
def multiply(a: List[int], b: List[int], n: int) -> List[int]:
    """
    Multiply two binary numbers represented as lists of bits.
    
    Args:
        a: First binary number as list of bits (LSB at index 0)
        b: Second binary number as list of bits (LSB at index 0)
        n: Number of bits in each input
    
    Returns:
        List[int]: Product as binary number (LSB at index 0)
    """
    # Initialize result array of size 2n with zeros
    c: List[int] = [0] * (2 * n)
    
    # Multiply each pair of bits
    for i in range(n):
        for j in range(n):
            c[i + j] += a[i] * b[j]
    
    # Propagate carries
    for i in range(2 * n - 1):
        if c[i] >= 2:
            c[i + 1] += c[i] // 2
            c[i] %= 2
    
    return c
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
std::vector<int> multiply(const std::vector<int>& a, const std::vector<int>& b, int n) {
    // Initialize result array of size 2n with zeros
    std::vector<int> c(2 * n, 0);
    
    // Multiply each pair of bits
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            c[i + j] += a[i] * b[j];
        }
    }
    
    // Propagate carries
    for (int i = 0; i < 2 * n - 1; i++) {
        if (c[i] >= 2) {
            c[i + 1] += c[i] / 2;
            c[i] %= 2;
        }
    }
    
    return c;
}
```
{{% /tab %}}
{{< /tabs >}}

Из-за двух вложенных циклов время работы этого алгоритма - уже $O\left(n^{2}\right)$.
Приведём альтернативный рекурсивный алгоритм умножения двух чисел, пользующийся следующим правилом:

$$
a \cdot b= \begin{cases}2 \cdot\left(a \cdot\left\lfloor\frac{b}{2}\right\rfloor\right), & \text { если } b \text { чётно, } \\ a+2 \cdot\left(a \cdot\left\lfloor\frac{b}{2}\right\rfloor\right), & \text { иначе. }\end{cases}
$$

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```py
def multiply(a: int, b: int) -> int:
    """
    Multiply two integers using recursive binary multiplication.
    
    Args:
        a: First integer
        b: Second integer
    
    Returns:
        Product of a and b
    """
    # Base case
    if b == 0:
        return 0
    
    # Recursive case
    c = multiply(a, b // 2)  # Integer division
    
    if b % 2 == 0:
        return 2 * c
    else:
        return 2 * c + a
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
/**
 * Multiply two integers using recursive binary multiplication.
 * 
 * @param a First integer
 * @param b Second integer
 * @return Product of a and b
 */
int multiply(int a, int b) {
    // Base case
    if (b == 0) {
        return 0;
    }
    
    // Recursive case
    int c = multiply(a, b / 2);  // Integer division
    
    if (b % 2 == 0) {
        return 2 * c;
    } else {
        return 2 * c + a;
    }
}
```
{{% /tab %}}
{{% tab color="blue" title="c++ (optimized)" %}}
```cpp
/**
 * Optimized multiplication using bit manipulation.
 * This implements Russian peasant multiplication using bit operations.
 * 
 * @param a First integer
 * @param b Second integer
 * @return Product of a and b
 */
int multiplyOptimized(int a, int b) {
    // Base case
    if (b == 0) return 0;
    
    // Recursive case with bit manipulation
    int c = multiplyOptimized(a, b >> 1);  // b >> 1 is same as b/2
    
    // Check if b is even using bitwise AND
    if ((b & 1) == 0) {  // b is even if LSB is 0
        return c << 1;   // Multiply by 2 using left shift
    } else {
        return (c << 1) + a;  // (2*c) + a
    }
}
```
{{% /tab %}}
{{% tab color="blue" title="c++ (optimized, iterative)" %}}
```cpp
/**
 * Iterative version using bit manipulation (more efficient).
 * This avoids recursion overhead.
 * 
 * @param a First integer
 * @param b Second integer
 * @return Product of a and b
 */
int multiplyIterative(int a, int b) {
    int result = 0;
    
    // Russian peasant multiplication
    while (b > 0) {
        // If current bit of b is set, add a to result
        if (b & 1) {
            result += a;
        }
        
        // Double a and halve b using bit operations
        a <<= 1;   // a = a * 2
        b >>= 1;   // b = b / 2
    }
    
    return result;
}
```
{{% /tab %}}
{{< /tabs >}}

В этой схематичной записи под делением на два имеется в виду битовый сдвиг вправо (то есть взятие двоичной записи без младшего бита), под умножением на два - битовый сдвиг влево (добавление нуля в начало битовой записи). Остаток по модулю два - это младший бит числа.

Алгоритм произведёт $O(n)$ рекурсивных вызовов, поскольку при каждом вызове длина битовой записи $b$ уменьшается на один. В каждом вызове функции происходят битовый сдвиг влево, битовый сдвиг вправо, и, возможно сложение - всего $O(n)$ элементарных операций. Таким образом, общее время работы снова $O\left(n^{2}\right)$.

Заметим, что если длины битовых записей $a$ и $b$ равны $n$ и $m$, то время работы обоих алгоритмов можно оценить как $O(n m)$.

### Деление

Пусть теперь мы хотим поделить $a$ на $b$, то есть найти такие $q, r$, что $a=q b+r$ и $0 \leqslant r < b$. Здесь работает похожая идея: обозначим за $q^{\prime}, r^{\prime}$ результат деления $\left\lfloor\frac{a}{2}\right\rfloor$ на $b$, тогда:

$$
(q, r)= \begin{cases}\left(2 \cdot q^{\prime}+\left\lfloor\frac{2 \cdot r^{\prime}}{b}\right\rfloor, 2 \cdot r^{\prime}-\left\lfloor\frac{2 \cdot r^{\prime}}{b}\right\rfloor \cdot b\right), & \text { если } a \text { чётно, } \\ \left(2 \cdot q^{\prime}+\left\lfloor\frac{2 \cdot r^{\prime}+1}{b}\right\rfloor, 2 \cdot r^{\prime}+1-\left\lfloor\frac{2 \cdot r^{\prime}+1}{b}\right\rfloor \cdot b\right), & \text { иначе. }\end{cases}
$$

При этом $\left\lfloor\frac{2 \cdot r^{\prime}}{b}\right\rfloor,\left\lfloor\frac{2 \cdot r^{\prime}+1}{b}\right\rfloor \leqslant 1$. Получаем следующий рекурсивный алгоритм:
{{< tabs >}}
{{% tab color="blue" title="python" %}}
```py
def divide(a: int, b: int) -> tuple[int, int]:
    """
    Divide two binary numbers (represented as integers) recursively.
    
    Args:
        a: Dividend (binary number as integer)
        b: Divisor (binary number as integer)
    
    Returns:
        tuple[int, int]: (quotient, remainder) such that a = q * b + r, 0 ≤ r < b
    
    Raises:
        ZeroDivisionError: If b is zero
    """
    # Handle division by zero
    if b == 0:
        raise ZeroDivisionError("Division by zero")
    
    # Handle negative numbers (optional extension)
    # For simplicity, this implementation assumes non-negative inputs
    
    # Base case
    if a == 0:
        return 0, 0
    
    # Recursive case: divide a//2 by b
    q, r = divide(a // 2, b)
    
    # Since we divided a by 2, we need to multiply quotient and remainder by 2
    q = q * 2
    r = r * 2
    
    # If a was odd, add 1 to remainder
    if a % 2 == 1:
        r += 1
    
    # If remainder >= divisor, adjust quotient and remainder
    if r >= b:
        q += 1
        r -= b
    
    return q, r
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
/**
 * Divide two binary numbers (represented as integers) recursively.
 * 
 * @param a Dividend (binary number as integer)
 * @param b Divisor (binary number as integer)
 * @return std::pair<int, int> (quotient, remainder) such that a = q * b + r, 0 ≤ r < b
 * @throws std::invalid_argument if b is zero
 */
std::pair<int, int> divide(int a, int b) {
    // Handle division by zero
    if (b == 0) {
        throw std::invalid_argument("Division by zero");
    }
    
    // Handle negative numbers (optional extension)
    // For simplicity, this implementation assumes non-negative inputs
    
    // Base case
    if (a == 0) {
        return {0, 0};
    }
    
    // Recursive case: divide a/2 by b
    auto [q, r] = divide(a / 2, b);
    
    // Since we divided a by 2, we need to multiply quotient and remainder by 2
    q = q * 2;
    r = r * 2;
    
    // If a was odd, add 1 to remainder
    if (a % 2 == 1) {
        r += 1;
    }
    
    // If remainder >= divisor, adjust quotient and remainder
    if (r >= b) {
        q += 1;
        r -= b;
    }
    
    return {q, r};
}
```
{{% /tab %}}
{{< /tabs >}}

Снова имеем $O(n)$ рекурсивных вызовов, в каждом из которых происходит константное число битовых сдвигов и сложений (вычитаний), поэтому время работы снова оценивается как $O\left(n^{2}\right)$.

Альтернативный способ - школьное деление в столбик:
{{< tabs >}}
{{% tab color="blue" title="python" %}}
```py
def divide(a: int, b: int) -> tuple[int, int]:
    """
    Divide two binary numbers (represented as integers) recursively.
    
    Args:
        a: Dividend (binary number as integer)
        b: Divisor (binary number as integer)
    
    Returns:
        tuple[int, int]: (quotient, remainder) such that a = q * b + r, 0 ≤ r < b
    
    Raises:
        ZeroDivisionError: If b is zero
    """
    # Handle division by zero
    if b == 0:
        raise ZeroDivisionError("Division by zero")
    
    # Handle negative numbers (optional extension)
    # For simplicity, this implementation assumes non-negative inputs
    
    # Base case
    if a == 0:
        return 0, 0
    
    # Recursive case: divide a//2 by b
    q, r = divide(a // 2, b)
    
    # Since we divided a by 2, we need to multiply quotient and remainder by 2
    q = q * 2
    r = r * 2
    
    # If a was odd, add 1 to remainder
    if a % 2 == 1:
        r += 1
    
    # If remainder >= divisor, adjust quotient and remainder
    if r >= b:
        q += 1
        r -= b
    
    return q, r
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
/**
 * Divide two binary numbers (represented as integers) recursively.
 * 
 * @param a Dividend (binary number as integer)
 * @param b Divisor (binary number as integer)
 * @return std::pair<int, int> (quotient, remainder) such that a = q * b + r, 0 ≤ r < b
 * @throws std::invalid_argument if b is zero
 */
std::pair<int, int> divide(int a, int b) {
    // Handle division by zero
    if (b == 0) {
        throw std::invalid_argument("Division by zero");
    }
    
    // Handle negative numbers (optional extension)
    // For simplicity, this implementation assumes non-negative inputs
    
    // Base case
    if (a == 0) {
        return {0, 0};
    }
    
    // Recursive case: divide a/2 by b
    auto [q, r] = divide(a / 2, b);
    
    // Since we divided a by 2, we need to multiply quotient and remainder by 2
    q = q * 2;
    r = r * 2;
    
    // If a was odd, add 1 to remainder
    if (a % 2 == 1) {
        r += 1;
    }
    
    // If remainder >= divisor, adjust quotient and remainder
    if (r >= b) {
        q += 1;
        r -= b;
    }
    
    return {q, r};
}
```
{{% /tab %}}
{{< /tabs >}}

{{< tabs >}}
{{% tab color="blue" title="псевдокод" %}}
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
{{% /tab %}}
{{< /tabs >}}

Время работы, как и в предыдущем случае, оценивается как $O\left(n^{2}\right)$. Есть и более точная в некоторых случаях оценка: если длины битовых записей $a$ и $b$ равны $n$ и $m$, то количество итераций цикла не превосходит $n-m+1$, поэтому получаем оценку $O(n(n-m+1))$.

### Алгоритм Карацубы

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
{{< tabs >}}
{{% tab color="blue" title="псевдокод" %}}
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
{{% /tab %}}
{{< /tabs >}}

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
