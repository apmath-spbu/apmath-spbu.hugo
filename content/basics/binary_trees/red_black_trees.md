---
title: "12.6. Красно-чёрные деревья (основы)"
date: 2026-04-02T09:30:00+03:00
draft: true
weight: 126
---

Красно-чёрное дерево (Red-Black Tree, RB-tree) — это самобалансирующееся двоичное дерево поиска, которое обеспечивает логарифмическую высоту с меньшим количеством вращений, чем АВЛ-дерево.

## Свойства красно-чёрного дерева

>[!def]
>**Красно-чёрное дерево** — это двоичное дерево поиска, в котором каждая вершина имеет дополнительный бит информации — цвет (красный или чёрный), и выполняются следующие пять свойств:

>[!props] Свойства красно-чёрного дерева
>1. **Каждая вершина либо красная, либо чёрная.**
>2. **Корень дерева — чёрный.**
>3. **Все листья (NIL-вершины) — чёрные.**
>4. **Если вершина красная, то оба её ребёнка — чёрные.** (Не может быть двух красных вершин подряд на пути от корня к листу.)
>5. **Все пути от любой вершины до листьев (NIL-вершин) содержат одинаковое количество чёрных вершин.** Это число называется **чёрной высотой** вершины.

```
Пример красно-чёрного дерева:
(чёрные вершины показаны квадратами, красные — кругами)

           ■7
          /   \
        ●3     ■18
        / \    /   \
      ■2  ■5 ●11    ■22
                \    / \
                ●14●17 ●27

Свойства:
- Корень 7 — чёрный ✓
- Нет двух красных подряд ✓
- Чёрная высота от любого узла до листьев одинакова ✓
```

>[!def]
>**Чёрная высота** вершины $v$, обозначаемая $bh(v)$, — это количество чёрных вершин на любом пути от $v$ до листа (не считая саму $v$).

## Оценка высоты

>[!theorem]
>Красно-чёрное дерево с $n$ внутренними вершинами имеет высоту не более $2\log_2(n+1)$.
>{{% notice style="prove" expanded="true" %}}
**Лемма:** Поддерево красно-чёрного дерева с чёрной высотой $bh$ содержит не менее $2^{bh} - 1$ внутренних вершин.

*Доказательство леммы по индукции по $bh$:*
- База: $bh = 0$. Поддерево пустое, $2^0 - 1 = 0$ вершин. Верно.
- Переход: пусть для $bh$ утверждение верно. Рассмотрим вершину с чёрной высотой $bh + 1$. Её дети имеют чёрную высоту $bh$ (если ребёнок чёрный) или $bh$ (если ребёнок красный, то его дети — чёрные с высотой $bh$). В обоих случаях каждый ребёнок содержит не менее $2^{bh} - 1$ вершин. Итого: $(2^{bh} - 1) + (2^{bh} - 1) + 1 = 2^{bh+1} - 1$.

**Доказательство теоремы:**
Пусть $h$ — высота дерева. По свойству 4, на любом пути от корня до листа не менее половины вершин — чёрные (так как красная вершина не может иметь красного родителя). Значит:

$$
bh(\text{root}) \geqslant \frac{h}{2}
$$

По лемме:

$$
n \geqslant 2^{bh(\text{root})} - 1 \geqslant 2^{h/2} - 1
$$

Откуда:

$$
h \leqslant 2\log_2(n+1)
$$
{{% /notice %}}

>[!corollar]
>Все операции в красно-чёрном дереве работают за $O(\log n)$.

## Структура узла

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
class Color:
    RED = 0
    BLACK = 1


class RBNode:
    def __init__(self, key, color=Color.RED):
        self.key = key
        self.color = color
        self.left = None
        self.right = None
        self.parent = None


class RBTree:
    def __init__(self):
        self.NIL = RBNode(None, Color.BLACK)  # Сторожевой узел
        self.root = self.NIL
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
enum Color { RED, BLACK };

template<typename T>
struct RBNode {
    T key;
    Color color;
    RBNode* left;
    RBNode* right;
    RBNode* parent;

    RBNode(T k, Color c = RED) : key(k), color(c), left(nullptr), right(nullptr), parent(nullptr) {}
};

