---
title: "12.7. Б-деревья"
date: 2026-04-02T09:30:00+03:00
draft: true
weight: 127
---

Б-дерево (B-tree) — это сбалансированное дерево поиска, специально разработанное для работы с данными на внешних носителях (дисках). В отличие от бинарных деревьев, узлы Б-дерева могут содержать множество ключей и детей.

## Мотивация: внешняя память

При работе с данными на диске время доступа к произвольной ячейке памяти (порядка миллисекунд) намного превышает время обращения к оперативной памяти (порядка наносекунд). Разница составляет около $10^6$ раз.

Поэтому при проектировании структур данных для внешней памяти нужно:
1. Минимизировать количество дисковых обращений
2. Считывать данные блоками (страницами)
3. Использовать большие узлы, соответствующие размеру дисковой страницы

>[!def]
>**Дисковая страница** — минимальная единица обмена данными между оперативной памятью и диском. Типичный размер: 4-64 КБ.

## Определение Б-дерева

>[!def]
>**Б-дерево порядка $m$** (или $(m/2, m)$-дерево) — это корневое дерево со следующими свойствами:
>
>1. Каждый узел содержит не более $m - 1$ ключей и не более $m$ детей.
>2. Каждый внутренний узел (кроме корня) содержит не менее $\lceil m/2 \rceil - 1$ ключей и не менее $\lceil m/2 \rceil$ детей.
>3. Корень содержит не менее одного ключа (если дерево не пусто).
>4. Все листья находятся на одном уровне.
>5. Узел с $k$ ключами имеет $k + 1$ детей.

```
Пример Б-дерева порядка m=5 (минимум 2 ключа, максимум 4 ключа):

                    [30, 70]
                   /    |    \
           [10, 20]  [40, 50, 60]  [80, 90]
           /  |  \    / | \ | \    /  |  \
         Л1  Л2  Л3  Л4 Л5 Л6 Л7  Л8  Л9  Л10
```

>[!def]
>В узле с ключами $k_1 < k_2 < \ldots < k_n$ и детьми $c_0, c_1, \ldots, c_n$:
>- Все ключи в поддереве $c_0$ меньше $k_1$
>- Все ключи в поддереве $c_i$ ($1 \leq i < n$) находятся между $k_i$ и $k_{i+1}$
>- Все ключи в поддереве $c_n$ больше $k_n$

## Оценка высоты

>[!theorem]
>Высота $h$ Б-дерева порядка $m$ с $n$ ключами удовлетворяет неравенству:
>$$
>h \leqslant \log_t \frac{n+1}{2} + 1
>$$
>где $t = \lceil m/2 \rceil$ — минимальная степень дерева.
>{{% notice style="prove" expanded="true" %}}
Найдём максимальное количество ключей в дереве высоты $h$.

На уровне 0 (корень) — не более $m - 1$ ключей.
На уровне 1 — не более $m \cdot (m - 1)$ ключей (у корня не более $m$ детей, у каждого — не более $m - 1$ ключей).
На уровне $i$ — не более $m^i \cdot (m - 1)$ ключей.

Итого максимум:
$$
n \leqslant (m - 1) \sum_{i=0}^{h-1} m^i = (m - 1) \cdot \frac{m^h - 1}{m - 1} = m^h - 1
$$
Откуда $h \geqslant \log_m(n + 1)$.

Теперь минимум. Минимум ключей на уровне $i$ ($i \geqslant 1$):
$$
t \cdot (t - 1) \cdot t^{i-1} = (t - 1) \cdot t^i
$$
Корень содержит не менее 1 ключа. Итого:
$$
n \geqslant 1 + (t - 1) \sum_{i=1}^{h-1} t^i = 1 + (t - 1) \cdot \frac{t^h - t}{t - 1} = 1 + t^h - t
$$
Откуда:
$$
h \leqslant \log_t \frac{n + t - 1}{t} + 1 \leqslant \log_t \frac{n + 1}{2} + 1
$$
{{% /notice %}}

>[!corollar]
>При $m = 1001$ (типичное значение для дисковых страниц) и $n = 10^9$ ключей высота Б-дерева не превышает 3. Это означает максимум 3-4 дисковых обращения для поиска любого ключа.

## Структура узла

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
class BTreeNode:
    def __init__(self, leaf=False):
        self.keys = []       # Список ключей
        self.children = []   # Список детей
        self.leaf = leaf     # Является ли листом


