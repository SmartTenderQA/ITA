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


#  robot -L TRACE:INFO -A suites/arguments.txt -v browser:chrome -v hub:None suites/Adding_non_register_fields.robot
#  команда для запуска
*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
  Авторизуватися  ${login}  ${password}


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


Перевірити розкриття полія та його довідника
  Розкрити перше батьківське поле що має expander
  Розкрити дочірній довідник з полями
  Перевірити успішніть розгортання довідника полів


Додати довільні поля з довідника основного поля
  Вибрати довільні поля з довідника  3
  Натиснути кнопку "Добавить"


Перевірка запам'ятовування створеного звіту після виходу
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити відповідність заголовка звіту


Натиснути кнопку "Сформировать отчет" та первірити результат
  Натиснути кнопку "Сформировать отчет"
  Перевірити створені колонки



*** Keywords ***
Розкрити перше батьківське поле що має expander
  Click Element  ${exp field}[1]
  Wait Until Page Contains Element  ${exp field}[1][contains(text(),'down')]



Розкрити дочірній довідник з полями
  Click Element  ${exp field}[2]
  Wait Until Page Contains Element  ${exp field}[2][contains(text(),'down')]


Перевірити успішніть розгортання довідника полів
  Element Should Be Visible  ${exp field}[2][contains(text(),'down')]/..//*[contains(text(),'Справочник')]
  Element Should Be Visible  xpath=(//*[contains(@class, 'selectable')]/table)[1]//tr//*[@style="padding-left:60px"][1]


Вибрати довільні поля з довідника
  [Arguments]  ${i}
  Створити пустий список
  #Прокрутити список полів
  Repeat Keyword  ${i} times  Додати довільне поле з довідника
  Перевірити вибір полів


Створити пустий список
  ${list}  Create List
  Set Global Variable  ${list}


Прокрутити список полів
  Sleep  1
  Drag And Drop By Offset  ${scroll field btn}  0  24
  Sleep  1


Додати довільне поле з довідника
  ${random}  random_number  1  4
  Click Element  ${dict field}[${random}]
  Wait Until Page Contains Element  ${dict field}[${random}]/ancestor::td[@class="cellselected"]
  ${fieldname}  Get Text  ${dict field}[${random}]
  Append To List  ${list}  ${fieldname}
  Click Element  ${add field btn}


Перевірити вибір полів
  ${selected fields}  Create List
  Set Global Variable  ${selected fields}
  ${fields count}  Get Element Count  ${added fields}
  Set Global Variable  ${fields count}
  :FOR  ${index}  IN RANGE   ${fields count}
  \  ${fieldname}  Get Text  ${added fields}[${index} + 1]
  \  ${fieldname}  Replace String  ${fieldname}  ${\n}  ${space}
  \  Append To List  ${selected fields}  ${fieldname}
  debug
  Should Be Equal  ${list}  ${selected fields}


Перевірити створені колонки
  Select Frame  //iframe
  ${document_columns_sequence}  Create List
  ${selector}  Set Variable  xpath=((//div[contains(@class, "dxss-gt")])[1]/descendant::div[contains(@class, "dxss-tb")])
  :FOR  ${items}  IN RANGE  ${right_count}
  \  ${document_column}  Get Text  ${selector}[${items} + 1]
  \  Append To List  ${document_columns_sequence}  ${document_column}
  Should Be Equal  ${document_columns_sequence}  ${selected fields}