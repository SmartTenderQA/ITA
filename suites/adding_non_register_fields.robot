*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${exp field}                        xpath=((//*[contains(@class, 'selectable')]/table)[1]//tr//div[1]//i)
${dict field}                       xpath=((//*[contains(@class, 'selectable')]/table)[1]//tr//*[@style="padding-left:60px"]//span)
${add field btn}                    xpath=(//div[@class="dhxform_btn"])[3]
${scroll field btn}                 xpath=//*[@help-id="REPZSMPLGRDSELECTFIELDS"]//*[@class="ps__scrollbar-y"]
${added fields}                     xpath=(//td[contains(@class,'multiline')])


#  robot -L TRACE:INFO -A suites/arguments.txt -v browser:chrome -v hub:None suites/adding_non_register_fields.robot
#  команда для запуска
*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
  Авторизуватися  ${login}  ${password}
  Створити пустий список


Відкрити головне меню та запустити функцію "Универсальный отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


В полі регістр вибрати пункт UI-Тестирование
  Ввести назву регістру  UI-Тестирование
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що поле не пусте  ${report_title}


Створити звіт та перейти на вкладку поля
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Создать отчет"
  Ввести довільну назву звіту
  Перейти на вкладку "Поля"


Додати довільні поля з довідника основного поля
  [Template]  Вибрати довільні поля з довідників
  1
  2
  3


Перевірити що правильність вибору полів
  Перевірити вибір полів


Додати та перевірити запам'ятовування створеного звіту
  Натиснути кнопку "Добавить"
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити відповідність заголовка звіту


Натиснути кнопку "Сформировать отчет" та первірити результат
  Натиснути кнопку "Сформировать отчет"
  Перевірити створені колонки



*** Keywords ***
Розкрити батьківське поле що має expander
  [Arguments]  ${i}
  Click Element  ${exp field}[${i}]
  Wait Until Page Contains Element  ${exp field}[${i}]/ancestor::tr/following-sibling::tr[1]//*[contains(text(),'right')]


Розкрити дочірній довідник з полями
  [Arguments]  ${i}
  ${i}  Evaluate  ${i} + 1
  Click Element  ${exp field}[${i}]
  Wait Until Page Contains Element  ${exp field}[${i}][contains(text(),'down')]


Вибрати довільні поля з довідників
  [Arguments]  ${index}
  Розкрити батьківське поле що має expander  ${index}
  Розкрити дочірній довідник з полями  ${index}
  Перевірити успішніть розгортання довідника полів  ${index}
  Додати довільне поле з довідника  ${index}
  Згорнути батьківське поле
  Прокрутити список полів


Перевірити успішніть розгортання довідника полів
  [Arguments]  ${i}
  ${i}  Evaluate  ${i} + 1
  Element Should Be Visible  ${exp field}[${i}][contains(text(),'down')]/..//*[contains(text(),'Справочник')]
  Element Should Be Visible  xpath=(//*[contains(@class, 'selectable')]/table)[1]//tr//*[@style="padding-left:60px"][1]


Згорнути батьківське поле
  Sleep  .5
  Click Element  ${exp field}[contains(text(),'down')][1]
  Sleep  .5


Створити пустий список
  ${list}  Create List
  Set Global Variable  ${list}


Прокрутити список полів
  Sleep  1
  Drag And Drop By Offset  ${scroll field btn}  0  150
  Sleep  1


Додати довільне поле з довідника
  [Arguments]  ${index}
  ${random}  random_number  1  4
  ${random}  Set Variable If  '${index}' == '3'  1  ${random}
  Click Element  ${dict field}[${random}]
  Wait Until Page Contains Element  ${dict field}[${random}]/ancestor::td[@class="cellselected"]
  ${fieldname}  Get Text  ${dict field}[${random}]
  Append To List  ${list}  ${fieldname}
  Click Element  ${add field btn}
  Sleep  1
  ${added_table}  Get Text  xpath=(//*[contains(@class, 'selectable')]/table)[2]//td[contains(@class,"selected")][last()]
  ${added_table}  Replace String  ${added_table}  ${\n}  ${space}
  Should Be Equal  ${fieldname}  ${added_table}


Перевірити вибір полів
  ${selected fields}  Create List
  Set Global Variable  ${selected fields}
  ${fields count}  Get Element Count  ${added fields}
  Set Global Variable  ${fields count}
  :FOR  ${i}  IN RANGE   ${fields count}
  \  ${i}  Evaluate  ${i} + 1
  \  ${fieldname}  Get Text  ${added fields}[${i}]
  \  ${fieldname}  Replace String  ${fieldname}  ${\n}  ${space}
  \  Append To List  ${selected fields}  ${fieldname}
  Should Be Equal  ${list}  ${selected fields}


Перевірити створені колонки
  Select Frame  //iframe
  ${document_columns_sequence}  Create List
  ${selector}  Set Variable  xpath=((//div[contains(@class, "dxss-gt")])[1]/descendant::div[contains(@class, "dxss-tb")])
  :FOR  ${i}  IN RANGE  ${fields count}
  \  ${i}  Evaluate  ${i} + 1
  \  ${document_column}  Get Text  ${selector}[${i}]
  \  ${document_column}  Replace String  ${document_column}  ${\n}  ${space}
  \  Append To List  ${document_columns_sequence}  ${document_column}
  log  ${document_columns_sequence}
  log  ${selected fields}
  Should Be Equal  ${document_columns_sequence}  ${selected fields}


Натиснути кнопку "Сформировать отчет"
  Wait Until Keyword Succeeds  15  3  Click Element  xpath=//*[contains(text(), 'Сформировать отчет')]
  Дочекатись Загрузки Сторінки (ita)