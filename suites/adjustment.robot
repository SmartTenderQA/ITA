*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
  Відкрити сторінку ITA
  Авторизуватися  ${login}  ${password}


Відкрити головне меню та знайти пункт меню "Учет изменений ПО"
  [Tags]  adjustment
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Учет изменений ПО


Учет изменений ПО. "Коректировка"
  [Tags]  adjustment  non-critical
  Перейти до екрану "Коректировка"
  Натиснути "Требует действий со стороны службы поддержки"
