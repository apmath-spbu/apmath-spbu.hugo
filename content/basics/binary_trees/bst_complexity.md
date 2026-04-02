---
title: "12.4. BST: анализ сложности"
date: 2026-04-02T09:30:00+03:00
draft: true
weight: 124
---

## Высота BST

Высота BST критически влияет на эффективность всех операций. В зависимости от порядка вставки ключей, высота может варьироваться от логарифмической до линейной.

### Худший случай

>[!theorem]
>В худшем случае высота BST с $n$ вершинами равна $n - 1$.
>{{% notice style="prove" expanded="true" %}}
Худший случай достигается, когда ключи вставляются в возрастающем или убывающем порядке. Тогда каждый новый узел становится правым (или левым) ребёнком предыдущего, и дерево превращается в вырожденное — по сути, в связный список.

Пример: вставка ключей 1, 2, 3, 4, 5 даёт дерево:
```
1
 \
  2
   \
    3
     \
      4
       \
        5
```
Высота такого дерева равна $n - 1 = 4$.
{{% /notice %}}

В вырожденном дереве все операции (поиск, вставка, удаление) работают за $\Theta(n)$.

### Лучший случай

>[!theorem]
>В лучшем случае высота BST с $n$ вершинами равна $\lfloor \log_2 n \rfloor$.
>{{% notice style="prove" expanded="true" %}}
Лучший случай достигается, когда дерево является полным и сбалансированным. Если ключи вставляются в порядке, который даёт полное бинарное дерево (например, медиана, затем медианы левой и правой половин и т.д.), то высота будет минимальной.

Для полного бинарного дерева с $n$ вершинами высота равна $\lfloor \log_2 n \rfloor$.
{{% /notice %}}

### Средний случай

>[!theorem]
>Математическое ожидание высоты случайного BST (при случайном порядке вставки $n$ ключей) есть $O(\log n)$.
>{{% notice style="prove" expanded="true" %}}
Пусть $X_n$ — высота случайного BST с $n$ вершинами. Можно показать, что

$$
\mathbb{E}[X_n] \approx c \ln n
$$

где $c \approx 4.311$ — константа.

Интуитивное объяснение: при случайном порядке вставки каждый новый ключ с равной вероятностью попадает в левое или правое поддерево, что приводит к примерно сбалансированному дереву.

Более точная оценка (Reed, 2003):

$$
\mathbb{E}[X_n] = \alpha \ln n - \beta \ln\ln n + O(1)
$$

где $\alpha \approx 4.311$ и $\beta \approx 1.954$.
{{% /notice %}}

## Сложность операций

>[!props]
>Сложность основных операций BST:

| Операция | Лучший случай | Средний случай | Худший случай |
|----------|---------------|----------------|---------------|
| Поиск | $O(\log n)$ | $O(\log n)$ | $O(n)$ |
| Минимум/Максимум | $O(\log n)$ | $O(\log n)$ | $O(n)$ |
| Последователь/Предшественник | $O(\log n)$ | $O(\log n)$ | $O(n)$ |
| Вставка | $O(\log n)$ | $O(\log n)$ | $O(n)$ |
| Удаление | $O(\log n)$ | $O(\log n)$ | $O(n)$ |

## Рандомизированное BST

Чтобы гарантировать логарифмическую сложность в среднем, можно использовать рандомизированный подход.

### Идея

Вместо того чтобы вставлять ключи в заданном порядке, можно рандомизировать структуру дерева:

1. **Случайная вставка**: при вставке ключа $x$ в дерево размера $n$, с вероятностью $\frac{1}{n+1}$ делаем $x$ новым корнем, иначе рекурсивно вставляем в левое или правое поддерево.

2. **Случайное удаление**: при удалении узла с двумя детьми, выбор между заменой на предшественника или последователя делается случайно.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
import random

class RandomizedBST:
    def __init__(self):
        self.root = None
        self.size = 0

    def insert_at_root(self, key):
        """Вставка ключа как нового корня"""
        # Разбиваем дерево на left и right
        left, right = self._split(self.root, key)
        new_node = BSTNode(key)
        new_node.left = left
        new_node.right = right
        if left:
            left.parent = new_node
        if right:
            right.parent = new_node
        self.root = new_node

    def _split(self, node, key):
        """Разбиение дерева по ключу"""
        if node is None:
            return None, None

        if key < node.key:
            left, right = self._split(node.left, key)
            node.left = right
            if right:
                right.parent = node
            return left, node
        else:
            left, right = self._split(node.right, key)
            node.right = left
            if left:
                left.parent = node
            return node, right

    def insert(self, key):
        """Рандомизированная вставка"""
        if self.root is None:
            self.root = BSTNode(key)
            self.size = 1
            return

        # С вероятностью 1/(size+1) вставляем в корень
        if random.random() < 1.0 / (self.size + 1):
            self.insert_at_root(key)
        elif key < self.root.key:
            # Рекурсивно вставляем в левое поддерево
            old_root = self.root
            self.root = self.root.left
            self.insert(key)
            old_root.left = self.root
            self.root = old_root
        else:
            # Рекурсивно вставляем в правое поддерево
            old_root = self.root
            self.root = self.root.right
            self.insert(key)
            old_root.right = self.root
            self.root = old_root

        self.size += 1
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <random>
#include <cstdlib>

