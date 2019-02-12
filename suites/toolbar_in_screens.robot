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

Универсальный отчет. Створити звіт у форматі таблиці
  В полі регістр вибрати пункт  Таблицы
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Создать отчет"
  Ввести Довільну Назву Звіту
  Перейти на вкладку "Поля"
  Вибрати три довільних поля
  Натиснути кнопку "Добавить"
  Перевірити відповідність заголовка звіту

Универсальный отчет. Видалити звіт
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Удалить отчет"
  Перевірити видалення звіту


*** Keywords ***
Створити звіт
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Создать отчет"
  Костыль для эджа


Костыль для эджа
  ${status}  Run Keyword And Return Status  Wait Until Element is Visible  //div[@class='message-box-button message-box-button-selected']
  Run Keyword If  ${status} == ${true}  Натиснути "ок" та спробувати створити звіт


Натиснути "ок" та спробувати створити звіт
  ${ok_button}  Set Variable  //div[@class='message-box-button message-box-button-selected']
  Click Element  ${ok_button}
  Wait Until Element Is Not Visible  ${ok_button}
  Створити Звіт
