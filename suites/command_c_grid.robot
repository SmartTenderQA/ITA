*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Test Cases ***
Авторизуватись
  Авторизуватися  ${login}  ${password}


Відкрити "Консоль"
  Настиснути кнопку "Консоль"


Консоль. Перейти на вкладку C#
  Перейти на вкладку  C#


Консоль. C#.grid Виконати команду
  Ввод команды в консоль  ${C# grid}
  Натиснути кнопку "1 Выполнить"


Консоль. C# Перевірити виконання команди
  Перевірити наявність діалогу з таблицею


Консоль. C#.grid Корегування числової комірки
  Стати на першу комірку та натиснути Enter
  Ввести значення  1000
  Перевірити наявність messagebox
  Стати на першу комірку та натиснути Enter
  Ввести значення  0
  Перевірити наявність messagebox
