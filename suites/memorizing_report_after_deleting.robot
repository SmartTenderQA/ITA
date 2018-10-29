*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Виконати передумови
  Відкрити сторінку ITA
  Авторизуватися  ${login}  ${password}
  Відкрити головне меню та знайти пункт меню "Универсальный Отчет"


Створити звіт "UI-Тестирование"
  Ввести назву регістру  UI-Тестирование
  Перевірити що назва звіту не порожня
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Удалить отчет"


"Универсальный отчет". Запам'ятовування створеного звіту після видалення
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що назва звіту не порожня
  Натиснути кнопку "Esc"
  Перевірити що відкрито початкову сторінку ITA
  Натиснути на логотип IT-Enterprise
  Виконати пошук пункта меню  Универсальный отчет
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити збереження назви звіту


*** Keywords ***
Відкрити головне меню та знайти пункт меню "Универсальный Отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


Перевірити що назва звіту не порожня
  ${report_header}=  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Set Global Variable  ${report_header}
  Should Be True  "${report_header}"


Натиснути кнопку "Esc"
  Press Key   //html/body    \\27
  Дочекатись Загрузки Сторінки (ita)


Перевірити що відкрито початкову сторінку ITA
  Page Should Contain Element  (//*[@title="Вид"])[2]


Перевірити збереження назви звіту
  ${value}=  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Should Be Equal  ${value}  ${report_header}