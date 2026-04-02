---
title: "12.3. Двоичное дерево поиска: операции"
date: 2026-04-02T09:30:00+03:00
draft: true
weight: 123
---

Двоичное дерево поиска (Binary Search Tree, BST) — это бинарное дерево, организованное специальным образом для эффективного поиска.

## Свойство BST

>[!def]
>**Двоичное дерево поиска** — это бинарное дерево, для которого выполняется свойство BST: для любой вершины $x$ все ключи в левом поддереве $x$ меньше ключа $x$, а все ключи в правом поддереве $x$ больше ключа $x$.

```
Пример BST:
        8
       / \
      3   10
     / \    \
    1   6    14
       / \   /
      4   7 13
```

>[!props]
>1. Inorder-обход BST выдаёт ключи в возрастающем порядке.
>2. Минимальный ключ находится в самом левом узле.
>3. Максимальный ключ находится в самом правом узле.

## Реализация узла BST

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
class BSTNode:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None
        self.parent = None


class BST:
    def __init__(self):
        self.root = None
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
template<typename T>
struct BSTNode {
    T key;
    BSTNode* left;
    BSTNode* right;
    BSTNode* parent;

    BSTNode(T k) : key(k), left(nullptr), right(nullptr), parent(nullptr) {}
};

template<typename T>
class BST {
private:
    BSTNode<T>* root;

public:
    BST() : root(nullptr) {}
};
```
{{% /tab %}}
{{< /tabs >}}

## Поиск

### Рекурсивный поиск

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def search_recursive(node, key):
    """Рекурсивный поиск ключа в BST"""
    if node is None or key == node.key:
        return node

    if key < node.key:
        return search_recursive(node.left, key)
    else:
        return search_recursive(node.right, key)


# В классе BST:
def search(self, key):
    return search_recursive(self.root, key)
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
BSTNode<T>* searchRecursive(BSTNode<T>* node, const T& key) {
    if (node == nullptr || key == node->key) {
        return node;
    }

    if (key < node->key) {
        return searchRecursive(node->left, key);
    } else {
        return searchRecursive(node->right, key);
    }
}

BSTNode<T>* search(const T& key) {
    return searchRecursive(root, key);
}
```
{{% /tab %}}
{{< /tabs >}}

### Итеративный поиск

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def search_iterative(node, key):
    """Итеративный поиск ключа в BST"""
    while node is not None and key != node.key:
        if key < node.key:
            node = node.left
        else:
            node = node.right
    return node
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
BSTNode<T>* searchIterative(BSTNode<T>* node, const T& key) {
    while (node != nullptr && key != node->key) {
        if (key < node->key) {
            node = node->left;
        } else {
            node = node->right;
        }
    }
    return node;
}
```
{{% /tab %}}
{{< /tabs >}}

## Минимум и максимум

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def minimum(node):
    """Поиск минимального ключа в поддереве"""
    while node.left is not None:
        node = node.left
    return node


def maximum(node):
    """Поиск максимального ключа в поддереве"""
    while node.right is not None:
        node = node.right
    return node


# В классе BST:
def get_min(self):
    return minimum(self.root) if self.root else None

def get_max(self):
    return maximum(self.root) if self.root else None
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
BSTNode<T>* minimum(BSTNode<T>* node) {
    while (node->left != nullptr) {
        node = node->left;
    }
    return node;
}

BSTNode<T>* maximum(BSTNode<T>* node) {
    while (node->right != nullptr) {
        node = node->right;
    }
    return node;
}

BSTNode<T>* getMin() {
    return root ? minimum(root) : nullptr;
}

BSTNode<T>* getMax() {
    return root ? maximum(root) : nullptr;
}
```
{{% /tab %}}
{{< /tabs >}}

## Последователь и предшественник

>[!def]
>**Последователь** (successor) узла $x$ — узел с наименьшим ключом, большим $x.key$.
>**Предшественник** (predecessor) узла $x$ — узел с наибольшим ключом, меньшим $x.key$.