template<typename T>
class RBTree {
private:
    RBNode<T>* NIL;  // Сторожевой узел
    RBNode<T>* root;

public:
    RBTree() {
        NIL = new RBNode<T>(T{}, BLACK);
        NIL->left = NIL->right = NIL->parent = NIL;
        root = NIL;
    }
};
```
{{% /tab %}}
{{< /tabs >}}

## Вращения

Вращения в красно-чёрном дереве аналогичны вращениям в АВЛ-дереве, но нужно корректно обновлять цвета и родительские ссылки.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def left_rotate(self, x):
    """Левое вращение вокруг x"""
    y = x.right
    x.right = y.left

    if y.left != self.NIL:
        y.left.parent = x

    y.parent = x.parent

    if x.parent == self.NIL:
        self.root = y
    elif x == x.parent.left:
        x.parent.left = y
    else:
        x.parent.right = y

    y.left = x
    x.parent = y


def right_rotate(self, y):
    """Правое вращение вокруг y"""
    x = y.left
    y.left = x.right

    if x.right != self.NIL:
        x.right.parent = y

    x.parent = y.parent

    if y.parent == self.NIL:
        self.root = x
    elif y == y.parent.right:
        y.parent.right = x
    else:
        y.parent.left = x

    x.right = y
    y.parent = x
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
void leftRotate(RBNode<T>* x) {
    RBNode<T>* y = x->right;
    x->right = y->left;

    if (y->left != NIL) {
        y->left->parent = x;
    }

    y->parent = x->parent;

    if (x->parent == NIL) {
        root = y;
    } else if (x == x->parent->left) {
        x->parent->left = y;
    } else {
        x->parent->right = y;
    }

    y->left = x;
    x->parent = y;
}

void rightRotate(RBNode<T>* y) {
    RBNode<T>* x = y->left;
    y->left = x->right;

    if (x->right != NIL) {
        x->right->parent = y;
    }

    x->parent = y->parent;

    if (y->parent == NIL) {
        root = x;
    } else if (y == y->parent->right) {
        y->parent->right = x;
    } else {
        y->parent->left = x;
    }

    x->right = y;
    y->parent = x;
}
```
{{% /tab %}}
{{< /tabs >}}

## Вставка

Вставка состоит из двух этапов:
1. Обычная вставка как в BST (новый узел — красный)
2. Восстановление свойств красно-чёрного дерева

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def insert(self, key):
    """Вставка ключа в красно-чёрное дерево"""
    node = RBNode(key)
    node.left = self.NIL
    node.right = self.NIL

    parent = self.NIL
    current = self.root

    # Поиск места для вставки
    while current != self.NIL:
        parent = current
        if node.key < current.key:
            current = current.left
        else:
            current = current.right

    node.parent = parent

    if parent == self.NIL:
        self.root = node
    elif node.key < parent.key:
        parent.left = node
    else:
        parent.right = node

    # Восстановление свойств
    self.insert_fixup(node)


def insert_fixup(self, node):
    """Восстановление свойств после вставки"""
    while node.parent.color == Color.RED:
        if node.parent == node.parent.parent.left:
            uncle = node.parent.parent.right

            if uncle.color == Color.RED:
                # Случай 1: дядя красный
                node.parent.color = Color.BLACK
                uncle.color = Color.BLACK
                node.parent.parent.color = Color.RED
                node = node.parent.parent
            else:
                if node == node.parent.right:
                    # Случай 2: дядя чёрный, узел — правый ребёнок
                    node = node.parent
                    self.left_rotate(node)

                # Случай 3: дядя чёрный, узел — левый ребёнок
                node.parent.color = Color.BLACK
                node.parent.parent.color = Color.RED
                self.right_rotate(node.parent.parent)
        else:
            # Симметричные случаи для правого поддерева
            uncle = node.parent.parent.left

            if uncle.color == Color.RED:
                node.parent.color = Color.BLACK
                uncle.color = Color.BLACK
                node.parent.parent.color = Color.RED
                node = node.parent.parent
            else:
                if node == node.parent.left:
                    node = node.parent
                    self.right_rotate(node)

                node.parent.color = Color.BLACK
                node.parent.parent.color = Color.RED
                self.left_rotate(node.parent.parent)

    self.root.color = Color.BLACK
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
void insert(const T& key) {
    RBNode<T>* node = new RBNode<T>(key);
    node->left = NIL;
    node->right = NIL;

    RBNode<T>* parent = NIL;
    RBNode<T>* current = root;

    // Поиск места для вставки
    while (current != NIL) {
        parent = current;
        if (node->key < current->key) {
            current = current->left;
        } else {
            current = current->right;
        }
    }

    node->parent = parent;

    if (parent == NIL) {
        root = node;
    } else if (node->key < parent->key) {
        parent->left = node;
    } else {
        parent->right = node;
    }

    // Восстановление свойств
    insertFixup(node);
}

