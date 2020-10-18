---
title: "Констурктор"
weight: 5
draft: false
---


**Конструктор** – метод класса, автоматически применяемый к каждому экземпляру (объекту) класса перед первым использованием (в случае динамического выделения памяти – после успешного выполнения операции **new**).
{{% notice note %}}
Освобождение ресурсов, захваченных в конструкторе класса либо на протяжении времени жизни соответствующего экземпляра, осуществляет **деструктор**.
{{% /notice %}}

Выполнение любого конструктора состоит из двух фаз:
1. Фаза явной (неявной) инициализации (обработка списка инициализации)
2. Фаза вычислений (исполнение тела конструктора)

{{% notice note %}}
Конструктор не может определяться со спецификатором **const**. Константность и объекта устанавливается по завершении работы конструктора и снимается перед вызовом деструктора.
{{% /notice %}}

{{% notice note %}}
При объявлении структуры, если не писать явно, то всегда есть конструктор по умолчанию. Его можно переопределить задав в нем некоторые значения объектов данного класса.
{{% /notice %}}

В приведенном ниже примере объявляется структура дроби с двумя закрытыми переменными. По умолчанию структура в конструкторе инициализируется. Значения числителя и знаменателя можно получить/изменить с помощью функций **геттера/сеттера**:
```cpp
struct Fraction {
    Fraction() { //конструктор по умолчанию
        // инициализация
        _numerator = 0;
        _denominator = 1;
    }

    int getNumerator() { return _numerator; }
    void setNumerator(int value) { _numerator = value; }

    int getDenominator() { return _denominator; }
    void setDenominator(int value) { _denominator = value; }

    double getValue() {
        if (_denominator != 0) {
            return (double)_numerator / _denominator;
        } else {
            return .0;
        }
    }
private:
    int _numerator;
    int _denominator;
};

int main() {
    Sample s; // статическое создание
    Sample *sp = new Sample(); // динамичесое создание
    return 0;
}
```

В конструктор как и в любую другую функцию можно передавать начальные значения:

```cpp
struct Fraction {
    Fraction() { //конструктор по умолчанию
        // инициализация
        _numerator = 0;
        _denominator = 1;
    }

    Fraction(int numerator, int denominator) { //конструктор с параметрами
        // инициализация
        _numerator = numerator;
        _denominator = denominator;
    }

    int getNumerator() { return _numerator; }
    void setNumerator(int value) { _numerator = value; }

    int getDenominator() { return _denominator; }
    void setDenominator(int value) { _denominator = value; }

    double getValue() {
        if (_denominator != 0) {
            return (double)numerator / _denominator;
        } else {
            return .0;
        }
    }
private:
    int numerator;
    int _denominator;
};

int main() {
    Sample s(10, 20); // статическое создание
    Sample *sp = new Sample(30, 40); // динамичесое создание
    return 0;
}
```

Но также, некоторые значения могут задваться по умолчанию, тогда пример выше можно свести к одному конструктору:

```cpp
struct Fraction {
    Fraction(int numerator = 0, int denominator = 1) { //конструктор с параметрами
        // инициализация
        _numerator = _numerator;
        _denominator = denominator;
    }

    int getNumerator() { return _numerator; }
    void setNumerator(int value) { _numerator = value; }

    int getDenominator() { return _denominator; }
    void setDenominator(int value) { _denominator = value; }

    double getValue() {
        if (_denominator != 0) {
            return (double)numerator / _denominator;
        } else {
            return .0;
        }
    }
private:
    int _numerator;
    int _denominator;
};

int main() {
    Sample s(denominator = 20); // статическое создание c (0, 20)
    Sample *sp = new Sample(); // динамичесое создание с (0, 1)
    return 0;
}
```

## Синтаксический сахар
Для конструктора возможны следующие синтаксические конструкции:
```cpp
struct Sample {
    // прямая инциализация переменной.
    Sample(int value) : _value(value) { } 
private:
    int _value;
};

struct Sample2 {
    // прямая инциализация переменной.
    Sample(int value1 = 10, int value2 = 20) : _value1(value1), _value2(value)  { } 
private:
    int _value1;
    int _value2;
};

int main() {
    // следующие объявления эквивалентны:
    Sample s1(10);
    Sample s2 = Sample(10);
    Sample s3 = 10;

    // массивы объектов класса определяются аналогично массивам
    // объектов базовых типов

    // для конструктора с одним аргументом
    Sample array1[] = { 10, -5, 0, 127 };

    // для конструктора сокращенной формы нет
    Sample2 array2[5] = {
        Sample2(10, 0.1),
        Sample2(-5, -3.6),
        Sample2(0, 0.0),
        Sample2()
    };
}

```

## Еще конструкторы
Надо отметить, что при простом объявлении структуры/класса:
```cpp
struct A { } ;
```
неявным образом создаются следующие функции:
1. ```A()``` - конструктор по умолчанию
2. ```A(const A& a)``` - конструктор копирования
3. ```operator=(const A& a)``` - копирующий оператор
4. ```A(const&& a)``` - конструктор перемещения
5. ```operator=(const A&& a)``` - оператор перемещения
6. ```~A()``` - деструктор

О функциях 2-5 речь пойдет позже, а вот о деструктор можно рассмотреть сейчас.

## Деструкторы
Деструктор – не принимающий параметров и не возвращающий результат функция класса, автоматически вызываемая при выходе объекта из области видимости и применении к указателю на объект класса операции **delete**. Деструктор всегда имеет имя класса/структуры с `~` перед ним.

```cpp
struct Sample {
    // ...    
    ~Sample();
};
```

{{% notice note %}}
Деструктор **не вызывается** при выходе из области видимости **ссылки** или **указателя** на объект.
{{% /notice %}}

Задачи деструктора:
1. Освобождение (возврат) системных ресурсов, главным образом – оперативной памяти
2. Закрытие файлов или устройств
3. Снятие блокировок, таймеров и т.д

```cpp
struct Another
{ 
    Another(int nID)
    {
        cout << "Constructing Another " << nID << '\n';
        _nID = nID;
    }
 
    ~Another()
    {
        cout << "Destructing Another " << _nID << '\n';
    }
 
    int getID() { return _nID; }
private:
    int _nID;
};
 
int main()
{
    // Выделяем объект класса Another из стека
    Another object(1);
    cout << object.getID() << '\n';
 
    // Выделяем объект класса Another динамически из кучи
    Another *pObject = new Another(2);
    cout << pObject->getID() << '\n';
    delete pObject; // произойдет неявный вызов дестркутора pObject
 
    return 0;
} // объект object выходит из области видимости и вызовется деструктор

```

{{% notice note %}}
Общее правило - не вызываем деструктор явно.
{{% /notice %}}

## Переиспользование памяти
Однако, есть случаи, когда вызывать деструтор явно бывает полезно. Потребность в явном вызове деструктора обычно связана с необходимостью **уничтожить** динамически размещенный объект **без освобождения памяти**. То есть мы даем возможно данный сегмент памяти переиспользовать. Достигается это также с помощью расширения оператора **new** указывая где нужно разметить данный объект:
```cpp
char* buf = new char[sizeof(Sample)];
// "размещающий" вариант new
Sample* sample1 = new (buf) Sample(100);
// ...
sample1->~Sample(); // вызов 1
Sample* sample2 = new (buf) Sample(200);
// ...
sample2->~Sample(); // вызов 2
delete[] buf;
```
---