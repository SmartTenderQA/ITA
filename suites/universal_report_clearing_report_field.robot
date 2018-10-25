*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


#  robot -L TRACE:INFO -A suites/arguments.txt -v browser:chrome -v env:ITA -v hub:${Empty} suites/universal_report_clearing_report_field.robot
#  команда для запуска
*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
  Відкрити сторінку ITA
  Авторизуватися  ${login}  ${password}


Відкрити головне меню та знайти пункт меню "Универсальный отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


В полі регістр вибрати пункт UI-Тестирование
  Ввести назву регістру  UI-Тестирование
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що поле не пусте  ${report_title}


Очистити поле "Регистр"
  Очистити поле від тексту  ${register_selector}
  Перевірити що поле не пусте  ${register_selector}
  Перевірити що поле не пусте  ${report_title}


*** Keywords ***
Перевірити що обрано пункт
  [Arguments]  ${value}
  Set Global Variable  ${register_selector}  (//*[contains(text(), 'Регистр')]/ancestor::div[2]//input)[1]
  ${register} =  Get Element Attribute   ${register_selector}   value
  Should Be Equal  '${register}'  '${value}'


Очистити поле від тексту
  [Arguments]  ${field}
  Sleep  .5
  Click Element  ${field}
  Sleep  .5
  Run Keyword And Ignore Error  Click Element  //div[@id="Clear"]
  Sleep  .5
  ${field value}  Get Element Attribute  ${field}  value
  ${status}  Run Keyword And Return Status  Should Be Empty  ${field value}
  Run Keyword If  ${status} == ${False}  Очистити поле від тексту  ${field}
  Press Key  ${field}  \\9   #press tab
  Дочекатись Загрузки Сторінки (ita)



