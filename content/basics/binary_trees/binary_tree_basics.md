---
title: "12.1. Бинарные деревья: определения и свойства"
date: 2026-04-02T09:30:00+03:00
draft: true
weight: 121
---

## Определение бинарного дерева

>[!def]
>**Бинарное дерево** (двоичное дерево) — это дерево, в котором каждая вершина имеет не более двух детей, называемых левым и правым потомками.

Формально, бинарное дерево — это либо пустое дерево, либо тройка $(r, L, R)$, где $r$ — корень, $L$ — левое поддерево (бинарное дерево), $R$ — правое поддерево (бинарное дерево).

Бинарное дерево отличается от общего дерева тем, что:

1. Каждый узел имеет не более двух детей
2. Дети различаются: левый и правый потомки — разные позиции
3. Порядок детей важен: дерево с левым ребёнком $A$ и правым $B$ отличается от дерева с левым $B$ и правым $A$

## Основные понятия

>[!def]
>- **Корень** — единственная вершина без родителя.
>- **Лист** — вершина без детей.
>- **Внутренняя вершина** — вершина, не являющаяся листом.
>- **Глубина вершины** — длина пути от корня до этой вершины (количество рёбер).
>- **Высота вершины** — длина самого длинного пути от этой вершины до листа.
>- **Высота дерева** — высота корня (максимальная глубина среди всех вершин).
>- **Уровень** — множество вершин с одинаковой глубиной.

>[!def]
>**Полное бинарное дерево** уровня $h$ — это бинарное дерево, в котором все уровни от $0$ до $h$ заполнены полностью (каждая внутренняя вершина имеет ровно двух детей, и все листья находятся на уровне $h$).

## Свойства бинарных деревьев

>[!theorem]
>В бинарном дереве на уровне $i$ находится не более $2^i$ вершин.
>{{% notice style="prove" expanded="true" %}}
Доказательство по индукции по $i$.

**База:** $i = 0$. На уровне $0$ находится только корень — одна вершина. $2^0 = 1$. Верно.

**Переход:** пусть на уровне $i$ находится не более $2^i$ вершин. Каждая вершина уровня $i$ имеет не более двух детей. Значит, на уровне $i+1$ находится не более $2 \cdot 2^i = 2^{i+1}$ вершин.
{{% /notice %}}

>[!theorem]
>В бинарном дереве высоты $h$ находится не более $2^{h+1} - 1$ вершин.
>{{% notice style="prove" expanded="true" %}}
Суммируем максимальное количество вершин на каждом уровне:

$$
\sum_{i=0}^{h} 2^i = 2^{h+1} - 1
$$

по формуле суммы геометрической прогрессии.
{{% /notice %}}

>[!corollar]
>Бинарное дерево с $n$ вершинами имеет высоту не менее $\lfloor \log_2 n \rfloor$.
>{{% notice style="prove" expanded="true" %}}
Из предыдущей теоремы: $n \leqslant 2^{h+1} - 1$, откуда $h \geqslant \log_2(n+1) - 1 = \log_2 \frac{n+1}{2}$.

Более точная оценка: $h \geqslant \lfloor \log_2 n \rfloor$.
{{% /notice %}}

>[!theorem]
>В бинарном дереве с $n$ вершинами количество листьев не менее $\lceil n/2 \rceil$ в дереве максимальной высоты и не более $n$ (тривиально) в дереве минимальной высоты. Для полного бинарного дерева количество листьев равно $2^h$, где $h$ — высота дерева.

>[!lemma]
>В полном бинарном дереве с $n$ вершинами высота равна $\lfloor \log_2 n \rfloor$.
>{{% notice style="prove" expanded="true" %}}
Для полного бинарного дерева высоты $h$:

$$
2^h \leqslant n < 2^{h+1}
$$

Откуда $h \leqslant \log_2 n < h + 1$, то есть $h = \lfloor \log_2 n \rfloor$.
{{% /notice %}}

## Типы бинарных деревьев

### Полное бинарное дерево

>[!def]
>**Полное бинарное дерево** — бинарное дерево, в котором все уровни полностью заполнены, кроме возможно последнего, причём последний уровень заполнен слева направо без пропусков.

```
Полное бинарное дерево:
        1
       / \
      2   3
     / \  /
    4  5 6
```

Полные бинарные деревья удобно представлять массивом (как в двоичной куче).

### Совершенное (идеально сбалансированное) бинарное дерево

>[!def]
>**Совершенное бинарное дерево** — полное бинарное дерево, в котором все листья находятся на одном уровне.

```
Совершенное бинарное дерево:
        1
       / \
      2   3
     / \ / \
    4  5 6  7
```

В совершенном бинарном дереве высоты $h$ ровно $2^{h+1} - 1$ вершин.

### Сбалансированное бинарное дерево

>[!def]
>Бинарное дерево называется **сбалансированным по высоте**, если для каждой вершины высоты её левого и правого поддеревьев отличаются не более чем на 1.

Сбалансированные деревья гарантируют высоту $O(\log n)$ и используются для эффективного поиска.

### Вырожденное дерево

>[!def]
>**Вырожденное дерево** — дерево, в котором каждая внутренняя вершина имеет ровно одного ребёнка. Такое дерево по сути является связным списком.

