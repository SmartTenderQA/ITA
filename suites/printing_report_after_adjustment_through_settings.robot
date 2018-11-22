*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Test Cases ***
Виконати передумови
  Відкрити сторінку ITA
  Авторизуватися  ${login}  ${password}
  Відкрити головне меню та знайти пункт меню "Универсальный Отчет"


Створити звіт "UI-Тестирование (довільна назва)"
  Ввести назву регістру  UI-Тестирование
  Ввести назву звіту  UI-Тестирование (отчет)
  Натиснути кнопку "Сформировать отчет"
  Натиснути кнопку "Мои настройки"
  Перейти До Вкладки  Общие
  Ввести довільну назву звіту
  Натиснути кнопку "Сохранить"


Перевірити стврорення звіту
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити відповідність заголовка звіту
  Перевірити заголовок звіту в таблиці


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
  Set Global Variable  ${report_title_table}  //div[contains(@id, "TR_tb.0.0")]
  Click Element   //*[@id="REP_SIMPLEPRINT"]
  Дочекатись Загрузки Сторінки (ita)
  Select Frame  //iframe
  Wait Until Page Contains Element  ${report_title_table}
  ${report_text}  Get Text  ${report_title_table}
  ${status}  Run Keyword And Return Status  Should Not Be Empty  ${report_text}
  Unselect Frame
  Run Keyword If  ${status} == ${False}    Натиснути кнопку "Сформировать отчет"


Натиснути кнопку "Мои настройки"
  ${selector}  Set Variable  //*[@id="REP_SIMPLETEMP_SET"]
  Click Element   ${selector}
  ${status}  Run Keyword And Return Status
  ...  Wait Until Page Contains Element    ${selector}
  Run Keyword If  ${status} == ${False}    Натиснути кнопку "Мои настройки"
  Дочекатись Загрузки Сторінки (ita)
  ${my_settings}=    Get Text  //*[@class="float-container-header-text"]
  Should Contain Any  ${my_settings}  МОИ НАСТРОЙКИ  Мои настройки


Перейти До Вкладки
  [Arguments]  ${value}
  ${selector}  Set variable  //a[contains(text(), '${value}')]
  Wait Until Element Is Visible  ${selector}
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${selector}/parent::*[contains(@class, "active")]
  Run Keyword If  ${status} == ${False}  Перейти До Вкладки  ${value}
  Дочекатись Загрузки Сторінки (ita)


Натиснути кнопку "Сохранить"
  ${selector}  Set Variable  //*[contains(@class, "toolbar_text") and contains(text(), "Сохранить")]
  Wait until Element Is Visible  ${selector}
  Click Element   //*[contains(@class, "toolbar_text") and contains(text(), "Сохранить")]
  Дочекатись Загрузки Сторінки (ita)


Перевірити заголовок звіту в таблиці
  Select Frame  //iframe
  ${report_title}  Get Text  ${report_title_table}
  Should Be Equal  "${text}"  "${report_title}"
