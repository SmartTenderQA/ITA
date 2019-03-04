*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${name field}        (//*[text()="Наименование:"]/following-sibling::div/span)
${code field}        (//*[text()="Код символьный:"]/following-sibling::div/span)
${checkbox}          (//*[text()="Наименование:"]/ancestor::div[@class="dhxcombo_option_text"]//input)


#robot -L TRACE:INFO -A suites/arguments.txt -v capability:chrome -v hub:None suites/dropdown_letters.robot
*** Test Cases ***
Авторизуватись
    Авторизуватися  ${login}  ${password}


Відкрити "Консоль" та виконати команду
    Настиснути кнопку "Консоль"
    Перейти на вкладку  C#
    Ввод команды в консоль  ${dropdown letters var}
    Натиснути кнопку "1 Выполнить"
    Перевірити наявність напису "Код" та АДЄ
    Перевірити у АДЄ значення очищено


Вибрати значення з випадаючого списку (не пусті)
    Розкрити випадаючий список
    Вибрати довільні букви (не пусті)


Звірити код і найменування значень з випадающого списку
    Перевірити що найменування та код в значеннях співпадають
    Закрити випадаючий список (ESC)
    Натиснути "ОК"


Перевірити відповідність значень у message-box
    Звірити значення у message-box
    Натиснути "ОК" у message-box
    Дочекатись загрузки сторінки (ita)


Вибрати значення з випадаючого списку (одне пусте)
    Натиснути кнопку "1 Выполнить"
    Розкрити випадаючий список
    Вибрати букви та одне пусте поле
    Закрити випадаючий список (ESC)
    Натиснути "ОК"


Перевірити відповідність значень у message-box (з пустим значенням)
    Звірити значення у message-box


*** Keywords ***
Перевірити наявність напису "Код" та АДЄ
    ${selector}  Set Variable  //*[contains(@class,"dhxform_txt_label")]
    Wait Until Element Is Visible  ${selector}
    ${label}  Get text  ${selector}
    Should Be Equal  '${label}'  'Код'
    Page Should Contain Element  //*[@class="dhxcombo_input_container "]


Перевірити у АДЄ значення очищено
    ${values}  Set Variable  //*[@class="ade-val-container"]/*[@class="ade-val"]
    ${n}  Get Element Count  ${values}
    Should Be Equal  '0'  '${n}'


Розкрити випадаючий список
    Активувати вікно якщо потрібно
    Sleep  1
	Run Keyword If  '${browser}' == 'edge'  Click Element at coordinates  //*[contains(@class, "fixed-invisible-ade-buttons")]  0  0
	...  ELSE  Click Element  //*[contains(@class, "fixed-invisible-ade-buttons")]
    Element Should Not Be Visible  //*[contains(@style, "display: none") and @class="ade-list-back"]//*


Активувати вікно якщо потрібно
    ${placeholder}  Set Variable  //*[@data-caption="+ Добавить"]
    ${status}  Run Keyword And Return Status  Element Should not Be Visible  ${placeholder}
    Run Keyword If  ${status} == ${false}  Click Element  //*[contains(@class, "multy-value-ade")]
    Sleep  3
    ${status}  Run Keyword And Return Status  element should be visible  //*[contains(@class, "dhxcombo_input_container")]//input
    Run Keyword If  ${status} == ${false}  Активувати вікно якщо потрібно


Вибрати довільні букви (не пусті)
    ${dict of values}  Create Dictionary
    :FOR  ${i}  IN RANGE  1  4
    \  Wait Until Element Is Visible  ${checkbox}\[${i}]
    \  Click Element      ${checkbox}\[${i}]
    \  ${name}  get text  ${name field}\[${i}]
    \  ${code}  get text  ${code field}\[${i}]
    \  Set To Dictionary  ${dict of values}  ${name}  ${code}
    Set Global Variable   ${dict of values}


Перевірити що найменування та код в значеннях співпадають
    ${edi field}    Set Variable  (//*[@class="ade-val-caption"])
    ${dict of edi}  Create Dictionary
    ${n}  Get Element Count  ${edi field}
    :FOR  ${i}  IN RANGE  1  ${n}+1
    \  ${value}  Get Text  ${edi field}\[${i}]
    \  ${name}  Evaluate  re.search(r'(?P<name>.*) \\((?P<code>\\w)\\)', u'${value}').group('name')  re
    \  ${code}  Evaluate  re.search(r'(?P<name>.*) \\((?P<code>\\w)\\)', u'${value}').group('code')  re
    \  Set To Dictionary  ${dict of edi}  ${name}  ${code}
    Set Global Variable  ${dict of edi}
    Dictionaries Should Be Equal  ${dict of values}  ${dict of edi}


Закрити випадаючий список (ESC)
    Press Key  //*[@data-caption="+ Добавить"]//td[2]//input  \\27
    ${status}  Run Keyword And Return Status  Wait Until element is Not visible  //*[text()="Наименование:"]/following-sibling::div/span  10
    Run Keyword If  ${status} == ${false}  Закрити випадаючий список (ESC)
    Sleep   2


Натиснути "ОК"
    ${selector}  Set Variable  //*[@class="dhxtoolbar_text" and text()="OK"]
    Wait Until Element Is Visible  ${selector}
    ${status}  Run Keyword And Return Status  CLick Element  ${selector}
    Run Keyword If  ${status} == ${false}  Run Keywords  Закрити випадаючий список (ESC)  AND  Натиснути "ОК"


Звірити значення у message-box
    ${selector}  Set Variable  //*[@class="message-box-content-body"]
    Wait Until Element is Visible  ${selector}
    Page Should Contain  Выбранные значения
    ${value}  Get text  ${selector}
    ${codes}  Evaluate  re.search(r'- (?P<code>.*)', '${value}').group('code')  re
    ${codes}  Evaluate  re.split(r',', '${codes}')  re
    ${dict values}  Get Dictionary Values  ${dict of values}
    Should Be Equal  ${dict values}  ${codes}


Натиснути "ОК" у message-box
    ${selector}  Set Variable  //*[contains(@class,'message-box-button')][text()="ОК"]
    Click Element  ${selector}
    Wait Until element is Not visible  ${selector}


Вибрати букви та одне пусте поле
    Вибрати довільні букви (не пусті)
    Вибрати пусте значення


Вибрати пусте значення
    ${empty field}  get text  ${name field}\[text()="Пустое"]
    ${empty code}   get text  ${name field}\[text()="Пустое"]/../../following-sibling::div[2]//span
    Click Element  ${name field}\[text()="Пустое"]/../../..//input
    Set To Dictionary  ${dict of values}  ${empty field}  ${empty code}
    Set Global Variable   ${dict of values}