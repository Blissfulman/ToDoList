# Приложение ToDoList

## Один из учебных проектов [курса «Middle iOS-Developer»](https://swiftbook.org/professions/71/show_promo) на Swiftbook.
**Идея приложения**: отображение списка задач с возможностью отмечать задачи выполненными.

**Основные возможности**:

1. Отображение списка задач с разбиением на секции по критерию выполненности.
2. Поддержка двух типов задач: обычных и важных.
3. У важных задач есть 3 приоритета: высокий, средний и низкий.
4. Задачи сортируются по приоритету.
5. Возможность менять состояние выполненности задач.
6. Подсветка просроченных задач.

**Особенности реализации**:

1. Для получения данных используется `ITaskRepository`.
2. Для управления задачами используется `ITaskManager`.
3. Presentation слой реализован с использованием шаблона MVP.
4. Вёрстка UI выполнена кодом.

**Запуск проекта локально:** достаточно клонировать репозиторий, открыть и запустить проект.

**Список изменений по порядку выполнения домашних работ:**

*Домашняя работа 4.* Реализованы модели задач, менеджер задач и UI приложения.  
*Домашняя работа 5.* Реализован репозиторий для получения задач, добавлено разбиение на секции по критерию выполненности, реализована сортировка по приоритету.  
*Домашняя работа 6.* Реализован патерн presentation слоя MVP, применены шаблоны декоратор и адаптер для получения отсортированных задач в моделях, соответствующих секциям таблицы.