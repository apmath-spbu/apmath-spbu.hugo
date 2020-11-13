---
title: "Инкапсуляция"
weight: 2
draft: false
---

При первом знакомстве со [стуртурами]({{< ref "/basics/lecture4/struct" >}} ) мы получили возможность объединять данные, оставляя их доступными к изменению извне. Также функция **length** было объявленная как функция в объекту **Segment**. Что если поместить реализацию этой функции в  структуру, тем самым сделав ее неотъемлемой частью структуры и "скрыв" из глобального списка функций (другими словами зачем нам эта отдельная глобальная функция, если она применима только **Segment**)? Реализовать это можно следующим образом (поместив реализация функции в тело **struct**)

```cpp
struct Segment {
    Point p1;
    Point p2;
    double length() {
        double dx = p1.x – p2.x;
        double dy = p1.y – p2.y;
        return sqrt(dx * dx + dy * dy);
    }   
};
```

В примере мы поместили реализацию функции. Можно описать короткое объявление структуры, поместив реализацию функции **length** вне её:
```cpp
struct Segment {
    Point p1;
    Point p2;
    double length();
};

double Segment::length() {
    double dx = p1.x – p2.x;
    double dy = p1.y – p2.y;
    return sqrt(dx * dx + dy * dy);
}
```

Из примера видно, что чтобы поместить реализцаию функции структуры нужно соблюсти соответствующий формат, а именно: **возвращаемый_тип имя_структуры::имя_функции(параметры)**
{{% notice note %}}
Оба примера равнозначны и употребимы. Какой из них выбрать зависит от желания разработчика или от правил форматирования кода. Например, если реализация функции состоит из 1-2 строк, то ее можно реализоавать в месте объявленяи. Если реализация много-строчна, то вынести, а в структуре оставить только объявление.
{{% /notice %}}

## Инкапсуляция
В данном примере мы рассмотрели первый пример **инкапсуляции** (или скорытия реализцаии). В общем **инкапсуляция** является фундаментом объектного подхода к разработке ПО, в процессе которого данные объекта и детали реализации скрываются в самом объекте.

Следуя данному подходу, программист рассматривает задачу в терминах предметной области, а создаваемый им продукт видит как совокупность абстрактных сущностей – классов (в свою очередь формально являющихся пользовательскими типами). Инкапсуляция предотвращает прямой доступ к  внутреннему представлению класса из других классов и функций программы.

Без нее теряют смысл остальные основополагающие принципы объектно-ориентированного программирования (ООП): наследование и полиморфизм (будут рассмотрены позже).
{{% notice note %}}
Сущность инкапсуляции можно отразить формулой: открытый интерфейс + скрытая реализация
{{% /notice %}}

---