void insertFixup(RBNode<T>* node) {
    while (node->parent->color == RED) {
        if (node->parent == node->parent->parent->left) {
            RBNode<T>* uncle = node->parent->parent->right;

            if (uncle->color == RED) {
                // Случай 1: дядя красный
                node->parent->color = BLACK;
                uncle->color = BLACK;
                node->parent->parent->color = RED;
                node = node->parent->parent;
            } else {
                if (node == node->parent->right) {
                    // Случай 2: дядя чёрный, узел — правый ребёнок
                    node = node->parent;
                    leftRotate(node);
                }

                // Случай 3: дядя чёрный, узел — левый ребёнок
                node->parent->color = BLACK;
                node->parent->parent->color = RED;
                rightRotate(node->parent->parent);
            }
        } else {
            // Симметричные случаи
            RBNode<T>* uncle = node->parent->parent->left;

            if (uncle->color == RED) {
                node->parent->color = BLACK;
                uncle->color = BLACK;
                node->parent->parent->color = RED;
                node = node->parent->parent;
            } else {
                if (node == node->parent->left) {
                    node = node->parent;
                    rightRotate(node);
                }

                node->parent->color = BLACK;
                node->parent->parent->color = RED;
                leftRotate(node->parent->parent);
            }
        }
    }

    root->color = BLACK;
}
```
{{% /tab %}}
{{< /tabs >}}

### Случаи восстановления после вставки

**Случай 1:** Дядя красный. Перекрашиваем родителя, дядю и дедушку.

```
        ■G                    ●G
        / \                   / \
      ●P   ●U    →          ■P   ■U
       |                     |
      ●N                    ●N
```

**Случай 2:** Дядя чёрный, узел — "внутренний" ребёнок. Поворот вокруг родителя.

```
        ■G                    ■G
        / \                   / \
      ●P   ■U    →          ●N   ■U
        \                   /
        ●N                ●P
```

**Случай 3:** Дядя чёрный, узел — "внешний" ребёнок. Поворот вокруг дедушки.

```
        ■G                    ■P
        / \                   / \
      ●P   ■U    →          ●N   ●G
       |                           \
      ●N                           ■U
