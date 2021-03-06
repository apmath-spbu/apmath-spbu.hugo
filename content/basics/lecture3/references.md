---
title: "Ссылки"
weight: 1
draft: false
---

Прежде чем описывать ссылки, давайте вспомним прошлую лекцию и распишем недостатки [указателей]({{< ref "/basics/lecture2/pointers" >}}) (возможно список не полон)

## Недостатки указателей
* Использование указателей синтаксически загрязняет код и усложняет его понимание. (Приходится использовать операторы `*` и `&`)
* Указатели могут быть неинициализированными (что придит к некорректному исполнению кода).
* Указатель может быть нулевым, и его нужно прверять на равенству нулю при использовании.
* Арифметика указателей может сделать из корректного указателя некорректный, так как достаточно легко "промахнуться".

Все это привело к тому, что в языке С++ появилось более дружелюбный тип данных, лишенных данных недостатков. Имя ему - ссылка. *Ссылка* — это тип переменной в языке C++, который работает как псевдоним другого объекта или значения. Ссылка (на неконстантное значение) объявляется с использованием амперсанда (`&`) между типом данных и именем ссылки:
```cpp
int value = 7; // обычная переменная
int& ref = value; // ссылка на переменную value
```
Для сравнения удобства приведем пример из прошлой лекии по обмену значений переменных, но уже с использованием ссылок:
```cpp
void swap(int& a, int& b)
{
	int t = b;
	b = a;
	a = t;
}
int main()
{
	int k = 10, m = 20;
	swap(k, m);
	cout << k << ' ' << m << endl; // 20 10
	return 0;
}
```

Как видно из примера - нет больше необходмости просизводить операции взятия адреса и значения, если мы хотим работать с оригинальной переменной (то есть с переменными из функции `main` при передачи в функцию `swap`). Вместо этого достаточно указать в объявлении функции `swap` что объекты будут переданы не по значению, а по _ссылке_, указав тип как ссылочный (то есть добавив `&`).

При этом ссылки, фактически работают и как "псевдонимы" переменных - измения их значения мы изменяем значения оригинальных переменных.
```cpp
#include <iostream>
using namespace std;
 
int main()
{
	int value = 7;
	int& ref = value; // ссылка на переменную value
 
	value = 8; // value теперь 8
	ref = 9; // value теперь 9
 
	cout << value << endl; // 9
	++ref;
	cout << value << endl; // 10
 
	return 0;
}
```

При этом при использоавнии оператора взятия адреса (`&`) у ссылке и у ссылоемой переменной вернется одинаковый адрес.
```cpp
cout << &value; // 0x11FF22DD
cout << &ref; // 0x11FF22DD
```

## Различия ссылок и указателей
* Ссылка не может быть неинициализированной
```cpp
int *p; // OK
int &l; // ошибка
```
* У ссылки нет нулевого значения
```cpp
int *p = nullptr; // OK
int &l = 0; // ошибка
```
* Ссылку нельзя переинициализировать
```cpp
int a = 10, b = 20;
int *p = &a; // p указывает на a
p = &b; // p указывает на b
int &l = a; // l ссылается на a
l = b; // a присваивается значение b
```
* Нельзя получить адрес ссылки или ссылку на ссылку
```cpp
int a = 10;
int *p = &a; // p указывает на a
int **pp = &p; // pp указывает на переменную p
int &l = a; // l ссылается на a
int *pl = &l; // pl указывает на переменную a
int &&ll = l; // ошибка
```
* Нельзя создать массивы ссылок
```cppp
int *mp[10] = {}; // массив указателей на int
int &ml[10] = {}; // ошибка
```
* Для ссылок нет арифметики

## l-value и r-value
В языке C++ все переменные являются l-values. l-value - выражения, значения которых являются ссылкой на переменную/элемент массива, а значит могут быть указаны слева от оператора `=`

Противоположностью l-value является r-value. r-value — это значение, которое не имеет постоянного адреса в памяти. Примерами могут быть единичные числа (например, 7, которое имеет значение 7) или выражения (например, 3 + х, которое имеет значение х плюс 3).

Указатели и ссылки могут указывать только на l-value
```cpp
int a = 10, b = 20;
int m[10] = {1, 2, 3, 4, 5, 5, 4, 3, 2, 1};
int &l1 = a; // OK
int &l2 = a + b; // ошибка
int &l3 = *(m + a / 2); // OK
int &l4 = *(m + a / 2) + 1; // ошибка
int &l5 = (a + b > 10) ? a : b; // OK
```

## Время жизни переменной
Как мы уже разбирали ранее все переменные передаются и возвращаются по значению. Соответственно, если мы хотим передавать значение по указателю эти переменные не должны уходить за рамки видимости. В противоположность к этому мы теперь можем передвать и возвращать результаты по ссылке. Проилюстрируем в качестве пример следющий код:
```cpp
int* foo()
{
	int a = 10;
	return &a;
}
int& bar()
{
	int b = 20;
	return b;
}

// ..

int* p = foo(); // объект a был разрушен при выходе из foo(), соотв. *p ссылается на недействительный адрес
int& l = bar(); // объект b был возвращен по ссылке
```

---