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


"Универсальный отчет". Створити звіт "UI-Тестирование"
  Відкрити головне меню та знайти пункт меню "Универсальный Отчет"
  В полі регістр вибрати пункт  UI-Тестирование
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що назва звіту не порожня
  Натиснути кнопку "Мои настройки"
  Перейти До Вкладки  Общие
  Ввести довільну назву звіту
  Натиснути кнопку "Сохранить"
  Перевірити відповідність заголовка звіту


"Универсальный отчет". Зберегти звіт як новий
  Натиснути кнопку "Больше опций"(три крапки)
  Обрати пункт "Сохранить как новый"
  Натиснути кнопку "Сохранить"
  Перевірити відповідність заголовка звіту


Вийти з функції
  Натиснути кнопку "Esc"
  Перевірити що відкрито початкову сторінку ITA


"Универсальный отчет". Запам'ятовування створеного звіту після виходу
  Натиснути на логотип IT-Enterprise
  Виконати пошук пункта меню  Универсальный отчет
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити відповідність заголовка звіту


*** Keywords ***
Відкрити головне меню та знайти пункт меню "Универсальный Отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


Перевірити що обрано пункт
  [Arguments]  ${value}
  ${register} =  Get Element Attribute  (//*[contains(text(), 'Регистр')]/ancestor::div[2]//input)[1]    value
  Should Be Equal  '${register}'  '${value}'


Перевірити що назва звіту не порожня
  ${report_header}=  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Should Be True  '${report_header}'


Натиснути кнопку "Мои настройки"
  Sleep  2
  ${selector}  Set Variable  //*[@id="REP_SIMPLETEMP_SET"]
  Click Element   ${selector}
  ${status}  Run Keyword And Return Status
  ...  Wait Until Page Contains Element    ${selector}
  Run Keyword If  ${status} == ${False}    Натиснути кнопку "Мои настройки"
  Дочекатись Загрузки Сторінки (ita)
  ${my_settings}=    Get Text  //*[@class="float-container-header-text"]
  Should Be Equal   '${my_settings}'  'МОИ НАСТРОЙКИ'


Натиснути кнопку "Сохранить"
  Click Element   //*[contains(@class, "toolbar_text") and contains(text(), "Сохранить")]
  Дочекатись Загрузки Сторінки (ita)


Натиснути кнопку "Больше опций"(три крапки)
  Click Element   //*[@class="material-icons control-toolbar-button-dropdown"]
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element    //*[@class="material-icons control-toolbar-button-dropdown"]
  Run Keyword If  ${status} == ${False}  Натиснути кнопку "Больше опций"(три крапки)


Обрати пункт "Сохранить как новый"
  Click Element   //*[contains(text(), "Сохранить как новый")]
  Дочекатись Загрузки Сторінки (ita)


Натиснути кнопку "Esc"
  Press Key   //html/body    \\27
  Дочекатись Загрузки Сторінки (ita)


Перевірити що відкрито початкову сторінку ITA
  Page Should Contain Element  (//*[@title="Вид"])[2]

Перейти До Вкладки
  [Arguments]  ${value}
  Wait Until Page Contains Element  //a[contains(text(), '${value}')]
  Click Element  //a[contains(text(), '${value}')]