### Последователь

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def successor(node):
    """Поиск последователя узла"""
    # Если есть правое поддерево, последователь - минимум в нём
    if node.right is not None:
        return minimum(node.right)

    # Иначе поднимаемся вверх, пока не станем левым ребёнком
    parent = node.parent
    while parent is not None and node == parent.right:
        node = parent
        parent = parent.parent

    return parent
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
BSTNode<T>* successor(BSTNode<T>* node) {
    // Если есть правое поддерево, последователь - минимум в нём
    if (node->right != nullptr) {
        return minimum(node->right);
    }

    // Иначе поднимаемся вверх, пока не станем левым ребёнком
    BSTNode<T>* parent = node->parent;
    while (parent != nullptr && node == parent->right) {
        node = parent;
        parent = parent->parent;
    }

    return parent;
}
```
{{% /tab %}}
{{< /tabs >}}

### Предшественник

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def predecessor(node):
    """Поиск предшественника узла"""
    # Если есть левое поддерево, предшественник - максимум в нём
    if node.left is not None:
        return maximum(node.left)

    # Иначе поднимаемся вверх, пока не станем правым ребёнком
    parent = node.parent
    while parent is not None and node == parent.left:
        node = parent
        parent = parent.parent

    return parent
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
BSTNode<T>* predecessor(BSTNode<T>* node) {
    // Если есть левое поддерево, предшественник - максимум в нём
    if (node->left != nullptr) {
        return maximum(node->left);
    }

    // Иначе поднимаемся вверх, пока не станем правым ребёнком
    BSTNode<T>* parent = node->parent;
    while (parent != nullptr && node == parent->left) {
        node = parent;
        parent = parent->parent;
    }

    return parent;
}
```
{{% /tab %}}
{{< /tabs >}}

## Вставка

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def insert(self, key):
    """Вставка ключа в BST"""
    new_node = BSTNode(key)

    parent = None
    current = self.root

    # Ищем место для вставки
    while current is not None:
        parent = current
        if key < current.key:
            current = current.left
        else:
            current = current.right

    new_node.parent = parent

    if parent is None:
        # Дерево было пустым
        self.root = new_node
    elif key < parent.key:
        parent.left = new_node
    else:
        parent.right = new_node


# Рекурсивная версия:
def insert_recursive(self, key):
    self.root = self._insert_node(self.root, key)

def _insert_node(self, node, key):
    if node is None:
        return BSTNode(key)

    if key < node.key:
        node.left = self._insert_node(node.left, key)
        node.left.parent = node
    else:
        node.right = self._insert_node(node.right, key)
        node.right.parent = node

    return node
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
void insert(const T& key) {
    BSTNode<T>* newNode = new BSTNode<T>(key);

    BSTNode<T>* parent = nullptr;
    BSTNode<T>* current = root;

    // Ищем место для вставки
    while (current != nullptr) {
        parent = current;
        if (key < current->key) {
            current = current->left;
        } else {
            current = current->right;
        }
    }

    newNode->parent = parent;

    if (parent == nullptr) {
        // Дерево было пустым
        root = newNode;
    } else if (key < parent->key) {
        parent->left = newNode;
    } else {
        parent->right = newNode;
    }
}
```
{{% /tab %}}
{{< /tabs >}}

## Удаление

Удаление — самая сложная операция. Есть три случая:

1. **Узел — лист**: просто удаляем его
2. **Узел имеет одного ребёнка**: заменяем узел его ребёнком
3. **Узел имеет двух детей**: находим последователя, перемещаем его на место удаляемого узла

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
def delete(self, key):
    """Удаление ключа из BST"""
    node = self.search_iterative(self.root, key)
    if node is None:
        return

    self._delete_node(node)


def _delete_node(self, node):
    if node.left is None:
        self._transplant(node, node.right)
    elif node.right is None:
        self._transplant(node, node.left)
    else:
        # Узел имеет двух детей
        succ = self.minimum(node.right)
        if succ.parent != node:
            # Последователь не является прямым ребёнком
            self._transplant(succ, succ.right)
            succ.right = node.right
            succ.right.parent = succ

        self._transplant(node, succ)
        succ.left = node.left
        succ.left.parent = succ


def _transplant(self, u, v):
    """Замена поддерева u поддеревом v"""
    if u.parent is None:
        self.root = v
    elif u == u.parent.left:
        u.parent.left = v
    else:
        u.parent.right = v

    if v is not None:
        v.parent = u.parent
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
void deleteNode(const T& key) {
    BSTNode<T>* node = searchIterative(root, key);
    if (node == nullptr) return;

    deleteNodeHelper(node);
}

void deleteNodeHelper(BSTNode<T>* node) {
    if (node->left == nullptr) {
        transplant(node, node->right);
        delete node;
    } else if (node->right == nullptr) {
        transplant(node, node->left);
        delete node;
    } else {
        // Узел имеет двух детей
        BSTNode<T>* succ = minimum(node->right);
        if (succ->parent != node) {
            // Последователь не является прямым ребёнком
            transplant(succ, succ->right);
            succ->right = node->right;
            succ->right->parent = succ;
        }

        transplant(node, succ);
        succ->left = node->left;
        succ->left->parent = succ;
        delete node;
    }
}

void transplant(BSTNode<T>* u, BSTNode<T>* v) {
    // Замена поддерева u поддеревом v
    if (u->parent == nullptr) {
        root = v;
    } else if (u == u->parent->left) {
        u->parent->left = v;
    } else {
        u->parent->right = v;
    }

    if (v != nullptr) {
        v->parent = u->parent;
    }
}
```
{{% /tab %}}
{{< /tabs >}}