template<typename T>
class RandomizedBST {
private:
    BSTNode<T>* root;
    int size;

    std::pair<BSTNode<T>*, BSTNode<T>*> split(BSTNode<T>* node, const T& key) {
        if (node == nullptr) {
            return {nullptr, nullptr};
        }

        if (key < node->key) {
            auto [left, right] = split(node->left, key);
            node->left = right;
            if (right) right->parent = node;
            return {left, node};
        } else {
            auto [left, right] = split(node->right, key);
            node->right = left;
            if (left) left->parent = node;
            return {node, right};
        }
    }

    BSTNode<T>* insertAtRoot(BSTNode<T>* node, const T& key) {
        auto [left, right] = split(node, key);
        BSTNode<T>* newNode = new BSTNode<T>(key);
        newNode->left = left;
        newNode->right = right;
        if (left) left->parent = newNode;
        if (right) right->parent = newNode;
        return newNode;
    }

public:
    RandomizedBST() : root(nullptr), size(0) {}

    BSTNode<T>* insert(BSTNode<T>* node, const T& key) {
        if (node == nullptr) {
            size++;
            return new BSTNode<T>(key);
        }

        // С вероятностью 1/(size+1) вставляем в корень
        if (rand() % (size + 1) == 0) {
            size++;
            return insertAtRoot(node, key);
        }

        if (key < node->key) {
            node->left = insert(node->left, key);
            node->left->parent = node;
        } else {
            node->right = insert(node->right, key);
            node->right->parent = node;
        }

        return node;
    }

    void insert(const T& key) {
        root = insert(root, key);
    }
};
```
{{% /tab %}}
{{< /tabs >}}

>[!theorem]
>В рандомизированном BST математическое ожидание высоты есть $O(\log n)$, а все операции работают в среднем за $O(\log n)$.

## Сравнение с другими структурами данных

### Сравнение с хеш-таблицей

| Критерий | BST | Хеш-таблица |
|----------|-----|-------------|
| Поиск | $O(\log n)$ среднее | $O(1)$ среднее |
| Вставка | $O(\log n)$ среднее | $O(1)$ среднее |
| Удаление | $O(\log n)$ среднее | $O(1)$ среднее |
| Минимум/Максимум | $O(\log n)$ | $O(n)$ |
| Последователь/Предшественник | $O(\log n)$ | $O(n)$ |
| Упорядоченный обход | $O(n)$ | $O(n \log n)$ |
| Гарантии в худшем случае | Нет (если не сбалансировано) | Нет |

BST предпочтительнее, когда:
- Нужен упорядоченный обход
- Нужно находить минимум/максимум
- Нужны операции поиска следующего/предыдущего элемента
- Ключи сложно хешировать

### Сравнение с отсортированным массивом

| Критерий | BST | Отсортированный массив |
|----------|-----|------------------------|
| Поиск | $O(\log n)$ | $O(\log n)$ бинарный поиск |
| Вставка | $O(\log n)$ среднее | $O(n)$ |
| Удаление | $O(\log n)$ среднее | $O(n)$ |
| Минимум/Максимум | $O(\log n)$ или $O(1)$ с кэшированием | $O(1)$ |
| Память | $O(n)$ с указателями | $O(n)$ |
| Кэш-локальность | Низкая | Высокая |

Отсортированный массив предпочтительнее, когда:
- Данные статические (редко меняются)
- Важна кэш-локальность
- Нужен минимальный расход памяти

## Выбор структуры данных

```
                    Нужен упорядоченный обход?
                           /           \
                         Да             Нет
                          |               |
                     Нужны быстрые     Нужен O(1) поиск?
                     вставки/удаления?      /       \
                        /      \           Да        Нет
                      Да        Нет        |          |
                       |          |    Хеш-таблица  Массив
                   Сбаланси-  Отсорти-
                   рованное   рованный
                      BST      массив
```

## Резюме

>[!props]
>**Преимущества BST:**
>- Поддержка упорядоченных операций
>- Простая реализация
>- Гибкость в выборе типа ключей
>
>**Недостатки BST:**
>- Нет гарантий в худшем случае без балансировки
>- Высокая константа из-за указателей
>- Плохая кэш-локальность

Чтобы гарантировать логарифмическую сложность в худшем случае, используются **сбалансированные деревья поиска**: АВЛ-деревья, красно-чёрные деревья и другие, которые будут рассмотрены в следующих разделах.
