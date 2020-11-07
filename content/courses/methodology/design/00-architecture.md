---
title: "Архитектура"
weight: 1
draft: false
---

Можно назвать два общих варианта трактования термина «архитектура». Первый связан с разделением системы на наиболее крупные составные части; во втором случае имеются в виду некие конструктивные решения, которые после их принятия с трудом поддаются изменению. Также растет понимание того, что существует более одного способа описания архитектуры и степень важности каждого из них меняется в продолжение жизненного цикла системы.

Архитектура — весьма субъективное понятие. В лучшем случае оно отображает общую точку зрения команды разработчиков на результаты проектирования системы. Обычно это согласие в вопросе идентификации главных компонентов системы и способов их взаимодействия, а также выбор таких решений, которые интерпретируются как основополагающие и не подлежащие изменению в будущем. Если позже оказывается, что нечто изменить легче, чем казалось вначале, это «нечто» легко исключается из «архитектурной» категории.

## Корпоративные приложения
Одним из типов приложений, которым занимается множество людей является корпоративные приложение. Корпоративные приложения чаще всего имеют дело с изощренными данными большого объема и бизнес-правилами, логика которых иногда просто противоречит здравому смыслу. Хотя некоторые приемы и решения более-менее универсальны, большинство из них адекватны только в контексте определенных ситуаций.

Что именно подразумевает понятие корпоративное приложение? Точное определение сформулировать трудно, но дать смысловое толкование вполне возможно.

К примеру, к числу корпоративных приложений относятся, скажем, бухгалтерский учет, ведение медицинских карт пациентов, экономическое прогнозирование, анализ кредитной истории клиентов банка, страхование, внешнеэкономические торговые операции и т.п. Так же можно отнести к ним многие юридические автоматизированные информационные системы. Корпоративными приложениями не являются средства обработки текста, регулирования расхода топлива в автомобильном двигателе, управления лифтами и оборудованием телефонных станций, автоматического контроля химических процессов, а также операционные системы, компиляторы, игры и т.д.

Корпоративные приложения обычно подразумевают необходимость **долговременного** (иногда в течение десятилетий) **хранения данных**. Данные зачастую способны «пережить» несколько поколений прикладных программ, предназначенных для их обработки, аппаратных средств, операционных систем и компиляторов. В продолжение этого срока структура данных может подвергаться многочисленным изменениям в целях сохранения новых порций информации без какого-либо воздействия на старые. Даже в тех случаях, когда компания осуществляет революционные изменения в парке оборудования и номенклатуре программных приложений, данные не уничтожаются, а переносятся в новую среду.

**Данных**, с которыми имеет дело корпоративное приложение, как правило, **бывает много--: даже скромная система способна манипулировать несколькими гигабайтами информации, организованной в виде десятков миллионов записей; и задача манипуляции этими данными вырастает в одну из основных функций приложения. В старых системах информация хранилась в виде индексированных файловых структур. Сейчас для этого применяются системы управления базами данных (СУБД), большей частью реляционные. Проектирование таких систем и их сопровождение превратились в отдельные специализированные дисциплины.

Множество пользователей обращаются к данным параллельно. Как правило, их количество не превышает сотни, но для систем, размещенных в среде Web, этот показатель возрастает на несколько порядков. Как гарантировать возможность одновременного доступа к базе данных для всех, кто имеет на это право? Проблема остается даже в том случае, если речь идет всего о двух пользователях: они должны манипулировать одним элементом данных только такими способами, которые исключают вероятность возникновения ошибок. Большинство обязанностей по управлению параллельными заданиями принимает на себя диспетчер транзакций из состава СУБД, но полностью избавить прикладные системы от подобных забот программистам чаще всего не удается.

Если объемы данных столь велики, в приложении должно быть предусмотрено и множество различных вариантов окон экранного интерфейса. Вполне обычна ситуация, когда программа содержит несколько сотен окон. Одни пользователи работают с корпоративным приложением регулярно, другие обращаются к нему эпизодически, но полагаться на их техническую осведомленность в любом случае нельзя. Поэтому данные должны допускать возможность представления в самых разных формах, удобных для пользователей всех категорий. Фокусируя внимание на вопросах взаимодействия пользователей с приложением, нельзя упускать из виду и тот факт, что многие системы характеризуются высокой степенью пакетной обработки данных.

Корпоративные приложения **редко существуют в изоляции**. Обычно они требуют интеграции с другими системами, построенными в разное время и с применением различных технологий. Время от времени корпорации стараются провести интеграцию собственных подсистем с применением некоторой универсальной технологии. Поскольку обычно такой работе конца краю не видно, все сводится к применению нескольких различных методов интеграции. Ситуация усугубляется, если интеграции подлежит информация из совершенно разнородных источников.

Даже в том случае, если компания унифицирует способ интеграции своих подсистем, проблемы на этом не заканчиваются: новым камнем преткновения выступает различие в ведении бизнес-процессов и концептуальный диссонанс в представлении данных. В одном подразделении компании под клиентом подразумевают лицо, с которым заключено действующее соглашение; в другом к клиентам относят и тех, с кем приходилось работать прежде; в третьем учитывают только товарные сделки, но не оказанные услуги и т.п.