---
title: "Const"
weight: 4
draft: false
---

В С/С++ есть простой модификатор, который делает переменную постоянной (константной).
```cpp
const int value = 5;
value = 8; // не получится. ощибка
```
Порой бывают случаи, что нам нужно гарантировать, что указатель или ссылку, что мы передаем в функцию не смогу подменить на другую переменную (по ошибке или намеренно), или для гарантии того, что функция случайно не изменит значение переданного аргумента или все вместе. Для этого используются константыне модификации указателей и ссылок. Рассмотрим их объявления.

## Указатели на константные переменные
До этого момента все указатели, которые мы рассматривали, были неконстантными указателями на неконстантные значения:

```cpp
int value = 7;
int* ptr = &value;
*ptr = 8; // изменяем значение value на 8
```
Однако, что произойдет, если указатель будет указывать на константную переменную?

```cpp
const int value = 7; // value - это константа
int *ptr = &value; // ошибка компиляции: невозможно конвертировать const int* в int*
*ptr = 8; // изменяем значение value на 8
```

Фрагмент кода, приведенный выше, не скомпилируется: мы не можем присвоить неконстантному указателю константную переменную. Здесь есть смысл, ведь на то она и константа, что её значение нельзя изменить. Гипотетически, если бы мы могли присвоить константное значение неконстантному указателю, то тогда мы могли бы разыменовать неконстантный указатель и изменить значение этой же константы. А это уже является нарушением самого понятия «константа».

## Указатели на константные значения

Указатель на константное значение — это неконстантный указатель, который указывает на неизменное значение. Для объявления указателя на константное значение, используется ключевое слово `const` перед типом данных:

```cpp
const int value = 7;
const int* ptr = &value; // здесь всё ок: ptr - это неконстантный указатель, который указывает на "const int"
*ptr = 8; // нельзя, мы не можем изменить константное значение
```

В примере, приведенном выше, `ptr` указывает на константный целочисленный тип данных.

Рассмотрим следующий пример:

```cpp
int value = 7; // value - это не константа
const int *ptr = &value; // всё хорошо
```

Указатель на константную переменную может указывать и на неконстантную переменную. Подумайте об этом так: указатель на константную переменную обрабатывает переменную как константу при получении доступа к ней независимо от того, была ли эта переменная изначально определена как const или нет. Таким образом, следующее в порядке вещей:

```cpp
int value = 7;
const int* ptr = &value; // ptr указывает на "const int"
value = 8; // переменная value уже не константа, если к ней получают доступ через неконстантный идентификатор
```
Но не следующее:

```cpp
int value = 7;
const int *ptr = &value; // ptr указывает на "const int"
*ptr = 8; // ptr обрабатывает value как константу, поэтому изменение значения переменной value через ptr не допускается
```

Указателю на константное значение, который сам при этом не является константным (он просто указывает на константное значение), можно присвоить и другое значение:

```
int value1 = 7;
const int *ptr = &value1; // ptr указывает на const int
 
int value2 = 8;
ptr = &value2; // хорошо, ptr теперь указывает на другой const int
```

## Константные указатели
Мы также можем сделать указатель константным. Константный указатель — это указатель, значение которого не может быть изменено после инициализации. Для объявления константного указателя используется ключевое слово const между звёздочкой и именем указателя:

```
int value = 7;
int *const ptr = &value;
```

Подобно обычным константным переменным, константный указатель должен быть инициализирован значением при объявлении. Это означает, что он всегда будет указывать на один и тот же адрес. В вышеприведенном примере ptr всегда будет указывать на адрес value (до тех пор, пока указатель не выйдет из области видимости и не уничтожится):

```
int value1 = 7;
int value2 = 8;
 
int * const ptr = &value1; // ок: константный указатель инициализирован адресом value1
ptr = &value2; // не ок: после инициализации константный указатель не может быть изменен
```

Однако, поскольку переменная **value**, на которую указывает указатель, не является константой, то её значение можно изменить путем разыменования константного указателя:

```cpp
int value = 7;
int* const ptr = &value; // ptr всегда будет указывать на value
*ptr = 8; // ок, так как ptr указывает на тип данных (неконстантный int)
```

## Константные указатели на константные значения

Наконец, можно объявить константный указатель на константное значение, используя ключевое слово const как перед типом данных, так и перед именем указателя:

```
int value = 7;
const int *const ptr = &value;
```

Константный указатель на константное значение нельзя перенаправить указывать на другое значение также, как и значение, на которое он указывает, — нельзя изменить.

## Ссылка на константу
Объявить ссылку на константное значение можно путем добавления ключевого слова const перед типом данных:

```
const int value = 7;
const int &ref = value; // ref - это ссылка на константную переменную value
```

{{% notice note %}}
Константной ссылки не бывает, так как ссылка сама по определению константна. Чаще всегда, если говорят "константая ссылка" имеют ввиду ссылку на константу. Для указателей же это разыне вещи.
{{% /notice %}}

## Константные ссылки в качестве параметров функции

Рассмотрим пример константной ссылки в качестве параметра функции. Это позволяет получить доступ к аргументу без его копирования, гарантируя, что функция не изменит значение, на которое ссылается ссылка:

```cpp
void changeN(const int& ref)
{
	ref = 8; // нельзя: ref - это константа
}
```

---