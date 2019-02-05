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


Консоль. C# Виконати команду
  Ввод команды в консоль  ${C# command}
  Натиснути кнопку "1 Выполнить"


Консоль. C# Перевірити виконання команди
  Перевірити наявність діалогу з таблицею


Консоль. C# Вставити текст у комірку та перейти на іншу
  ${selector}  Активувати комірку для редагування
  Вставити довільний текст до комірки  ${selector}
  Вибрати іншіу довільну комірку  ${selector}
  Перевірити збереження тексту в комірці  ${selector}

