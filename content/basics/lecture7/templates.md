---
title: "Шаблоны"
weight: 1
draft: false
---

## Шаблонные методы
Допустим нам необходимо написать функцию вычисления максимума для целочисленных значений:
```cpp
int max2(int a, int b)
{
    return a > b ? a : b;
}
```

Перегрузив, функцию можно также описать и для значений с плавающей точкой:
```cpp
double max2(double a, double b)
{
    return a > b ? a : b;
}
```

Явно видно, что код очень похож, отличие лишь в типе, с которым мы работаем. В C++ это можно обобщить добавив вместо описания конкретного типа - шаблон. Описывается это следюущим образом - каждая шаблонная функция должна начинаться с объявления, что она будет шаблонной - **template**. Внутри угловых скобок через запятую указывается, все типы-шаблоны, которые будут принимать участие с объявлением **typename**. Например, в нашем примере это будет выглядеть так:
```cpp
template<typename T>
T max2(T a, T b)
{
    return a > b ? a : b;
}
```

{{% notice info %}}
Пример хорошо работает, но в объявление это функции мы, как и в обычном сценрии, передаем объекты типа **T** по значение. Иногда бывает нужным передать объект по ссылке, особенно, если мы будем работать с классами. Тогда код незначительно изменится:
```cpp
template<typename T>
const T& max2(const T& a, const T& b)
{
    return a > b ? a : b;
}
```
{{% /notice %}}

## Шаблонные классы

**Шаблон класса** – элемент языка, позволяющий использовать типы и значения как параметры, используемые для автоматического создания классов по общему описанию.

Использование шаблонов классов – шаг на пути к парадигме **обобщенного программирования**. На практике, мы уже использовали контейнер `vector<T>`, где **T** - как раз и есть шаблон.

Определение шаблона содержат списки параметров шаблона, среди которых выделяются:
* параметры-типы
* параметры-значения
* параметры-шаблоны

Параметры-значения могут иметь необязательный **идентификатор**, необязательное **значение по умолчанию**, но должны иметь **тип**, являющийся логическим, символьным или целым, перечислением, указателем, ссылкой на объект или `nullptr`.
```cpp
 template<class T, class U, int size>
 // эквивалентно
 // template<typename T, typename U, int size>
 class Sample {
	T _prm1;
	U* _prm2;
	int _size;
 public:
	Sample(): _size(size) { }
    int getSize() {
	    return _size;
	}
 };

 // ...

Sample<int, double, 500> s;
cout << s.getSize();
```

Пример объявления шаблонного класса с параметром-шаблоном:

```cpp
template<class T> class Array { /*… */ };

template<class TKey, class TValue, template<typename...> class Container = Array>
class Map {
public:
	Container<TKey> key;
	Container<TValue> value;
	// ...
};

// ...

Map<int, double> s;
Map<int, double, vector> v;
v.key.push_back(5);
```

## Специализация шаблонов классов / функции
Шаблоны классов допускают частичную (полную) специализацию, при которой отдельные (все) параметры шаблона заменяются конкретными именами типов или значениями константных выражений.

```cpp
#include <iostream>
using namespace std;

template<typename T>
T max2(T a, T b)
{
    return a > b ? a : b;
}

template<>
bool max2(bool a, bool b)
{
    cout << "Will always return true!";
    return true;
}

int main() {
    cout << max2(5, 6) << endl;
    cout << max2(false, false) << endl;
    return 0;
}
```

Аналогично можно сделать специализация классов. Пример частичной и полной специализации:

```cpp
#include <iostream>
using namespace std;

template <typename Key, typename Value>
class KeyValuePair {
public:
    KeyValuePair() {
        cout << "General Key-Value" << endl;
    }
};

template <>
class KeyValuePair<int, std::string> {
public:
    KeyValuePair() {
        cout << "Key-Value with integer key, string value" << endl;
    }
};

template <typename Key>
class KeyValuePair<Key, std::string> {
public:
    KeyValuePair() {
        cout << "Key-Value with string value" << endl;
    }
};


int main() {
    KeyValuePair<double, double> s1;
    KeyValuePair<int, string> s2;
    KeyValuePair<int, double> s3;
    return 0;
}

/*
General Key-Value
Key-Value with integer key, string value
General Key-Value
*/
```

## Рекурсивное определение шаблонов как пример метапрограммирования
Шаблоны могут быть мощным, но не совсем тривиальным способом программирониваня. Некоторые вещи они сильно упрощают, а дргуие наоборот делают запутанным. Ниже представлен пример использования шаблонов для перевода представляения двоичного числа в десятичное.
```cpp
#include <iostream>
using namespace std;

template <unsigned long N>
struct binary {
static unsigned const value = binary<N / 10>::value << 1 | N % 10;
};

template<> struct binary<0> {
    static unsigned const value = 0;
};
 
unsigned const one = binary<1>::value;
unsigned const three = binary<11>::value;
unsigned const five = binary<101>::value;

int main() {
    cout << one << endl;
    cout << three << endl;
    cout << five << endl;
    return 0;
}
```
---