### Визуализация удаления

**Случай 1: Лист** — удаляем узел 12
```
    10              10
   /  \    →       /  \
  5    15         5    15
      /
     12
```

**Случай 2: Один ребёнок** — удаляем узел 15, его ребёнок 12 занимает место
```
    10              10
   /  \    →       /  \
  5    15         5    12
      /
     12
```

**Случай 3: Два ребёнка** — удаляем узел 10, заменяем на последователя (12)
```
    10              12
   /  \    →       /  \
  5    15         5    15
      /  \              \
     12   20             20
```

## Полная реализация

{{< tabs >}}
{{% tab color="blue" title="python" %}}
```python
class BSTNode:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None
        self.parent = None


class BST:
    def __init__(self):
        self.root = None

    def search(self, key):
        node = self.root
        while node is not None and key != node.key:
            if key < node.key:
                node = node.left
            else:
                node = node.right
        return node

    def minimum(self, node=None):
        if node is None:
            node = self.root
        if node is None:
            return None
        while node.left is not None:
            node = node.left
        return node

    def maximum(self, node=None):
        if node is None:
            node = self.root
        if node is None:
            return None
        while node.right is not None:
            node = node.right
        return node

    def insert(self, key):
        new_node = BSTNode(key)
        parent = None
        current = self.root

        while current is not None:
            parent = current
            if key < current.key:
                current = current.left
            else:
                current = current.right

        new_node.parent = parent

        if parent is None:
            self.root = new_node
        elif key < parent.key:
            parent.left = new_node
        else:
            parent.right = new_node

    def delete(self, key):
        node = self.search(key)
        if node is None:
            return

        if node.left is None:
            self._transplant(node, node.right)
        elif node.right is None:
            self._transplant(node, node.left)
        else:
            succ = self.minimum(node.right)
            if succ.parent != node:
                self._transplant(succ, succ.right)
                succ.right = node.right
                succ.right.parent = succ
            self._transplant(node, succ)
            succ.left = node.left
            succ.left.parent = succ

    def _transplant(self, u, v):
        if u.parent is None:
            self.root = v
        elif u == u.parent.left:
            u.parent.left = v
        else:
            u.parent.right = v
        if v is not None:
            v.parent = u.parent

    def inorder(self):
        result = []

        def inorder_helper(node):
            if node is not None:
                inorder_helper(node.left)
                result.append(node.key)
                inorder_helper(node.right)

        inorder_helper(self.root)
        return result


# Пример использования:
bst = BST()
for key in [8, 3, 10, 1, 6, 14, 4, 7, 13]:
    bst.insert(key)

print("Inorder:", bst.inorder())  # [1, 3, 4, 6, 7, 8, 10, 13, 14]
print("Min:", bst.minimum().key)  # 1
print("Max:", bst.maximum().key)  # 14

bst.delete(3)
print("After deleting 3:", bst.inorder())  # [1, 4, 6, 7, 8, 10, 13, 14]
```
{{% /tab %}}
{{% tab color="blue" title="c++" %}}
```cpp
#include <iostream>
#include <vector>

template<typename T>
struct BSTNode {
    T key;
    BSTNode* left;
    BSTNode* right;
    BSTNode* parent;

    BSTNode(T k) : key(k), left(nullptr), right(nullptr), parent(nullptr) {}
};

template<typename T>
class BST {
private:
    BSTNode<T>* root;

    void transplant(BSTNode<T>* u, BSTNode<T>* v) {
        if (u->parent == nullptr) {
            root = v;
        } else if (u == u->parent->left) {
            u->parent->left = v;
        } else {
            u->parent->right = v;
        }
        if (v != nullptr) {
            v->parent = u->parent;
        }
    }

    void inorderHelper(BSTNode<T>* node, std::vector<T>& result) {
        if (node != nullptr) {
            inorderHelper(node->left, result);
            result.push_back(node->key);
            inorderHelper(node->right, result);
        }
    }

public:
    BST() : root(nullptr) {}

    BSTNode<T>* search(const T& key) {
        BSTNode<T>* node = root;
        while (node != nullptr && key != node->key) {
            if (key < node->key) {
                node = node->left;
            } else {
                node = node->right;
            }
        }
        return node;
    }

    BSTNode<T>* minimum(BSTNode<T>* node = nullptr) {
        if (node == nullptr) node = root;
        if (node == nullptr) return nullptr;
        while (node->left != nullptr) {
            node = node->left;
        }
        return node;
    }

    BSTNode<T>* maximum(BSTNode<T>* node = nullptr) {
        if (node == nullptr) node = root;
        if (node == nullptr) return nullptr;
        while (node->right != nullptr) {
            node = node->right;
        }
        return node;
    }

    void insert(const T& key) {
        BSTNode<T>* newNode = new BSTNode<T>(key);
        BSTNode<T>* parent = nullptr;
        BSTNode<T>* current = root;

        while (current != nullptr) {
            parent = current;
            if (key < current->key) {
                current = current->left;
            } else {
                current = current->right;
            }
        }

        newNode->parent = parent;

        if (parent == nullptr) {
            root = newNode;
        } else if (key < parent->key) {
            parent->left = newNode;
        } else {
            parent->right = newNode;
        }
    }

    void deleteNode(const T& key) {
        BSTNode<T>* node = search(key);
        if (node == nullptr) return;

        if (node->left == nullptr) {
            transplant(node, node->right);
            delete node;
        } else if (node->right == nullptr) {
            transplant(node, node->left);
            delete node;
        } else {
            BSTNode<T>* succ = minimum(node->right);
            if (succ->parent != node) {
                transplant(succ, succ->right);
                succ->right = node->right;
                succ->right->parent = succ;
            }
            transplant(node, succ);
            succ->left = node->left;
            succ->left->parent = succ;
            delete node;
        }
    }

    std::vector<T> inorder() {
        std::vector<T> result;
        inorderHelper(root, result);
        return result;
    }
};

int main() {
    BST<int> bst;
    for (int key : {8, 3, 10, 1, 6, 14, 4, 7, 13}) {
        bst.insert(key);
    }

    auto inorder = bst.inorder();
    std::cout << "Inorder: ";
    for (int val : inorder) std::cout << val << " ";  // 1 3 4 6 7 8 10 13 14
    std::cout << std::endl;

    std::cout << "Min: " << bst.minimum()->key << std::endl;  // 1
    std::cout << "Max: " << bst.maximum()->key << std::endl;  // 14

    bst.deleteNode(3);
    inorder = bst.inorder();
    std::cout << "After deleting 3: ";
    for (int val : inorder) std::cout << val << " ";  // 1 4 6 7 8 10 13 14
    std::cout << std::endl;

    return 0;
}
```
{{% /tab %}}
{{< /tabs >}}