Вырожденное дерево с $n$ вершинами имеет высоту $n - 1$.

## Представления бинарных деревьев

### Представление на основе узлов

Каждый узел содержит данные и ссылки на левого и правого детей (и, возможно, на родителя).

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
class TreeNode:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None
        self.parent = None  # опционально

    def set_left(self, node):
        self.left = node
        if node is not None:
            node.parent = self

    def set_right(self, node):
        self.right = node
        if node is not None:
            node.parent = self


# Создание дерева:
#       1
#      / \
#     2   3
#    / \
#   4   5

root = TreeNode(1)
root.set_left(TreeNode(2))
root.set_right(TreeNode(3))
root.left.set_left(TreeNode(4))
root.left.set_right(TreeNode(5))
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
template<typename T>
struct TreeNode {
    T value;
    TreeNode* left;
    TreeNode* right;
    TreeNode* parent;  // опционально

    TreeNode(T val) : value(val), left(nullptr), right(nullptr), parent(nullptr) {}

    void setLeft(TreeNode* node) {
        left = node;
        if (node != nullptr) {
            node->parent = this;
        }
    }

    void setRight(TreeNode* node) {
        right = node;
        if (node != nullptr) {
            node->parent = this;
        }
    }
};

// Создание дерева:
//       1
//      / \
//     2   3
//    / \
//   4   5

int main() {
    auto* root = new TreeNode<int>(1);
    root->setLeft(new TreeNode<int>(2));
    root->setRight(new TreeNode<int>(3));
    root->left->setLeft(new TreeNode<int>(4));
    root->left->setRight(new TreeNode<int>(5));

    return 0;
}
```
{{% /tab %}}
{{< /tabs >}}

### Массивное представление

Полное бинарное дерево можно хранить в массиве. Для вершины с индексом $i$ (нумерация с 1):

- Левый ребёнок: $2i$
- Правый ребёнок: $2i + 1$
- Родитель: $\lfloor i / 2 \rfloor$

При нумерации с 0:

- Левый ребёнок: $2i + 1$
- Правый ребёнок: $2i + 2$
- Родитель: $\lfloor (i - 1) / 2 \rfloor$

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
class ArrayBinaryTree:
    def __init__(self):
        self.tree = []

    def root(self):
        return 0 if self.tree else -1

    def left_child(self, i):
        left = 2 * i + 1
        return left if left < len(self.tree) else -1

    def right_child(self, i):
        right = 2 * i + 2
        return right if right < len(self.tree) else -1

    def parent(self, i):
        return (i - 1) // 2 if i > 0 else -1

    def value(self, i):
        return self.tree[i] if 0 <= i < len(self.tree) else None

    def append(self, value):
        self.tree.append(value)


# Создание дерева:
#       1
#      / \
#     2   3
#    / \
#   4   5

tree = ArrayBinaryTree()
for val in [1, 2, 3, 4, 5]:
    tree.append(val)

print(tree.value(tree.left_child(0)))  # 2
print(tree.value(tree.right_child(0)))  # 3
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <vector>
#include <iostream>

class ArrayBinaryTree {
private:
    std::vector<int> tree;

public:
    int root() const {
        return tree.empty() ? -1 : 0;
    }

    int leftChild(int i) const {
        int left = 2 * i + 1;
        return left < tree.size() ? left : -1;
    }

    int rightChild(int i) const {
        int right = 2 * i + 2;
        return right < tree.size() ? right : -1;
    }

    int parent(int i) const {
        return i > 0 ? (i - 1) / 2 : -1;
    }

    int value(int i) const {
        return (i >= 0 && i < tree.size()) ? tree[i] : -1;
    }

    void append(int val) {
        tree.push_back(val);
    }
};

int main() {
    ArrayBinaryTree tree;
    for (int val : {1, 2, 3, 4, 5}) {
        tree.append(val);
    }

    std::cout << tree.value(tree.leftChild(0)) << std::endl;   // 2
    std::cout << tree.value(tree.rightChild(0)) << std::endl;  // 3

    return 0;
}
```
{{% /tab %}}
{{< /tabs >}}

Массивное представление эффективно для полных деревьев, но может приводить к большому расходу памяти для разреженных деревьев.

## Количество бинарных деревьев

>[!theorem]
>Количество различных бинарных деревьев с $n$ вершинами равно $C_n$ — $n$-му числу Каталана:
>$$
>C_n = \frac{1}{n+1} \binom{2n}{n}
>$$
>{{% notice style="prove" expanded="true" %}}
Пусть $T_n$ — количество бинарных деревьев с $n$ вершинами.

**База:** $T_0 = 1$ (пустое дерево).

**Рекуррентное соотношение:** Для дерева с $n$ вершинами корень занимает одну вершину. Если в левом поддереве $k$ вершин, то в правом — $n - 1 - k$ вершин. Суммируя по всем возможным $k$:

$$
T_n = \sum_{k=0}^{n-1} T_k \cdot T_{n-1-k}
$$

Это рекуррентное соотношение для чисел Каталана. Решение даёт формулу:

$$
T_n = C_n = \frac{1}{n+1} \binom{2n}{n}
$$
{{% /notice %}}

Числа Каталана растут экспоненциально: $C_n \approx \frac{4^n}{n^{3/2}\sqrt{\pi}}$.
