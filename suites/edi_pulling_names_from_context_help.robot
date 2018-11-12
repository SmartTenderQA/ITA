*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${values}          //*[@class="ade-val-container"]/*[@class="ade-val"]


#robot -L TRACE:INFO -A suites/arguments.txt -v capability:chrome -v hub:None suites/edi_pulling_names_from_context_help.robot
*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
    Авторизуватися  ${login}  ${password}


Відкрити "Консоль" та виконати команду
    Настиснути кнопку "Консоль"
    Перейти на вкладку  C#
    Ввести команду  ${edi_polling}
    Натиснути кнопку "1 Выполнить"
    Перевірити наявність напису "Код ЕИ" та АДЄ


Відкрити довідник натиснувши на лупу та вибрати всі строки
    Натиснути на лупу (F10)
    Натиснути "Выбрать все" в довіднику
    Натиснути "ОК" у довіднику


Перевірити що після повторного відкриття довіника кількість значень не змінилась
    Перевірити у АДЄ наявніть вибраних значень
    Натиснути "+ Добавить"
    Натиснути на лупу (F10)
    Натиснути "ОК" у довіднику
    Перевірити у АДЄ що кількість значень не змінилась


Перевірити очищення вибраних значень
    Натиснути "+ Добавить"
    Натиснути на лупу (F10)
    Натиснути "Отменить все" в довіднику
    Натиснути "ОК" у довіднику
    Перевірити у АДЄ значення очищено



*** Keywords ***
Перевірити наявність напису "Код ЕИ" та АДЄ
    ${selector}  Set Variable  //*[contains(@class,"dhxform_txt_label")]
    Wait Until Element Is Visible  ${selector}
    ${label}  Get text  ${selector}
    Should Be Equal  '${label}'  'Код ЕИ'
    Page Should Contain Element  //*[@class="dhxcombo_input_container "]


Натиснути на лупу (F10)
    ${selector}  Set Variable  //*[@id="HelpF10"]
    Wait Until Element Is Visible  ${selector}
    Click Element  ${selector}
    Wait Until Page Does Not Contain Element  ${selector}


Натиснути "Выбрать все" в довіднику
    Wait Until Page Contains  Справочник единиц измерения. Выберите из списка
    Click Element  //*[text()="Выбрать все"]
    Wait Until Page Contains Element  //*[@class="frame-header selection-mode"]
    Page Should Contain Element  //i[text()="check_box"]


Натиснути "Отменить все" в довіднику
    Wait Until Page Contains  Справочник единиц измерения. Выберите из списка
    Click Element  //*[text()="Отменить все"]
    Sleep  .5


Натиснути "ОК" у довіднику
    ${selector}  Set Variable  //*[@class="dhxtoolbar_text" and text()="OK"]
    CLick Element  ${selector}
    Wait Until Page Does Not Contain  Справочник единиц измерения. Выберите из списка  20


Перевірити у АДЄ наявніть вибраних значень
    ${n}  Get Element Count  ${values}
    Should Not Be Equal  '0'  '${n}'
    Set Global Variable  ${count}  ${n}


Натиснути "+ Добавить"
    Click Element  //*[@data-caption="+ Добавить"]


Перевірити у АДЄ що кількість значень не змінилась
    ${n}  Get Element Count  ${values}
    Should Be Equal  ${count}  ${n}


Перевірити у АДЄ значення очищено
    ${n}  Get Element Count  ${values}
    Should Be Equal  '0'  '${n}'