```

## Удаление

Удаление в красно-чёрном дереве сложнее вставки и требует до трёх вращений.

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def delete(self, key):
    """Удаление ключа из красно-чёрного дерева"""
    node = self.search(key)
    if node == self.NIL:
        return

    # y — узел, который будет удалён или перемещён
    y = node
    y_original_color = y.color

    if node.left == self.NIL:
        x = node.right
        self.transplant(node, node.right)
    elif node.right == self.NIL:
        x = node.left
        self.transplant(node, node.left)
    else:
        y = self.minimum(node.right)
        y_original_color = y.color
        x = y.right

        if y.parent == node:
            x.parent = y
        else:
            self.transplant(y, y.right)
            y.right = node.right
            y.right.parent = y

        self.transplant(node, y)
        y.left = node.left
        y.left.parent = y
        y.color = node.color

    if y_original_color == Color.BLACK:
        self.delete_fixup(x)


def transplant(self, u, v):
    """Замена поддерева u поддеревом v"""
    if u.parent == self.NIL:
        self.root = v
    elif u == u.parent.left:
        u.parent.left = v
    else:
        u.parent.right = v
    v.parent = u.parent


def minimum(self, node):
    while node.left != self.NIL:
        node = node.left
    return node


def delete_fixup(self, x):
    """Восстановление свойств после удаления"""
    while x != self.root and x.color == Color.BLACK:
        if x == x.parent.left:
            sibling = x.parent.right

            if sibling.color == Color.RED:
                # Случай 1: брат красный
                sibling.color = Color.BLACK
                x.parent.color = Color.RED
                self.left_rotate(x.parent)
                sibling = x.parent.right

            if sibling.left.color == Color.BLACK and sibling.right.color == Color.BLACK:
                # Случай 2: брат чёрный, оба ребёнка чёрные
                sibling.color = Color.RED
                x = x.parent
            else:
                if sibling.right.color == Color.BLACK:
                    # Случай 3: брат чёрный, левый ребёнок красный
                    sibling.left.color = Color.BLACK
                    sibling.color = Color.RED
                    self.right_rotate(sibling)
                    sibling = x.parent.right

                # Случай 4: брат чёрный, правый ребёнок красный
                sibling.color = x.parent.color
                x.parent.color = Color.BLACK
                sibling.right.color = Color.BLACK
                self.left_rotate(x.parent)
                x = self.root
        else:
            # Симметричные случаи для правого поддерева
            sibling = x.parent.left

            if sibling.color == Color.RED:
                sibling.color = Color.BLACK
                x.parent.color = Color.RED
                self.right_rotate(x.parent)
                sibling = x.parent.left

            if sibling.right.color == Color.BLACK and sibling.left.color == Color.BLACK:
                sibling.color = Color.RED
                x = x.parent
            else:
                if sibling.left.color == Color.BLACK:
                    sibling.right.color = Color.BLACK
                    sibling.color = Color.RED
                    self.left_rotate(sibling)
                    sibling = x.parent.left

                sibling.color = x.parent.color
                x.parent.color = Color.BLACK
                sibling.left.color = Color.BLACK
                self.right_rotate(x.parent)
                x = self.root

    x.color = Color.BLACK
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
void remove(const T& key) {
    RBNode<T>* node = search(key);
    if (node == NIL) return;

    RBNode<T>* y = node;
    RBNode<T>* x;
    Color yOriginalColor = y->color;

    if (node->left == NIL) {
        x = node->right;
        transplant(node, node->right);
    } else if (node->right == NIL) {
        x = node->left;
        transplant(node, node->left);
    } else {
        y = minimum(node->right);
        yOriginalColor = y->color;
        x = y->right;

        if (y->parent == node) {
            x->parent = y;
        } else {
            transplant(y, y->right);
            y->right = node->right;
            y->right->parent = y;
        }

        transplant(node, y);
        y->left = node->left;
        y->left->parent = y;
        y->color = node->color;
    }

    if (yOriginalColor == BLACK) {
        deleteFixup(x);
    }

    delete node;
}

void transplant(RBNode<T>* u, RBNode<T>* v) {
    if (u->parent == NIL) {
        root = v;
    } else if (u == u->parent->left) {
        u->parent->left = v;
    } else {
        u->parent->right = v;
    }
    v->parent = u->parent;
}

void deleteFixup(RBNode<T>* x) {
    while (x != root && x->color == BLACK) {
        if (x == x->parent->left) {
            RBNode<T>* sibling = x->parent->right;

            if (sibling->color == RED) {
                sibling->color = BLACK;
                x->parent->color = RED;
                leftRotate(x->parent);
                sibling = x->parent->right;
            }

            if (sibling->left->color == BLACK && sibling->right->color == BLACK) {
                sibling->color = RED;
                x = x->parent;
            } else {
                if (sibling->right->color == BLACK) {
                    sibling->left->color = BLACK;
                    sibling->color = RED;
                    rightRotate(sibling);
                    sibling = x->parent->right;
                }

                sibling->color = x->parent->color;
                x->parent->color = BLACK;
                sibling->right->color = BLACK;
                leftRotate(x->parent);
                x = root;
            }
        } else {
            // Симметричные случаи
            RBNode<T>* sibling = x->parent->left;

            if (sibling->color == RED) {
                sibling->color = BLACK;
                x->parent->color = RED;
                rightRotate(x->parent);
                sibling = x->parent->left;
            }

            if (sibling->right->color == BLACK && sibling->left->color == BLACK) {
                sibling->color = RED;
                x = x->parent;
            } else {
                if (sibling->left->color == BLACK) {
                    sibling->right->color = BLACK;
                    sibling->color = RED;
                    leftRotate(sibling);
                    sibling = x->parent->left;
                }

                sibling->color = x->parent->color;
                x->parent->color = BLACK;
                sibling->left->color = BLACK;
                rightRotate(x->parent);
                x = root;
            }
        }
    }

    x->color = BLACK;
}
```
{{% /tab %}}
{{< /tabs >}}

## Сложность операций

>[!props]
>Сложность операций в красно-чёрном дереве:

| Операция | Время |
|----------|-------|
| Поиск | $O(\log n)$ |
| Минимум/Максимум | $O(\log n)$ |
| Вставка | $O(\log n)$ |
| Удаление | $O(\log n)$ |
| Вращений при вставке | ≤ 2 |
| Вращений при удалении | ≤ 3 |

## Сравнение АВЛ и красно-чёрных деревьев

| Критерий | АВЛ-дерево | Красно-чёрное дерево |
|----------|------------|---------------------|
| Высота | $\leq 1.44 \log_2 n$ | $\leq 2 \log_2 n$ |
| Поиск | Быстрее (меньшая высота) | Медленнее |
| Вставка | Больше вращений | Меньше вращений |
| Удаление | Больше вращений | Меньше вращений |
| Дополнительная память | Высота (int) | Цвет (1 бит) |

>[!props]
>- **АВЛ-дерево** предпочтительнее, когда преобладают операции поиска.
>- **Красно-чёрное дерево** предпочтительнее, когда много вставок и удалений.

Красно-чёрные деревья используются в стандартных библиотеках C++ (`std::map`, `std::set`) и Java (`TreeMap`, `TreeSet`).
