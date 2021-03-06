---
title: "Стек вызовов"
weight: 1
draft: false
---

Стек вызовов — это сегмент данных, используемый для хранения локальных переменных и временных значений. Не стоит путать стек с одноимённой структурой данных, у стека в C++ можно обратиться к произвольной ячейке. Стек выделяется при запуске программы и обычно небольшой по размеру (4Мб).
Все функции хранят свои локальные переменные на стеке. При выходе из функции соответствующая область стека объявляется свободной. Промежуточные значения, возникающие при вычислении сложных выражений, также хранятся на стеке.

Рассмотрим следующий пример работы простой программы:

![Call stack 1](/static/images/basics/lecture2/functionCallStack1.gif?featherlight=false)

## Вызов функции

При вызове функции на стек складываются:
- aргументы функции
- адрес возврата
- значение frame pointer и регистров процессора.

Кроме этого на стеке резервируется место под возвращаемое значение.

Параметры передаются в обратном порядке, что позволяет реализовать функции с переменным числом аргументов. Адресация локальных переменных функции и аргументов функции происходит относительно указателя начала фрейма (frame pointer).

![Call stack 2](/static/images/basics/lecture2/functionCallStack2.gif?featherlight=false)
