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


Відкрити "Консоль"
  Настиснути кнопку "Консоль"


"Консоль". Перейти на вкладку C#
  Перейти на вкладку  C#


"Консоль". C#.grid Виконати команду
  Ввести команду  ${C# grid}
  Натиснути кнопку "1 Выполнить"


"Консоль". C# Перевірити виконання команди
  Перевірити наявність діалогу з таблицею


"Консоль". C#.grid Корегування числової комірки
  Стати на першу комірку та натиснути Enter
  Ввести значення  1000
  Перевірити наявність messagebox
  Стати на першу комірку та натиснути Enter
  Ввести значення  0
  Перевірити наявність messagebox