class BTree:
    def __init__(self, min_degree):
        self.t = min_degree  # Минимальная степень
        self.root = BTreeNode(leaf=True)

    # Максимум ключей в узле
    def max_keys(self):
        return 2 * self.t - 1

    # Минимум ключей в узле (кроме корня)
    def min_keys(self):
        return self.t - 1
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
template<typename T>
struct BTreeNode {
    std::vector<T> keys;           // Ключи
    std::vector<BTreeNode*> children;  // Дети
    bool leaf;                     // Является ли листом

    BTreeNode(bool isLeaf = false) : leaf(isLeaf) {}
};

template<typename T>
class BTree {
private:
    BTreeNode<T>* root;
    int t;  // Минимальная степень

    int maxKeys() { return 2 * t - 1; }
    int minKeys() { return t - 1; }

public:
    BTree(int minDegree) : t(minDegree) {
        root = new BTreeNode<T>(true);
    }
};
```
{{% /tab %}}
{{< /tabs >}}

## Поиск

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def search(self, key):
    """Поиск ключа в Б-дереве"""
    return self._search(self.root, key)


def _search(self, node, key):
    """Рекурсивный поиск"""
    # Находим позицию ключа или ребенка
    i = 0
    while i < len(node.keys) and key > node.keys[i]:
        i += 1

    # Нашли ключ
    if i < len(node.keys) and key == node.keys[i]:
        return node, i

    # Ключ не найден и это лист
    if node.leaf:
        return None, -1

    # Рекурсивный поиск в ребёнке
    # В реальной реализации здесь происходит чтение с диска
    return self._search(node.children[i], key)
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
std::pair<BTreeNode<T>*, int> search(BTreeNode<T>* node, const T& key) {
    // Находим позицию ключа или ребенка
    int i = 0;
    while (i < node->keys.size() && key > node->keys[i]) {
        i++;
    }

    // Нашли ключ
    if (i < node->keys.size() && key == node->keys[i]) {
        return {node, i};
    }

    // Ключ не найден и это лист
    if (node->leaf) {
        return {nullptr, -1};
    }

    // Рекурсивный поиск в ребёнке
    // В реальной реализации здесь происходит чтение с диска
    return search(node->children[i], key);
}

std::pair<BTreeNode<T>*, int> search(const T& key) {
    return search(root, key);
}
```
{{% /tab %}}
{{< /tabs >}}

Сложность поиска: $O(th) = O(t \log_t n)$ операций в памяти, но только $O(h) = O(\log_t n)$ дисковых обращений.

## Вставка

Вставка в Б-дерево выполняется за один проход от корня к листьям. Чтобы избежать переполнения узлов, используется предварительное расщепление полных узлов.

