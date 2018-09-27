*** Settings ***
Documentation    ITA
Library     Selenium2Library
Library     BuiltIn
Library     Collections
Library     DebugLibrary
Library     data.py
Library     ../../src/Faker/faker.py
Variables   ../../suites/ita/var.py

Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${browser}                            chrome
&{url}
...                                   ITA=https://webclient.it-enterprise.com/clientrmd/(S(nwqigpdz3z031icvawluswqc))/?win=1&ClientDevice=Desktop&isLandscape=true&tz=3
...                                   ITA_web2016=https://webclient.it-enterprise.com/client/(S(4rlzptork1sl10dr1uhr0vdi))/?win=1&tz=3
...                                   ITCopyUpgrade=https://m.it.ua/ITCopyUpgrade/CLIENTRMD/(S(iuhcsthigv3rjj1qattj3aby))/?proj=it_RU&win=1&ClientDevice=Desktop&isLandscape=true&tz=3
${loading}                            xpath=//*[@class="spinner"]
${login_field}                        xpath=((//*[contains(text(), 'пользователя')])[2]/ancestor::div[2]//input)[1]
${pass_field}                         xpath=((//*[contains(text(), 'Пароль')])[2]/ancestor::div[2]//input)[2]
${console}                            xpath=//*[contains(@title, 'Консоль')]
${message-box}                        xpath=//*[@class='message-box']
${menu_tools}                         xpath=//*[contains(text(), 'Инструменты и настройки')]
${menu_report}                        xpath=(//*[contains(text(), 'Универсальный отчет')])[1]
${constructor_drop_down}              xpath=//*[contains(@title, 'Конструктор')]//*[@class="sb-dd"]
${create_report}                      xpath=//*[contains(text(), 'Создать отчет')]
${delete_report}                      xpath=//*[contains(text(), 'Удалить отчет')]
${report_name}                        xpath=//div[contains(@title, 'Введите наименование отчета')]/preceding-sibling::*//input
${add_filter}                         xpath=(//*[@class='dhxform_btn_filler'])[5]
${add_report}                         xpath=//*[text()='Добавить']
${logo}                               xpath=//*[@class="it-logo-wrapper" and @title='Главное меню']
${search}                             xpath=//*[@class="search-panel-text"]
${F7}                                 xpath=(//*[contains(@title, '(F7)')])[1]
${menu_scroll}                        xpath=//*[@class="start-menu-tree-view-container"]/following-sibling::*[@class="ps__scrollbar-y-rail"]
${toolbar}                            xpath=//*[@class="control-toolbar"]
${report_title}                       xpath=(//div[text()='Отчет']/ancestor::div[2]//input[@type='text'])[2]
${enter btn}                          \\13
${C# command}                         ${command_c}
${VFP command}                        ${command_vfp}
${C# grid}                            ${command_c_grid}



*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
  [Tags]  console_vfp
  ...  console_c
  ...  report
  ...  report2
  ...  adjustment
  ...  command_c_grid
  Відкрити сторінку ITA
  Авторизуватися  ${login}  ${password}

Відкрити "Консоль"
  [Tags]  console_vfp
  ...  console_c
  ...  command_c_grid
  Настиснути кнопку "Консоль"

"Консоль". Перейти на вкладку VFP
  [Tags]  console_vfp
  Перейти на вкладку  Vfp

"Консоль". Перейти на вкладку C#
  [Tags]  console_c
  ...  command_c_grid
  Перейти на вкладку  C#

"Консоль". VFP Виконати команду
  [Tags]  console_vfp
  Ввести команду  ${VFP command}
  Натиснути кнопку "1 Выполнить"
  Перевірити виконання команди VFP
  Перевірити наявність кнопок "Да/Нет"
  Натиснути кнопку "Да" для закриття діалогу

"Консоль". C# Виконати команду
  [Tags]  console_c
  Ввести команду  ${C# command}
  Натиснути кнопку "1 Выполнить"

"Консоль". C#.grid Виконати команду
  [Tags]  command_c_grid
  Ввести команду  ${C# grid}
  Натиснути кнопку "1 Выполнить"

"Консоль". C# Перевірити виконання команди
  [Tags]  console_c
  ...  command_c_grid
  Перевірити наявність діалогу з таблицею

"Консоль". C#.grid Корегування числової комірки
  [Tags]  command_c_grid
  Стати на першу комірку та натиснути Enter
  Ввести значення  1000
  Перевірити наявність messagebox
  Стати на першу комірку та натиснути Enter
  Ввести значення  0
  Перевірити наявність messagebox

"Консоль". C# Вставити текст у комірку та перейти на іншу
  [Tags]  console_c
  Активувати комірку для редагування
  Вставити довільний текст до комірки
  Вибрати іншіу довільну комірку

"Консоль". C# Перевірити збереження тексту в комірці
  [Tags]  console_c
  Перевірити збереження тексту в комірці

Запустити функцію 'Универсальный отчет'
  [Tags]  report
  ...  report2
  Натиснути на логотип IT-Enterprise
  Натиснути пункт меню "Инструменты и настройки"
  Вибрати пункт меню "Универсальный отчет"

"Универсальный отчет". Створити звіт у форматі таблиці
  [Tags]  report
  В полі регістр вибрати пункт  Таблицы
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Создать отчет"
  Ввести довільну назву звіту
  Перейти на вкладку "Поля"
  Вибрати три довільних поля
  Натиснути кнопку "Добавить"
  Перевірити відповідність заголовка звіту

"Универсальный отчет". Видалити звіт
  [Tags]  report
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Удалить отчет"
  Перевірити видалення звіту

"Универсальный отчет". Створити звіт "UI-Тестирование"
  [Tags]  report2
  В полі регістр вибрати пункт  UI-Тестирование
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Создать отчет"
  Ввести довільну назву звіту
  Натиснути кнопку "Добавить"
  Перевірити відповідність заголовка звіту

Универсальный отчет. Запам'ятовування створеного звіту після виходу
  [Tags]  report2
  Вийти з функції "Универсальный отчет"
  Натиснути на логотип IT-Enterprise
  Вибрати пункт меню "Универсальный отчет"
  Перевірити відповідність заголовка звіту

Відкрити головне меню та знайти пункт меню "Учет изменений ПО"
  [Tags]  adjustment
  Натиснути на логотип IT-Enterprise
  Виконати пошук пункта меню  Учет изменений ПО
  Перейти до першого знайденого пункта меню

«Учет изменений ПО». "Коректировка"
  [Tags]  adjustment  non-critical
  Перейти до екрану "Коректировка"
  Натиснути "Требует действий со стороны службы поддержки"




*** Keywords ***
Preconditions
  ${login}  ${password}  Отримати дані проекту  ${env}
  Open Browser  ${url.${env}}  ${browser}
  Set Window Size  1280  1024


Postcondition
  Close All Browsers

Check Prev Test Status
  ${status}  Set Variable  ${PREV TEST STATUS}
  Run Keyword If  '${status}' == 'FAIL'  Fatal Error  Ой, щось пішло не так! Вимушена зупинка тесту.

Отримати дані проекту
  [Arguments]  ${env}
  ${login}=     get_env_variable  ${env}  login
  Set Global Variable  ${login}
  ${password}=  get_env_variable  ${env}  password
  Set Global Variable  ${password}
  [Return]  ${login}  ${password}

Відкрити сторінку ITA
  Go To  ${url.${env}}
  Run Keyword If  '${env}' == 'ITA'  Location Should Contain  /clientrmd/
  Run Keyword If  '${env}' == 'ITA_web2016'  Location Should Contain  /client/
  Run Keyword If  '${env}' == 'ITCopyUpgrade'  Set Global Variable  ${env}  ITA

Авторизуватися
  [Arguments]  ${login}  ${password}=None
  Run Keyword  Авторизуватися ${env}  ${login}  ${password}


Авторизуватися ITA
  [Arguments]  ${login}  ${password}=None
  Wait Until Page Contains  Вход в систему  60
  Вибрати користувача  ${login}
  Ввести пароль  ${password}
  Натиснути кнопку вхід
  Дочекатись загрузки сторінки (ita)
  Wait Until Element Is Visible  ${logo}

Авторизуватися ITA_web2016
  [Arguments]  ${login}  ${password}=None
  Wait Until Page Contains  Вход в систему  60
  Input Text  xpath=//*[@data-name="Login"]//input  ${login}
  Input Text  xpath=//*[@data-name="Password"]//input  ${password}
  Натиснути кнопку вхід
  Дочекатись загрузки сторінки (ita)
  Wait Until Element Is Visible  xpath=//*[@title='Новое окно']

Вибрати користувача
  [Arguments]  ${login}
  Input Text  ${login_field}  ${login}

Ввести пароль
  [Arguments]  ${password}
  Input Text  ${pass_field}  ${password}

Натиснути кнопку вхід
  Run Keyword  Натиснути кнопку вхід ${env}

Натиснути кнопку вхід ITA
  Click Element At Coordinates  xpath=(//*[contains(text(), 'Войти')])[2]  -40  0

Натиснути кнопку вхід ITA_web2016
  Click Element At Coordinates  xpath=(//*[contains(text(), 'Войти')])[1]  -40  0

Дочекатись загрузки сторінки (ita)
  ${status}  ${message}  Run Keyword And Ignore Error  Wait Until Element Is Visible  ${loading}  5
  Run Keyword If  "${status}" == "PASS"  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  120

Настиснути кнопку "Консоль"
  Click Element  ${console}
  Дочекатись Загрузки Сторінки (ita)
  Wait Until Page Contains  Консоль отладки

Перейти на вкладку
  [Arguments]  ${console_name}
  Run Keyword  Перейти на вкладку ${env}  ${console_name}

Перейти на вкладку ITA
  [Arguments]  ${console_name}
  Wait Until Keyword Succeeds  30  3  Click Element  xpath=//li/*[contains(text(), '${console_name}')]
  ${status}  Run Keyword And Return Status
  ...  Wait Until Element Is Visible  xpath=//li/*[contains(text(), '${console_name}')]/ancestor::*[@aria-selected="true"]
  Run Keyword If  '${status}' == 'False'  Перейти на вкладку  ${console_name}

Перейти на вкладку ITA_web2016
  [Arguments]  ${console_name}
  ${tab}  Set Variable  xpath=(//li//span[contains(text(), '${console_name}')])
  ${status}  Run Keyword And Return Status  Element Should Not Be Visible  ${tab}[2]
  Run Keyword If  '${status}' == 'True'  Click Element  ${tab}[1]
  ${status}  Run Keyword And Return Status
  ...  Wait Until Element Is Visible  xpath=//*[contains(@class,'activeTab')]//span[contains(text(),'${console_name}')]
  Run Keyword If  '${status}' == 'False'  Перейти на вкладку  ${console_name}

Ввести команду
  [Arguments]  ${command}
  Run Keyword  Ввести команду ${env}  ${command}

Ввести команду ITA

  [Arguments]  ${command}
  ${textarea}  Set Variable  //*[@aria-hidden='false']//textarea
  Input Text  ${textarea}  ${command}

Ввести команду ITA_web2016
  [Arguments]  ${command}
  ${textarea}  Set Variable  xpath=(//*[contains(@id,'DEBUGCONSOLE')]//textarea)[1]
  Wait Until Page Contains Element  ${textarea}
  ${count}  Get Element Count  ${textarea}
  Input Text  ${textarea}  ${command}

Натиснути кнопку "1 Выполнить"
  Run Keyword  Натиснути кнопку "1 Выполнить" ${env}

Натиснути Кнопку "1 Выполнить" ITA

  ${confirm btn}  Set Variable  //*[@aria-hidden="false"]//*[contains(text(), 'Выполнить')]
  Click Element At Coordinates  ${confirm btn}  -40  0

Натиснути кнопку "1 Выполнить" ITA_web2016
  Click Element At Coordinates  xpath=(//*[contains(text(), 'Выполнить')])[1]  -40  0

Перевірити виконання команди VFP
  Wait Until Element Is Visible  ${message-box}  30
  ${content}  Get Text  xpath=//*[@class="message-box-content-body"]
  Should Be Equal  ${content}  ?

Перевірити наявність кнопок "Да/Нет"
  Element Should Contain  xpath=//*[contains(@class, 'message-box-button')][1]  ДА
  Element Should Contain  xpath=//*[contains(@class, 'message-box-button')][2]  НЕТ

Натиснути кнопку "Да" для закриття діалогу
  Click Element  xpath=//*[contains(@class, 'message-box-button') and contains(text(), 'Да')]
  Element Should Not Be Visible  ${message-box}

Натиснути пункт меню "Инструменты и настройки"
  Wait Until Keyword Succeeds  30  3  Click Element  ${menu_tools}

Вибрати пункт меню "Универсальный отчет"
  Run Keyword If  'після виходу' not in "${TEST_NAME}"  Run Keyword
  ...  Wait Until Keyword Succeeds  10  2  Click Element At Coordinates  ${menu_scroll}  0  300
  Wait Until Keyword Succeeds  10  2  Click Element  ${menu_report}
  Wait Until Keyword Succeeds  30  3  Click Element  xpath=(//*[contains(text(), 'Универсальный отчет')])[2]
  Дочекатись загрузки сторінки (ita)
  Wait Until Page Contains Element  xpath=//*[contains(text(), 'Сформировать отчет')]  30

В полі регістр вибрати пункт
  [Arguments]  ${value}
  Click Element  xpath=(//*[contains(text(), 'Регистр')]/ancestor::div[2]//input)[1]
  Wait Until Keyword Succeeds  30  3  Click Element  xpath=(//*[contains(text(), 'Регистр')]/ancestor::div[2]//td[@code=0])[1]
  Wait Until Keyword Succeeds  30  3  Click Element  xpath=(//*[contains(text(),'${value}')])[1]

Вийти з функції "Универсальный отчет"
  Go Back
  Wait Until Page Does Not Contain Element  xpath=//*[contains(text(), 'Сформировать отчет')]

Натиснути випадаючий список кнопки "Конструктор"
  Wait Until Keyword Succeeds  30  3  Click Element  ${constructor_drop_down}
  Дочекатись Загрузки Сторінки (ita)
  ${stat}  Run Keyword And Return Status  Wait Until Element is Visible  ${create_report}  10
  Run Keyword If  '${stat}' == 'False'  Натиснути випадаючий список кнопки "Конструктор"

Натиснути пункт "Создать отчет"
  Click Element  ${create_report}
  Дочекатись Загрузки Сторінки (ita)
  Wait Until Element Is Visible  xpath=//div[contains(text(), 'Настройка отчета')]

Ввести довільну назву звіту
  ${text}  create_sentence  4
  Set Global Variable  ${text}
  Input Text  ${report_name}  ${text}

Перейти на вкладку "Поля"
  Click Element  xpath=//a[.='Поля']
  Wait Until Page Contains Element  xpath=//li[.='Поля' and @aria-selected="true"]
  Sleep  3

Вибрати три довільних поля
  ${left_count}  Get Matching Xpath Count  xpath=((//*[contains(@class, 'selectable')]/table)[1]//tr//span)
  :FOR  ${items}  IN RANGE  3
  \  ${random}  random_number  1  ${left_count}
  \  wait until keyword succeeds  10  3  Click Element  xpath=((//*[contains(@class, 'selectable')]/table)[1]//tr//span)[${random}]
  \  wait until keyword succeeds  10  3  Click Element At Coordinates  ${add_filter}  0  -30
  Sleep  2s
  ${right_count}  Get Matching Xpath Count  xpath=(//*[contains(@class, 'selectable')]/table)[2]//td[contains(@class,"cellmultiline")]
  Should Be Equal  3  ${right_count}

Натиснути кнопку "Добавить"
  Click Element  ${add_report}
  Дочекатись Загрузки Сторінки (ita)

Перевірити відповідність заголовка звіту
  ${report_title}  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Should Be Equal  ${text}  ${report_title}

Натиснути пункт "Удалить отчет"
  Wait Until Keyword Succeeds  30  3  Click Element  ${delete_report}
  Wait Until Keyword Succeeds  30  3  Click Element  xpath=//*[text()='Удалить']
  Дочекатись Загрузки Сторінки (ita)

Перевірити видалення звіту
  ${title}  Get Element Attribute  ${report_title}  value
  Should Not Be Equal  ${title}  ${text}
  Element Should Be Visible  ${toolbar}


Натиснути на логотип IT-Enterprise
  Click Element  ${logo}
  Wait Until Page Contains Element  xpath=//*[@class="start-menu-wrapper"]

Виконати пошук пункта меню
  [Arguments]  ${menu_name}
  Wait Until Element Is Visible  ${search}  30
  Input Text  ${search}  Администрирование системы → Администрирование системы и управление доступом → Планирование заданий → Учет изменений ПО
  Press Key  ${search}  ${enter btn}
  Wait Until Element Is Visible  xpath=(//*[contains(text(), '${menu_name}')])[1]

Перейти до першого знайденого пункта меню
  ${first_search_item}  Set Variable  xpath=(//*[@class="search-panel-text"]/ancestor::div[2]//*[@class="menu-item-text"])[last()]
  Wait Until Keyword Succeeds  30  3  Click Element  ${first_search_item}
  Дочекатись Загрузки Сторінки (ita)
  Wait Until Element Is Visible  xpath=//span[@title="Учет изменения ПО"]

Перейти до екрану "Коректировка"
  Click Element  ${F7}
  Wait Until Element Is Visible  xpath=//div[contains(text(), 'Добавление. Учет изменения ПО')]

Натиснути "Требует действий со стороны службы поддержки"
  Click Element  xpath=//*[@title="[NEEDACTIONS]"]
  Wait Until Element Is Visible  xpath=//*[contains(@title, '[OASU_ACTS]')]/preceding-sibling::*
  Run Keyword And Expect Error  *  Click Element  xpath=//*[@title="[NEEDACTIONS]"]

Перевірити наявність діалогу з таблицею
  Wait Until Element Is Visible  xpath=//table[contains(@class,'obj ')]  30

Активувати комірку для редагування
  ${row}  Set Variable  xpath=(//table[contains(@class,'obj ')]//td[text()])[3]
  Wait Until Keyword Succeeds  30  3  Click Element  ${row}
  Double Click Element  ${row}
  #TODO Press Key  ${row}  ${enter btn}
  Page Should Contain Element  xpath=(//table[contains(@class,'obj ')]//td[@class='cellselected editable'])

Вставити довільний текст до комірки
  ${text}  create_sentence  1
  Set Global Variable  ${row text}  ${text}
  ${row}  Set Variable  xpath=(//table[contains(@class,'obj ')]//td[@class='cellselected editable'])
  Input Text  ${row}//input  ${text}


Вибрати іншіу довільну комірку
  ${row}  Set Variable  xpath=(//table[contains(@class,'obj ')]//td[text()])[2]
  Click Element  ${row}
  ${text}  Get Text  ${row}
  Page Should Contain Element  xpath=//td[contains(@class,"cellselected" ) and text()='${text}']

Перевірити збереження тексту в комірці
  ${text}  Get Text  xpath=(//table[contains(@class,'obj ')]//td[text()])[3]
  Should Be Equal  ${text}  ${row text}

Стати на першу комірку та натиснути Enter
  ${row}  Set Variable  xpath=//*[@class='gridbox']//td[contains(@class,'cellselected')]
  Wait Until Keyword Succeeds  10  3  Click Element  ${row}
  ${status}  Run Keyword And Return Status  Page Should Contain Element  xpath=//*[@class='gridbox']//td[@class='cellselected editable']
  Run Keyword If  '${status}' == 'False'  Стати на першу комірку та натиснути Enter

Ввести значення
  [Arguments]  ${value}
  ${row}  Set Variable  xpath=//*[@class='gridbox']//td[@class='cellselected editable']//input[1]
  Input Text  ${row}  ${value}
  Press Key  ${row}  ${enter btn}

Перевірити наявність messagebox
  Wait Until Page Contains Element  ${message-box}
  Wait Until Keyword Succeeds  10  3  Click Element  xpath=//*[contains(@class, 'message')]//*[ text()='ОК']

Scroll Page To Element XPATH
  [Arguments]  ${xpath}
  Run Keyword And Ignore Error  Execute JavaScript  document.evaluate('${xpath.replace("xpath=", "")}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'auto', block: 'center', inline: 'center'});
  Run Keyword And Ignore Error  Execute JavaScript  document.evaluate("${xpath.replace('xpath=', '')}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'auto', block: 'center', inline: 'center'});
