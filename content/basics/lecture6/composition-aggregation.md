---
title: "Наследование. Композиция. Агрегация"
weight: 1
draft: false
---

Поговорим еще немного о наследовании и их связи на конкретном примере геометрических фигур квадрата и прямоугольника. Когда мы готовы применить наследование мы должны применять принцип "is a" отношение. Геометрически квадрат — это специализация прямоугольника: все квадраты — прямоугольники, но не все прямоугольники — квадраты. Все объекты в классе «Квадрат» являются прямоугольниками, у которых длина равна ширине. Другими словами "Square **is a** Rectangle", но прямоугольник не всегда является квадратом. Получаем следующую иерархию:
{{< mermaid >}}
classDiagram

Shape <|-- Triangle
Shape <|-- Circle
Shape <|-- Rectangle
Rectangle <|-- Square
    
{{< /mermaid >}}

```cpp
class Shape {
    // ...
};

class Rectangle : public Shape {
    double _width;
    double _length;
public:
    Rectangle(double w, double h): _width(w), _height(h) {        
    }
    virtual void setWidth(double w) { _width = w; }
    virtual void setHeight(double h) { _height = h; }
    double getWidth() const { return _width; }
    double getHeight() const { return _height; }
};

class Square : public Rectangle {
public:
    Square(double w): Rectangle(w, w) {        
    }
    virtual void setWidth(double w);
    virtual void setHeight(double h);
};

void Square::setWidth(double w){
  Rectangle::setWidth(w);
  Rectangle::setHeight(w);
}

void Square::setHeight(double h){
  Rectangle::setHeight(h);
  Rectangle::setWidth(h);
}
```

И рассмотрим следующий пример использования:
```cpp
void LSPV(Rectangle& r){
  r.SetWidth(5);
  r.SetHeight(4);
  assert(r.GetWidth() * r.GetHeight()) == 20); // всегда ли ?
}
```

Небезосновательно можно утверждать, что обощение квадрата как частный случай прямоугольника в наследовании не работает. 

Но в иерархии типов это отношение обратное: вы можете использовать прямоугольник везде, где используется квадрат (указав прямоугольник с одинаковой шириной и высотой), но нельзя использовать квадрат везде, где используется прямоугольник (например, вы не можете изменить длину и ширину).

Таким образом приходим к выводу, что классы и прямоугольника и квадрата должны находится на одном уровне иерархии наследования:

{{< mermaid >}}
classDiagram

Shape <|-- Triangle
Shape <|-- Circle
Shape <|-- Rectangle
Shape <|-- Square
    
{{< /mermaid >}}

## Наследование / аггерация / композиция
Существуют 3 основных типа всаимосвязей между классами:
* Наследование (Inheritance)
```cpp
class Vehicle {};
class Car : public Vehicle {};
```
* Композиция (Composition)
```cpp
class Engine {
    int _power;
public:
    Engine(int power): _power(power) {}
    int getPower() { return _power; }
};
class Porshe {
    Engine* _engine;
public:
    Porshe() {
        _engine = new Engine(360);
    }
};
```
* Агергация (Aggregation)
```cpp
class Car {
    Engine* _engine;
public:
    Car(Engine* engine) {
        _engine = engine
    }
};
//...
Engine* engine = new Engine(360);
Car porshe = new Car(engine);
```

{{< mermaid >}}
classDiagram
Base <|-- Child: Inheritance   
Engine *-- Porshe: Composition   
Engine o-- Car: Aggregation   
{{< /mermaid >}}

Наследование устанавливает более сильные связи между классами, нежели агрегирование:
* Приведение между объектами
* Доступ к **protected** членам

Если наследование можно заменить легко на агрегирование, то это нужно сделать

---