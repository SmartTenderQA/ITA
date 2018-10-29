*** Settings ***
Documentation    Suite description
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


Створити звіт "UI-Тестирование (отчет)"
  Ввести назву регістру  UI-Тестирование
  Ввести назву звіту  UI-Тестирование (отчет)
  Натиснути кнопку "Сформировать отчет"
  Натиснути кнопку "Конструктор"


Додавання полів
  Перейти на вкладку "Поля"
  Перевірити наявність елементів на сторінці
  Обрати останній елемент правої таблиці
  Додати довільне поле
  Запам'ятати послідовність доданих колонок
  Натиснути кнопку "Сохранить"


Первірити результат збереження звіту
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що назва звіту  UI-Тестирование (отчет)
  Перевірити створені колонки


*** Keywords ***
Відкрити головне меню та знайти пункт меню "Универсальный Отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


Ввести назву звіту
  [Arguments]  ${name}
  Input Type Flex  ${report_title}  ${name}
  Sleep  .5
  Press Key  ${report_title}  \\09
  Дочекатись загрузки сторінки (ita)
  ${report}  Get Element Attribute  ${report_title}  value
  ${check_title}  Run Keyword And Return Status  Should Be Equal  ${report}  ${name}
  Run Keyword If  '${check_title}' == 'False'  Clear Element Text  ${report_title}
  Run Keyword If  '${check_title}' == 'False'  Ввести назву звіту  ${name}


Натиснути кнопку "Сформировать отчет"
  ${selector}  Set Variable  //div[contains(@id, "TR_tb.0.0")]
  Click Element   //*[@id="REP_SIMPLEPRINT"]
  Дочекатись Загрузки Сторінки (ita)
  Select Frame  //iframe
  Wait Until Page Contains Element  ${selector}
  ${report_text}  Get Text  ${selector}
  ${status}  Run Keyword And Return Status  Should Not Be Empty  ${report_text}
  Unselect Frame
  Run Keyword If  ${status} == ${False}    Натиснути кнопку "Сформировать отчет"


Натиснути кнопку "Конструктор"
  Run Keyword And Ignore Error  Click Element  //div[@id="REP_SIMPLESETTINGS"]
  Дочекатись Загрузки Сторінки (ita)
  ${settings}  Run Keyword And Return Status  Wait Until Element is Visible  xpath=//div[contains(text(), 'Настройка отчета')]  10
  Run Keyword If  '${settings}' == 'False'  Натиснути кнопку "Конструктор"


Перейти на вкладку "Поля"
  Click Element  xpath=//a[.='Поля']
  Wait Until Page Contains Element  xpath=//li[.='Поля' and @aria-selected="true"]
  Sleep  3


Перевірити наявність елементів на сторінці
  ${tables_count}  Get Element Count  //div[@class="gridbox"]
  Should Be True  ${tables_count} == 2
  ${buttons_count}  Get Element Count  //div[@class="dhxform_btn"]
  Should Be True  ${buttons_count} == 4
  Element Should Be Visible  (//div[contains(@class, "picture")]/img)[2]


Обрати останній елемент правої таблиці
  Set Global Variable  ${right_table_elems}  (//*[contains(@class, "selectable")]/table)[2]//td[contains(@class,"cellmultiline")]
  Run Keyword And Ignore Error  Click Element  xpath=(${right_table_elems})[last()]
  Sleep  .5
  ${status}  Run Keyword And Return Status  Page Should Contain Element  xpath=(${right_table_elems})[last()]/parent::*[contains(@class, "rowselected")]
  Run Keyword If  '${status}' == 'False'  Обрати останній елемент правої таблиці


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


Запам'ятати послідовність доданих колонок
  ${columns_sequence}  Create List
  Set Global Variable  ${columns_sequence}
  ${right_count}  Get Element Count  ${right_table_elems}
  Set Global Variable  ${right_count}
  :FOR  ${items}  IN RANGE  ${right_count}
  \  ${added_column}  Get Text  xpath=(${right_table_elems})[${items} + 1]
  \  Append To List  ${columns_sequence}  ${added_column}


Натиснути кнопку "Сохранить"
  ${selector}  Set Variable  //*[contains(@class, "toolbar_text") and contains(text(), "Сохранить")]
  Wait until Element Is Visible  ${selector}
  Click Element   ${selector}
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


Перевірити що назва звіту
  [Arguments]  ${title}
  ${report}  Get Element Attribute  ${report_title}  value
  Should Be Equal  ${report}  ${title}