---
linkTitle: "15.10. Рекуррентные соотношения"
title: "15.10. Решение рекуррентных соотношений возведением матрицы в степень"
date: 2026-04-25T09:30:00+03:00
weight: 100
draft: false
---

>[!def]
>**Линейное рекуррентное соотношение** (_linear recurrence_) порядка $k$:
>$$f_j = a_1 f_{j-1} + a_2 f_{j-2} + \cdots + a_k f_{j-k} + b,$$
>с начальными значениями $f_0, \ldots, f_{k-1}$. Требуется найти $f_n$.

Простой способ — применить метод динамического программирования: вычислить все значения $f_j$ по очереди за $O(nk)$. Для более быстрого решения выпишем рекуррентное соотношение в матричном виде:

$$
\begin{pmatrix} f_j \\ f_{j-1} \\ \vdots \\ f_{j-k+1} \\ 1 \end{pmatrix}
= \begin{pmatrix}
a_1 & a_2 & \cdots & a_k & b \\
1   & 0   & \cdots & 0   & 0 \\
    & \ddots &     &     & \vdots \\
0   & \cdots & 1   & 0   & 0 \\
0   & 0   & \cdots & 0   & 1
\end{pmatrix}
\cdot
\begin{pmatrix} f_{j-1} \\ f_{j-2} \\ \vdots \\ f_{j-k} \\ 1 \end{pmatrix}.
$$

Тогда $f_n$ можно найти через $(n - k + 1)$-ю степень матрицы $(k+1) \times (k+1)$.

>[!theorem]
>$(n - k + 1)$-ю степень матрицы $(k+1) \times (k+1)$ можно вычислить за $O(k^3 \log n)$ с помощью быстрого возведения в степень. После этого $f_n$ находится за $O(k)$.
>>[!prove]+
>>Быстрое возведение матрицы $M$ в степень $p$ использует разложение $p$ в двоичной системе: $M^p = M^{p_1} \cdot M^{p_2} \cdots$, где $p = p_1 + p_2 + \cdots$, $p_i$ — степени двойки. Каждое умножение двух $(k+1) \times (k+1)$ матриц стоит $O(k^2 \cdot k) = O(k^3)$; умножений не более $O(\log n)$.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def mat_mul(A: list[list[int]], B: list[list[int]],
            mod: int = 10**18) -> list[list[int]]:
    """Перемножение матриц A и B."""
    n = len(A)
    C = [[0] * n for _ in range(n)]
    for i in range(n):
        for k in range(n):
            if A[i][k] == 0:
                continue
            for j in range(n):
                C[i][j] = (C[i][j] + A[i][k] * B[k][j]) % mod
    return C

def mat_pow(M: list[list[int]], p: int,
            mod: int = 10**18) -> list[list[int]]:
    """Быстрое возведение матрицы в степень p."""
    n = len(M)
    result = [[int(i == j) for j in range(n)] for i in range(n)]  # единичная
    while p > 0:
        if p & 1:
            result = mat_mul(result, M, mod)
        M = mat_mul(M, M, mod)
        p >>= 1
    return result

def solve_recurrence(a: list[int], b: int,
                     init: list[int], n: int,
                     mod: int = 10**18) -> int:
    """
    a[i] — коэффициенты (a[0] = a_1, ..., a[k-1] = a_k),
    b — свободный член, init = [f_0, ..., f_{k-1}], n — индекс.
    """
    k = len(a)
    if n < k:
        return init[n]
    # Строим матрицу перехода (k+1) x (k+1)
    size = k + 1
    M = [[0] * size for _ in range(size)]
    for j in range(k):
        M[0][j] = a[j]
    M[0][k] = b
    for i in range(1, k):
        M[i][i-1] = 1
    M[k][k] = 1

    Mn = mat_pow(M, n - k + 1, mod)
    # Начальный вектор [f_{k-1}, f_{k-2}, ..., f_0, 1]
    v = init[k-1::-1] + [1]
    return sum(Mn[0][j] * v[j] for j in range(size)) % mod
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <algorithm>
using namespace std;

using Matrix = vector<vector<long long>>;
const long long MOD = 1e9 + 7;

Matrix matMul(const Matrix& A, const Matrix& B) {
    int n = A.size();
    Matrix C(n, vector<long long>(n, 0));
    for (int i = 0; i < n; i++)
        for (int k = 0; k < n; k++) {
            if (!A[i][k]) continue;
            for (int j = 0; j < n; j++)
                C[i][j] = (C[i][j] + A[i][k] * B[k][j]) % MOD;
        }
    return C;
}

Matrix matPow(Matrix M, long long p) {
    int n = M.size();
    Matrix result(n, vector<long long>(n, 0));
    for (int i = 0; i < n; i++) result[i][i] = 1;  // единичная
    while (p > 0) {
        if (p & 1) result = matMul(result, M);
        M = matMul(M, M);
        p >>= 1;
    }
    return result;
}

// a[i] — коэффициенты (a[0] = a_1, ...), b — свободный член
// init = {f_0, ..., f_{k-1}}, n — индекс
long long solveRecurrence(vector<long long>& a, long long b,
                           vector<long long>& init, long long n) {
    int k = a.size();
    if (n < k) return init[n];
    int sz = k + 1;
    Matrix M(sz, vector<long long>(sz, 0));
    for (int j = 0; j < k; j++) M[0][j] = a[j] % MOD;
    M[0][k] = b % MOD;
    for (int i = 1; i < k; i++) M[i][i-1] = 1;
    M[k][k] = 1;
    auto Mn = matPow(M, n - k + 1);
    long long ans = 0;
    for (int j = 0; j < k; j++)
        ans = (ans + Mn[0][j] * (init[k-1-j] % MOD)) % MOD;
    ans = (ans + Mn[0][k] * b) % MOD;
    return ans;
}
```
{{% /tab %}}
{{< /tabs >}}

### Пример: числа Фибоначчи

Применим этот метод к числам Фибоначчи. Поскольку рекуррентное соотношение $f_n = f_{n-1} + f_{n-2}$ не содержит свободного члена, можно обойтись без последних строки и столбца матрицы.

$$
\binom{f_n}{f_{n-1}} = \begin{pmatrix} 1 & 1 \\ 1 & 0 \end{pmatrix}^{n-1} \cdot \binom{1}{1}.
$$

>[!props]
>С учётом того, что $f_n$ имеет длину $\Theta(n)$, и при использовании алгоритма Карацубы для умножения чисел, полное время вычисления $f_n$ составляет $O(n^{\log_2 3})$. Тот же метод возведения матрицы в степень применим к любой задаче, сводящейся к [произведению матриц]({{% relref "basics/dynamic_programming/matrices_multiplication" %}}).
