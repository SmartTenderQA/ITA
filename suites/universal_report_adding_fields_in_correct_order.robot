*** Settings ***
Documentation    Suite description
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Test Cases ***
Відкрити сторінку ITA
  Авторизуватися  ${login}  ${password}
  Відкрити головне меню та знайти пункт меню "Универсальный Отчет"


Створити звіт "UI-Тестирование"
  Ввести назву регістру  UI-Тестирование
  Перевірити що назва звіту не порожня
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Создать отчет"
  Ввести довільну назву звіту


Маніпуляції з полями
  Перейти на вкладку "Поля"
  Перевірити наявність елементів на сторінці
  Вибрати кілька довільних полей  2
  Натиснути на перший елемент колонки
  Додати довільне поле
  Перевірити що поле було додано на вірну позицію
  Запам'ятати послідовність доданих колонок
  Натиснути кнопку "Добавить"


Перевірка запам'ятовування створеного звіту після виходу
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити відповідність заголовка звіту


Натиснути кнопку "Сформировать отчет" та первірити результат
  Натиснути кнопку "Сформировать отчет"
  Перевірити створені колонки


Видалити створений звіт
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Удалить отчет"
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що назва звіту не порожня


*** Keywords ***
Відкрити головне меню та знайти пункт меню "Универсальный Отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


Вибрати кілька довільних полей
  [Arguments]  ${value}
  Set Global Variable  ${column_elements}  (//*[contains(@class, 'selectable')]/table)[2]//td[contains(@class,"cellmultiline")]
  :FOR  ${items}  IN RANGE  ${value}
  \  Додати довільне поле
  Sleep  2s
  ${right_count}  Get Element Count  ${column_elements}
  Should Be Equal  '${right_count}'  '${value}'


Додати довільне поле
  ${random}  random_number  1  10
  ${value}  Get Text  xpath=((//*[contains(@class, 'selectable')]/table)[1]//tr//span)[${random}]
  Set Global Variable  ${added_field}  ${value}
  wait until keyword succeeds  10  3  Click Element  xpath=((//*[contains(@class, 'selectable')]/table)[1]//tr//span)[${random}]
  wait until keyword succeeds  10  3  Click Element  xpath=(//div[@class="dhxform_btn"])[3]  #  0  -30  ${add_filter}
  Sleep  1
  ${added_table}  Get Text  xpath=(//*[contains(@class, 'selectable')]/table)[2]//td[contains(@class,"selected")]
  ${added_table}  Replace String  ${added_table}  ${\n}  ${space}
  Should Be Equal  ${value}  ${added_table}



Натиснути на перший елемент колонки
  Run Keyword And Ignore Error  Click Element  xpath=(${column_elements})[1]
  ${status}  Run Keyword And Return Status  Page Should Contain Element  xpath=(${column_elements})[1]/parent::*[contains(@class, "rowselected")]
  Run Keyword If  ${status} == ${False}  Натиснути на перше обране поле


Перевірити що поле було додано на вірну позицію
  Sleep  1
  ${added_column}  Get Text  xpath=(${column_elements})[2]
  ${added_column}  Replace String  ${added_column}  ${\n}  ${space}
  Should Be Equal  ${added_field}  ${added_column}


Запам'ятати послідовність доданих колонок
  ${columns_sequence}  Create List
  Set Global Variable  ${columns_sequence}
  ${right_count}  Get Element Count  ${column_elements}
  Set Global Variable  ${right_count}
  :FOR  ${items}  IN RANGE  ${right_count}
  \  ${added_column}  Get Text  xpath=(${column_elements})[${items} + 1]
  \  Append To List  ${columns_sequence}  ${added_column}


Натиснути кнопку "Сформировать отчет"
  Wait Until Keyword Succeeds  15  3  Click Element  xpath=//*[contains(text(), 'Сформировать отчет')]
  Дочекатись Загрузки Сторінки (ita)


Перевірити створені колонки
  Дочекатись Загрузки Сторінки (ita)
  Select Frame  //iframe
  ${document_columns_sequence}  Create List
  ${selector}  Set Variable  xpath=((//div[contains(@class, "dxss-gt")])[1]/descendant::div[contains(@class, "dxss-tb")])
  :FOR  ${items}  IN RANGE  ${right_count}
  \  ${document_column}  Get Text  ${selector}[${items} + 1]
  \  Append To List  ${document_columns_sequence}  ${document_column}
  Should Be Equal  ${document_columns_sequence}  ${columns_sequence}
  Unselect Frame


Перевірити наявність елементів на сторінці
  ${tables_count}  Get Element Count  //div[@class="gridbox"]
  Should Be True  ${tables_count} == 2
  ${buttons_count}  Get Element Count  //div[@class="dhxform_btn"]
  Should Be True  ${buttons_count} == 4
  Element Should Be Visible  (//div[contains(@class, "picture")]/img)[2]