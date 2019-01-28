*** Settings ***
Documentation    Suite description
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong

#  robot --consolecolors on -L TRACE:INFO -A suites/arguments.txt -v capability:chrome -v hub:None suites/printing_report_after_adjustment.robot
*** Test Cases ***
Виконати передумови
  Авторизуватися  ${login}  ${password}
  Відкрити головне меню та знайти пункт меню "Универсальный Отчет"


Створити звіт "UI-Тестирование (отчет)"
  Ввести назву регістру  UI-Тестирование
  Ввести назву звіту  UI-Тестирование (печать отчета после корректировки)
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
  Sleep  2
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що назва звіту  UI-Тестирование (печать отчета после корректировки)
  Перевірити створені колонки


Видалення доданого поля
  Натиснути кнопку "Конструктор"
  Перейти на вкладку "Поля"
  Перевірити наявність елементів на сторінці
  Обрати останній елемент правої таблиці
  Видалити обране поле таблиці
  Запам'ятати послідовність доданих колонок
  Натиснути кнопку "Сохранить"


Первірити результат видалення звіту
  Sleep  2
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що назва звіту  UI-Тестирование (печать отчета после корректировки)
  Перевірити створені колонки


*** Keywords ***
Відкрити головне меню та знайти пункт меню "Универсальный Отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


Ввести назву звіту
  [Arguments]  ${name}
  Click Element   ${report_title}
  Input Text  ${report_title}  ${name}
  Sleep  .5
  Підтвердити введення та перевірити що поле звіту не активне
  ${report}  Get Element Attribute  ${report_title}  value
  ${check_title}  Run Keyword And Return Status  Should Be Equal  ${report}  ${name}
  Run Keyword If  '${check_title}' == 'False'  Clear Element Text  ${report_title}
  Run Keyword If  '${check_title}' == 'False'  Ввести назву звіту  ${name}


Підтвердити введення та перевірити що поле звіту не активне
  Press Key  ${report_title}  \\09
  Sleep  1
  ${status}  Run Keyword And Return Status  Wait Until Page Does Not Contain Element  (//div[@data-caption="+ Добавить"])[2]/self::*[contains(@class, "actv")]
  Run Keyword If  ${status} == ${False}  Підтвердити введення та перевірити що поле звіту не активне


Натиснути кнопку "Сформировать отчет"
  ${selector}  Set Variable  xpath=//div[contains(@id, "TR_tb.0.0")]
  Click Element   //*[@id="REP_SIMPLEPRINT"]
  Дочекатись Загрузки Сторінки (ita)
  Select Frame  //iframe
  Wait Until Page Contains Element  ${selector}  10
  ${report_text}  Get Text  ${selector}
  ${status}  Run Keyword And Return Status  Should Not Be Empty  ${report_text}
  Unselect Frame
  Run Keyword If  ${status} == ${False}    Натиснути кнопку "Сформировать отчет"


Натиснути кнопку "Конструктор"
  Run Keyword And Ignore Error  Click Element  //div[@id="REP_SIMPLESETTINGS"]
  Дочекатись Загрузки Сторінки (ita)
  ${settings}  Run Keyword And Return Status  Wait Until Page Contains  Настройка отчета  10
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
  Unselect Frame


Перевірити що назва звіту
  [Arguments]  ${title}
  ${report}  Get Element Attribute  ${report_title}  value
  Should Be Equal  ${report}  ${title}


Видалити обране поле таблиці
  ${count}  Get Element Count  ${right_table_elems}
  Wait Until Keyword Succeeds  10  3  Click Element  xpath=(//div[@class="dhxform_btn"])[last()]
  Sleep  1
  Page Should Not Contain  xpath=(${right_table_elems})[${count}]