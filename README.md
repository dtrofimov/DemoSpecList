# DemoSpecList

DemoSpecList — небольшое iOS-приложение, решение тестового задания по iOS-разработке. Приложение показывает список специальностей врачей, полученный по Web API DocDoc.

## Постановка задачи

> Сделать вывод списка специальностей в таблицу. Сделать кэширование данных.
>
> Дизайн и технологии на усмотрение составляющего. Язык программирования — Swift, последний стабильный xCode.
>
> Ожидаемое время выполнения — 1-2 часов.
>
> https://109.docs.apiary.io/#introduction/changelog
> 
> логин для доступа к API: partner.13703
> 
> пароль для доступа к API: ZZdFmtJD
>
> Как бонус, при желании — можно сделать выдачу врачей после выбора специальности.
>
> Результат опубликовать в открытый репозиторий.

Также в устном порядке получено указание придерживаться минимализма и не усложнять проект компонентами, не оправданными для проекта такого размера.

##  Технические решения

* Архитектура Cocoa MVC, как наиболее популярная и выгодная для мелких и средних проектов.
* Решение проблемы Massive View Controller через простейшую декомпозицию на категории в рамках одного файла.
* Интерфейс верстается через XIB'ы.
* Отсутствие юнит-тестов на данном этапе, ибо не окупаются на одноразовом мелком проекте.
* Для сторонних библиотек используется CocoaPods.
* Бизнес-логика приложения традиционным образом разделена на экраны, сервис-запросы и сущности модели. С деталями сетевого слоя (Alamofire) сцеплена реализация сервис-запросов (ибо соответствующий слой абстракции слишком широкий и дорогой для маленького проекта), но не сцеплен интерфейс сервис-запросов (вью-контроллеры не знают про Alamofire).
* Интерфейс сервис-запросов предполагает такой сценарий: создать, сконфигурировать, запустить асинхронным методом с `completionHandler`, в который передаётся `Result` (значение либо ошибка). Ошибки возвращаются своего типа `enum ServiceError: Error`.
* Сетевая логика, переиспользуемая в сервис-запросах, обёрнута в `DocDocApiClient`, который инъектится в сервис-запросы.
* Маппинг объектов модели (`Spec`) вынесен в категории этих объектов (`Spec+Mapping`), ибо эта логика потенциально переиспользуема в нескольких сервис-запросах. Сторонние библиотеки для маппинга не используются, ибо здесь и так всё тривиально.

## Логика экрана с результатами запроса

В штатном режиме на экране отображается table view с результатами запроса. Кроме этого, стандартной практикой является отображение следующей информации:

* наличие текущего запроса (индикатор активности):
  * в центре экрана, если нет контента;
  * в виде refresh control, если есть контент;
* плейсхолдер для пустой выдачи;
* информация о неудаче загрузки:
  * в центре экрана, если нет контента;
  * в виде всплывающего баннера, если есть контент.

С учётом данной информации, экран может принимать следующие состояния.

![screenshot 1](/screenshots/screenshot1.png)
![screenshot 2](/screenshots/screenshot2.png)
![screenshot 3](/screenshots/screenshot3.png)
![screenshot 4](/screenshots/screenshot4.png)
![screenshot 5](/screenshots/screenshot5.png)
![screenshot 6](/screenshots/screenshot6.png)
![screenshot 7](/screenshots/screenshot7.png)
![screenshot 8](/screenshots/screenshot8.png)
![screenshot 9](/screenshots/screenshot9.png)
