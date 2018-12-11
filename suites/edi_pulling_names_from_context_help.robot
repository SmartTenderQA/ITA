*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${values}          //*[@class="ade-val-container"]/*[@class="ade-val"]


#robot -L TRACE:INFO -A suites/arguments.txt -v capability:chrome -v hub:None suites/edi_pulling_names_from_context_help.robot
*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
    Авторизуватися  ${login}  ${password}


Відкрити "Консоль" та виконати команду
    Настиснути кнопку "Консоль"
    Перейти на вкладку  C#
    Ввод команды в консоль  ${edi_polling}
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
    ${label}  set variable  Код ЕИ
    ${text}  Get text  ${selector}
    ${text}  Run Keyword If  '${capability}' == 'edge'  Replace String  ${text}  \xa0  ${EMPTY}
    ${label}  Run Keyword If  '${capability}' == 'edge'  Replace String  ${label}  ${SPACE}  ${EMPTY}
    Should Be Equal  ${label}  ${text}
    Page Should Contain Element  //*[@class="dhxcombo_input_container "]


Натиснути на лупу (F10)
#    Активувати вікно якщо потрібно
    Run Keyword If  '${capability}' == 'edge'  Click Element  //*[contains(@class, "multy-value-ade")]
    ${selector}  Set Variable  //*[@id="HelpF10"]
    Wait Until Element Is Visible  ${selector}
    Wait Until Keyword Succeeds  15  2  Click Element  ${selector}
    Wait Until Page Does Not Contain Element  ${selector}


Активувати вікно якщо потрібно
    ${placeholder}  Set Variable  //*[@data-caption="+ Добавить"]
    ${status}  Run Keyword And Return Status  Element Should not Be Visible  ${placeholder}
    Run Keyword If  ${status} == ${false}  Click Element  //*[contains(@class, "multy-value-ade")]
    Sleep  3
    ${status}  Run Keyword And Return Status  element should be visible  //*[contains(@class, "dhxcombo_input_container")]//input
    Run Keyword If  ${status} == ${false}  Активувати вікно якщо потрібно


Натиснути "Выбрать все" в довіднику
    Wait Until Page Contains  Справочник единиц измерения. Выберите из списка
    Click Element  //*[text()="Выбрать все"]
    Wait Until Page Contains Element  //*[@class="frame-header selection-mode"]
    Page Should Contain Element  //i[text()="check_box"]


Натиснути "Отменить все" в довіднику
    Wait Until Page Contains  Справочник единиц измерения. Выберите из списка
    Click Element  //*[text()="Отменить все"]
    Дочекатись Загрузки Сторінки (ita)


Натиснути "ОК" у довіднику
    ${selector}  Set Variable  //*[@class="dhxtoolbar_text" and text()="OK"]
    CLick Element  ${selector}
    Дочекатись загрузки сторінки (ita)
    Wait Until Page Does Not Contain Element  //div[text()="Справочник единиц измерения. Выберите из списка"]  20


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
    ${values}  Set Variable  //*[@class="ade-val-container"]/*[@class="ade-val"]
    ${n}  Get Element Count  ${values}
    Should Be Equal  '0'  '${n}'