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


Консоль. Перейти на вкладку C#
  Перейти на вкладку  C#


Консоль. C# Виконати команду
  Ввести команду  ${C# command}
  Натиснути кнопку "1 Выполнить"


Консоль. C# Перевірити виконання команди
  Перевірити наявність діалогу з таблицею


Консоль. C# Вставити текст у комірку та перейти на іншу
  ${selector}  Активувати комірку для редагування
  Вставити довільний текст до комірки  ${selector}
  Вибрати іншіу довільну комірку  ${selector}
  Перевірити збереження тексту в комірці  ${selector}