*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Test Cases ***
Авторизуватись
  Авторизуватися  ${login}  ${password}


Запустити функцію 'Универсальный отчет'
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню   Администрирование системы
  Натиснути пункт головного меню   Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


Универсальный отчет. Створити звіт "UI-Тестирование"
  Ввести назву регістру  UI-Тестирование
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Создать отчет"
  Ввести довільну назву звіту
  Натиснути кнопку "Добавить"
  Перевірити відповідність заголовка звіту


Универсальный отчет. Запам'ятовування створеного звіту після виходу
  Вийти з функції "Универсальный отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню   Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити відповідність заголовка звіту


Видалити створений звіт
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Удалить отчет"
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що назва звіту не порожня
