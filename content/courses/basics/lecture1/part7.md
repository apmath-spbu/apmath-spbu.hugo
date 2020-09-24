---
title: "1.7. Функции"
tags: ["с", "cpp"]
weight: 1
draft: false

---

Функция — это последовательность команд для выполнения определенного задания. Собственно ваши программы и будут из них состоять (как минимум из функции main). Сигнатра функции состоит из возвращаемого типа, имени функции и переменных данной функции (если они есть) в круглых скобках. Ключевое слово **return** возвращает значение из функции или выходит из нее (если тип возвращаемого значение **void**  - то есть функция является процедурой).

```
#include <iostream>
using namespace std;

double square (double x)
{
    return x * x;
}

void printFinish()
{
    cout << "Finish";
}
 
int main()
{
    cout << square(9) << endl; // выведется 81
    printFinish();
    return 0;
}
```

Переменные объявляенные внутри функции - являются локальными для этих функций. Параметры передаются по значению (копируются). Как сделать так, вызываемые параметры можно было бы изменить рассмотрим позже.

```
#include <iostream>
using namespace std;

double fortyTwo(int i)
{
    i = 42; // не поменяет глобальную значение в оригинальной переменной
    return i; // будет неявное преобразование возвращаемого значения в double
}
 
int main()
{
    int i = 5; 
    cout << fortyTwo(i) << endl; // выведет 42
    cout << i; // выведет 5
    return 0;
}
```