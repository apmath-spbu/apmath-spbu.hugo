---
title: "'Расслоение' системы"
weight: 2
draft: true
---

Концепция **слоев (layers)** — одна из общеупотребительных моделей, используемых разработчиками программного обеспечения для разделения сложных систем на более простые части. В архитектурах компьютерных систем, например, различают слои кода на языке программирования, функций операционной системы, драйверов устройств, наборов инструкций центрального процессора и внутренней логики чипов. В среде сетевого взаимодействия протокол FTP работает на основе протокола TCP, который, в свою очередь, функционирует «поверх» протокола IP, расположенного «над» протоколом Ethernet.

Описывая систему в терминах архитектурных слоев, удобно воспринимать составляющие ее подсистемы в виде «слоеного пирога». Слой более высокого уровня пользуется службами, предоставляемыми нижележащим слоем, но тот не «осведомлен» о наличии соседнего верхнего слоя. Более того, обычно каждый промежуточный слой «скрывает» нижний слой от верхнего: например, слой 4 пользуется услугами слоя 3, который обращается к слою 2, но слой 4 не знает о существовании слоя 2. (Не в каждой архитектуре слои настолько «непроницаемы», но в большинстве случаев дело обстоит именно так.)

Расчленение системы на слои предоставляет целый ряд преимуществ:
* Отдельный слой можно воспринимать как единое самодостаточное целое, не особенно заботясь о наличии других слоев (скажем, для создание службы FTP необходимо знать протокол TCP, но не тонкости Ethernet).
* Можно выбирать альтернативную реализацию базовых слоев (приложения FTP способны работать без каких-либо изменений в среде Ethernet, по соединению РРР или в любой другой среде передачи информации).
* Зависимость между слоями можно свести к минимуму. Так, при смене среды передачи информации (при условии сохранения функциональности слоя IP) служба FTP будет продолжать работать как ни в чем не бывало.
* Каждый слой является удачным кандидатом на стандартизацию (например, TCP и IP — стандарты, определяющие особенности функционирования соответствующих слоев системы сетевых коммуникаций).
* Созданный слой может служить основой для нескольких различных слоев более высокого уровня (протоколы TCP/IP используются приложениями FTP, telnet, SSH и HTTP). В противном случае для каждого протокола высокого уровня пришлось бы изобретать собственный протокол низкого уровня.

Схема расслоения обладает и определенными недостатками:
* Слои способны удачно инкапсулировать многое, но не все: модификация одного слоя подчас связана с необходимостью внесения каскадных изменений в остальные слои. Классический пример из области корпоративных программных приложений: поле, добавленное в таблицу базы данных, подлежит воспроизведению в графическом интерфейсе и должно найти соответствующее отображение в каждом промежуточном слое.
* Наличие избыточных слоев нередко снижает производительность системы. При переходе от слоя к слою моделируемые сущности обычно подвергаются преобразованиям из одного представления в другое. Несмотря на это, инкапсуляция нижележащих функций зачастую позволяет достичь весьма существенного преимущества. Например, оптимизация слоя транзакций обычно приводит к повышению производительности всех вышележащих слоев.
* Однако самое трудное при использовании архитектурных слоев— это определение содержимого и границ ответственности каждого слоя.