### Расщепление узла

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def split_child(self, parent, i):
    """Расщепление i-го ребёнка родителя"""
    full = parent.children[i]
    new_node = BTreeNode(leaf=full.leaf)

    # Переносим ключи: full получает [0, t-1), new_node — [t, 2t-1)
    mid_key = full.keys[self.t - 1]

    new_node.keys = full.keys[self.t:]  # Правая половина ключей
    full.keys = full.keys[:self.t - 1]   # Левая половина ключей

    # Переносим детей, если не лист
    if not full.leaf:
        new_node.children = full.children[self.t:]
        full.children = full.children[:self.t]

    # Вставляем средний ключ в родителя
    parent.keys.insert(i, mid_key)
    parent.children.insert(i + 1, new_node)
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
void splitChild(BTreeNode<T>* parent, int i) {
    BTreeNode<T>* full = parent->children[i];
    BTreeNode<T>* newNode = new BTreeNode<T>(full->leaf);

    // Переносим ключи: full получает [0, t-1), newNode — [t, 2t-1)
    T midKey = full->keys[t - 1];

    // Правая половина ключей
    newNode->keys.assign(full->keys.begin() + t, full->keys.end());
    // Левая половина ключей
    full->keys.resize(t - 1);

    // Переносим детей, если не лист
    if (!full->leaf) {
        newNode->children.assign(full->children.begin() + t, full->children.end());
        full->children.resize(t);
    }

    // Вставляем средний ключ в родителя
    parent->keys.insert(parent->keys.begin() + i, midKey);
    parent->children.insert(parent->children.begin() + i + 1, newNode);
}
```
{{% /tab %}}
{{< /tabs >}}

### Алгоритм вставки

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def insert(self, key):
    """Вставка ключа в Б-дерево"""
    root = self.root

    # Если корень полон, создаём новый корень
    if len(root.keys) == 2 * self.t - 1:
        new_root = BTreeNode()
        new_root.children.append(self.root)
        self.root = new_root
        self.split_child(new_root, 0)
        self._insert_nonfull(new_root, key)
    else:
        self._insert_nonfull(root, key)


def _insert_nonfull(self, node, key):
    """Вставка в неполный узел"""
    i = len(node.keys) - 1

    if node.leaf:
        # Вставляем ключ в лист
        node.keys.append(0)  # Расширяем список
        while i >= 0 and key < node.keys[i]:
            node.keys[i + 1] = node.keys[i]
            i -= 1
        node.keys[i + 1] = key
    else:
        # Ищем ребёнка для спуска
        while i >= 0 and key < node.keys[i]:
            i -= 1
        i += 1

        # Если ребёнок полон, расщепляем
        if len(node.children[i].keys) == 2 * self.t - 1:
            self.split_child(node, i)
            if key > node.keys[i]:
                i += 1

        self._insert_nonfull(node.children[i], key)
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
void insert(const T& key) {
    // Если корень полон, создаём новый корень
    if (root->keys.size() == 2 * t - 1) {
        BTreeNode<T>* newRoot = new BTreeNode<T>();
        newRoot->children.push_back(root);
        root = newRoot;
        splitChild(newRoot, 0);
        insertNonfull(newRoot, key);
    } else {
        insertNonfull(root, key);
    }
}

void insertNonfull(BTreeNode<T>* node, const T& key) {
    int i = node->keys.size() - 1;

    if (node->leaf) {
        // Вставляем ключ в лист
        node->keys.push_back(T{});
        while (i >= 0 && key < node->keys[i]) {
            node->keys[i + 1] = node->keys[i];
            i--;
        }
        node->keys[i + 1] = key;
    } else {
        // Ищем ребёнка для спуска
        while (i >= 0 && key < node->keys[i]) {
            i--;
        }
        i++;

        // Если ребёнок полон, расщепляем
        if (node->children[i]->keys.size() == 2 * t - 1) {
            splitChild(node, i);
            if (key > node->keys[i]) {
                i++;
            }
        }

        insertNonfull(node->children[i], key);
    }
}
```
{{% /tab %}}
{{< /tabs >}}

## Удаление

Удаление из Б-дерева сложнее вставки, так как нужно поддерживать минимальное количество ключей в узлах. Основные случаи:

1. Ключ в листе: просто удаляем
2. Ключ во внутреннем узле: заменяем на предшественника или последователя
3. Ребёнок имеет минимум ключей: заимствуем у брата или объединяем

Подробная реализация удаления опускается ввиду сложности (см. Cormen, Chapter 18).

## Варианты Б-деревьев

### B+ дерево

>[!def]
>**B+ дерево** — вариант Б-дерева, в котором:
>- Все ключи хранятся в листьях
>- Внутренние узлы содержат только копии ключей-разделителей
>- Листья связаны в связный список для эффективного обхода

B+ деревья используются в большинстве систем управления базами данных.

### B* дерево

>[!def]
>**B* дерево** — вариант Б-дерева, в котором:
>- Узлы заполнены минимум на $2/3$ (вместо $1/2$)
>- При переполнении узла ключи перераспределяются между братьями
>- Лишь при полном заполнении всех братьев происходит расщепление

B* деревья обеспечивают лучшее использование памяти, но требуют более сложных операций.

## Сложность операций

>[!props]
>Сложность операций в Б-дереве порядка $m$ с $n$ ключами:

| Операция | Дисковые обращения | Вычисления в памяти |
|----------|-------------------|---------------------|
| Поиск | $O(\log_t n)$ | $O(t \log_t n)$ |
| Вставка | $O(\log_t n)$ | $O(t \log_t n)$ |
| Удаление | $O(\log_t n)$ | $O(t \log_t n)$ |

где $t = \lceil m/2 \rceil$.

## Применение

>[!props]
>Б-деревья используются в:
>- Файловых системах (NTFS, HFS+, ext4)
>- Системах управления базами данных (MySQL, PostgreSQL, Oracle)
>- Ключ-значение хранилищах (LevelDB, RocksDB)

>[!corollar]
>Для типичных параметров ($m \approx 1000$, $n \approx 10^9$) любая операция требует не более 3-4 дисковых обращений, что делает Б-деревья исключительно эффективными для работы с большими объёмами данных.
