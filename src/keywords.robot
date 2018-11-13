*** Settings ***
Library     Selenium2Library
Library     BuiltIn
Library     Collections
Library     DebugLibrary
Library     OperatingSystem
Library     Faker/faker.py
Library     service.py
Library     String


*** Variables ***
${browser}                            chrome
&{url}
...                                   ITA=https://webclient.it-enterprise.com/clientrmd/(S(nwqigpdz3z031icvawluswqc))/?win=1&ClientDevice=Desktop&isLandscape=true&tz=3
...                                   ITA_web2016=https://webclient.it-enterprise.com/client/(S(4rlzptork1sl10dr1uhr0vdi))/?win=1&tz=3
...                                   ITCopyUpgrade=https://m.it.ua/ITCopyUpgrade/CLIENTRMD/(S(iuhcsthigv3rjj1qattj3aby))/?proj=it_RU&win=1&ClientDevice=Desktop&isLandscape=true&tz=3
...                                   BUHETLA2=https://webclient.it-enterprise.com/client/(S(3fxdkqyoyyvaysv2iscf02h3))/?proj=K_BUHETLA2_RU&dbg=1&win=1&tz=3

${alies}                              alies
${hub}                                http://autotest.it.ua:4444/wd/hub
${platform}                           ANY
${capability}                         None

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
${dropdown unexisting command}        ${dropdown_unexisting_table}
${pulling from dropdown numerical1}    ${ade_pulling_from_dropdown_menu_numerical_first}
${pulling from dropdown numerical2}    ${ade_pulling_from_dropdown_menu_numerical_second}


*** Keywords ***
Preconditions
  ${login}  ${password}  Отримати дані проекту  ${env}
  Run Keyword If  '${capability}' == 'chrome'    Open Browser  ${url.${env}}  chrome   ${alies}  ${hub}  platformName:WIN10
  ...  ELSE IF    '${capability}' == 'chromeXP'  Open Browser  ${url.${env}}  chrome   ${alies}  ${hub}  platformName:XP
  ...  ELSE IF    '${capability}' == 'firefox'   Open Browser  ${url.${env}}  firefox  ${alies}  ${hub}
  ...  ELSE IF    '${capability}' == 'edge'      Open Browser  ${url.${env}}  edge     ${alies}  ${hub}
  Run Keyword If  '${capability}' != 'edge'      Set Window Size  1280  1024


Postcondition
  Close All Browsers


Check Prev Test Status
  ${status}  Set Variable  ${PREV TEST STATUS}
  Run Keyword If  '${status}' == 'FAIL'  Fatal Error  Ой, щось пішло не так! Вимушена зупинка тесту.


Очистити Кеш
  Execute Javascript    window.location.reload(true)


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
  Wait Until Element Is Visible  xpath=//*[@title="Вид"]  60


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
  Repeat Keyword  2 times  Ввести команду ${env}  ${command}


Ввести команду ITA
  [Arguments]  ${command}
  ${textarea}  Set Variable  //*[@aria-hidden='false']//textarea
  Clear Element Text  ${textarea}
  Sleep  .5
  Input Text  ${textarea}  ${command}
  Sleep  .5


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
  ${status}  Run Keyword And Return Status  Run Keyword And Ignore Error
  ...  Wait Until Element Is Not Visible  xpath=//*[@class="tooltip-panel" and @style="display: block;"]
  Sleep  3
  Run Keyword If  '${status}' == 'False'  Натиснути Кнопку "1 Выполнить" ITA


Натиснути кнопку "1 Выполнить" ITA_web2016
  Click Element At Coordinates  xpath=(//*[contains(text(), 'Выполнить')])[1]  -40  0


Перевірити виконання команди VFP
  Wait Until Element Is Visible  ${message-box}  30
  ${content}  Get Text  xpath=//*[@class="message-box-content-body"]
  Should Be Equal  ${content}  ?


Перевірити наявність кнопок "Да/Нет"
  ${yes}  Get Text  xpath=//*[contains(@class, 'message-box-button')][1]
  Should Contain Any  ${yes}  Да  ДА
  ${no}  Get Text  xpath=//*[contains(@class, 'message-box-button')][2]
  Should Contain Any  ${no}  Нет  НЕТ


Натиснути кнопку "Да" для закриття діалогу
  Click Element  xpath=//*[contains(@class, 'message-box-button') and contains(text(), 'Да')]
  Element Should Not Be Visible  ${message-box}


Натиснути пункт меню "Инструменты и настройки"
  Wait Until Keyword Succeeds  30  3  Click Element  ${menu_tools}
  Sleep  3


Вибрати пункт меню "Универсальный отчет"
  Click Element At Coordinates  ${menu_scroll}  0  300
  Wait Until Element Is Visible  ${menu_report}  30
  Click Element  ${menu_report}
  Wait Until Keyword Succeeds  30  3  Click Element  xpath=(//*[contains(text(), 'Универсальный отчет')])[2]
  Дочекатись загрузки сторінки (ita)
  Wait Until Page Contains Element  xpath=//*[contains(text(), 'Сформировать отчет')]  30


Вибрати пункт меню "Универсальный отчет" повторно
  Wait Until Keyword Succeeds  10  2  Click Element  xpath=(//*[contains(text(), 'Универсальный отчет')])[2]
  Wait Until Page Contains Element  xpath=//*[contains(text(), 'Сформировать отчет')]  30


В полі регістр вибрати пункт
  [Arguments]  ${value}
  ${register_input}  Set Variable  xpath=(//*[contains(text(), 'Регистр')]/ancestor::div[2]//input)[1]
  ${register_dropdown button}  Set Variable  (//*[@data-caption="+ Добавить"])[1]//*[@code='0']
  ${selector}  Set variable  (//*[contains(text(),'${value}')])[1]
  Дочекатись загрузки сторінки (ita)
  Wait Until Element Is Visible  ${register_input}  30
  Click Element  ${register_input}
  Wait Until Element Is Visible  ${register_dropdown button}  10
  Run Keyword And Ignore Error  Double Click Element  ${register_dropdown button}
  ${status}  Run Keyword And Return Status  Element Should Be Visible  ${selector}
  Run Keyword If  ${status} == ${False}  В полі регістр вибрати пункт  ${value}
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status2}  Run Keyword And Return Status  Перевірити що обрано пункт  ${value}
  Run Keyword If  ${status2} == ${False}  В полі регістр вибрати пункт  ${value}


Перевірити що обрано пункт
  [Arguments]  ${value}
  ${register} =  Get Element Attribute  (//*[contains(text(), 'Регистр')]/ancestor::div[2]//input)[1]    value
  Should Be Equal  '${register}'  '${value}'


Вийти з функції "Универсальный отчет"
  Go Back
  Wait Until Page Does Not Contain Element  xpath=//*[contains(text(), 'Сформировать отчет')]


Натиснути випадаючий список кнопки "Конструктор"
  ${deleted_report_title}  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Set Global Variable  ${deleted_report_title}
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
  :FOR  ${items}  IN RANGE  3
  \  ${random}  random_number  1  6
  \  wait until keyword succeeds  10  3  Click Element  xpath=((//*[contains(@class, 'selectable')]/table)[1]//tr//span)[${random}]
  \  wait until keyword succeeds  10  3  Click Element  (//div[@class="dhxform_btn"])[3]  #  0  -30  ${add_filter}
  Sleep  2s
  ${right_count}  Get Element Count  (//*[contains(@class, 'selectable')]/table)[2]//td[contains(@class,"cellmultiline")]
  Should Be True  ${right_count} == 3


Натиснути кнопку "Добавить"
  Click Element  ${add_report}
  Дочекатись Загрузки Сторінки (ita)


Перевірити відповідність заголовка звіту
  ${report_title}  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Should Be Equal  "${text}"  "${report_title}"


Натиснути пункт "Удалить отчет"
  Wait Until Keyword Succeeds  30  3  Click Element  ${delete_report}
  Wait Until Element Is Visible  xpath=//div[contains(text(), 'Настройка отчета')]  15
  ${current_title}  Get Element Attribute  //div[@help-id="REPZSMPLRN"]/input  value
  Should Be Equal  "${current_title}"  "${deleted_report_title}"
  Wait Until Keyword Succeeds  30  3  Click Element  xpath=//*[text()='Удалить']
  Дочекатись Загрузки Сторінки (ita)


Перевірити видалення звіту
  ${title}  Get Element Attribute  ${report_title}  value
  Should Not Be Equal  ${title}  ${text}
  Element Should Be Visible  ${toolbar}


Натиснути на логотип IT-Enterprise
  Click Element  ${logo}
  Wait Until Element Is Visible  xpath=//*[@class="start-menu-tree-view-container"]  20


Виконати пошук пункта меню
  [Arguments]  ${menu_name}
  #Wait Until Element Is Visible  xpath=//*[@start-menu-search-panel]  30
  Wait Until Keyword Succeeds  20  2  Input Text  ${search}  ${menu_name}
  Press Key  ${search}  ${enter btn}
  Sleep  1
  Run Keyword If  '${menu_name}' == 'Универсальный отчет'  Wait Until Keyword Succeeds  10  2  Run Keywords
  ...  Click Element  xpath=(//*[@class="search-panel-text"]/ancestor::div[2]//*[text()='Универсальный'])[2]
  ...  AND  Дочекатись Загрузки Сторінки (ita)


Запустити функцію додаткового меню
  [Arguments]  ${title}
  ${selector}  Set Variable  xpath=//*[contains(@class,'extended-menu')]//*[@title="${title}"]
  Wait Until Keyword Succeeds  20  2  Click Element  ${selector}
  Дочекатись Загрузки Сторінки (ita)
  Wait Until Element Is Not Visible  ${selector}


Натиснути пункт головного меню
  [Arguments]  ${title}
  ${selector}  Set Variable  xpath=//*[@title="${title}"]
  ${status}  Run Keyword And Return Status  Element Should Be Visible  ${selector}
  Run Keyword If  '${status}' == 'False'  Click Element At Coordinates  ${menu_scroll}  0  300
  Wait Until Keyword Succeeds  20  2  Click Element  ${selector}
  Wait Until Element Is Visible  xpath=//*[contains(@class,'selected') and @title="${title}"]
  Дочекатись загрузки сторінки (ita)



Перейти до першого знайденого пункта меню
  ${first_search_item}  Set Variable  xpath=((//*[@class="search-panel-text"]/ancestor::div[2]//div/*[text()='Универсальный'])[2]
  Wait Until Keyword Succeeds  10  2  Click Element  ${first_search_item}
  Дочекатись Загрузки Сторінки (ita)
  Wait Until Element Is Visible  xpath=//div[@class='frame-caption']//span[@title="Учет изменения ПО"]


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
  ${row}  Set Variable  //table[contains(@class,'obj')]//tr/td[2]
  ${n}  random_number  2  5
  Click Element  (${row})[${n}]
  Sleep  2
  Press Key  //html/body  \\13
  Sleep  2
  Page Should Contain Element  //td[@class='cellselected editable']
  [Return]  (${row})[${n}]


Вставити довільний текст до комірки
  [Arguments]  ${selector}
  ${text}  create_sentence  1
  Set Global Variable  ${row text}  ${text}
  ${input field}  Set Variable  ${selector}//input
  Input Type Flex  ${input field}  ${text}


Вибрати іншіу довільну комірку
  [Arguments]  ${selector}
  Double Click Element  ${selector}/../following-sibling::*
  Sleep  .5
  Press Key  //html/body  \\13
  ${text}  Get Text  ${selector}
  Page Should Contain Element  //td[text()="${text}"]


Перевірити збереження тексту в комірці
  [Arguments]  ${selector}
  ${text}  Get Text  ${selector}
  Should Be Equal  ${text}  ${row text}


Стати на першу комірку та натиснути Enter
  ${row}  Set Variable  xpath=//*[@class='gridbox']//td[contains(@class,'gridViewRowHeader')]
  Wait Until Keyword Succeeds  10  3  Click Element  ${row}
  Press Key  //body  \\13
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  xpath=//tr[contains(@class, "rowselected")]/td[contains(@class, "editable")]
  Run Keyword If  '${status}' == 'False'  Стати на першу комірку та натиснути Enter


Ввести значення
  [Arguments]  ${value}
  ${row}  Set Variable  xpath=//tr[contains(@class, "rowselected")]/td[contains(@class, "editable")]/input[1]
  Input Type Flex  ${row}  ${value}
  Press Key  ${row}  ${enter btn}


Перевірити наявність messagebox
  Wait Until Page Contains Element  ${message-box}
  Wait Until Keyword Succeeds  10  3  Click Element  xpath=//*[contains(@class, 'message')]//*[ text()='ОК']


Scroll Page To Element XPATH
  [Arguments]  ${xpath}
  Run Keyword And Ignore Error  Execute JavaScript  document.evaluate('${xpath.replace("xpath=", "")}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'auto', block: 'center', inline: 'center'});
  Run Keyword And Ignore Error  Execute JavaScript  document.evaluate("${xpath.replace('xpath=', '')}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'auto', block: 'center', inline: 'center'});


Запустити функцію
	[Arguments]  ${fuction}
	Click Element  //div[@id and @data-start-params and contains(., "${fuction}")]
	Дочекатись Загрузки Сторінки (ita)
	Wait Until Page Contains Element  //span[contains(@title, "${fuction}")]


Перевірити що поле не пусте
  [Arguments]  ${field}
  ${field value}  Get Element Attribute  ${field}  value
  Should Not Be Empty  ${field value}


Перевірити що поле пусте
  [Arguments]  ${field}
  ${field value}  Get Element Attribute  ${field}  value
  Should Be Empty  ${field value}


Очистити поле від тексту
  [Arguments]  ${field}
  Click Element  ${field}
  Sleep  .5
  Clear Element Text  ${field}
  Press Key  ${field}  \\9   #press tab
  ${field value}  Get Element Attribute  ${field}  value
  Should Be Empty  ${field value}


Ввести назву регістру
  [Arguments]  ${name}
  ${registr name input}  Set Variable  xpath=(//*[text()='Регистр']/../..//input)[1]
  Дочекатись Загрузки Сторінки (ita)
  Wait Until Page Contains Element  ${registr name input}  10
  Click Element  ${registr name input}
  Clear Element Text  ${registr name input}
  Sleep  .5
  Input Type Flex  ${registr name input}  ${name}
  Sleep  .5
  Press Key  ${registr name input}  \\09
  Дочекатись загрузки сторінки (ita)
  ${registr name}  Get Element Attribute  ${registr name input}  value
  ${check name}  Run Keyword And Return Status  Should Be Equal  ${registr name}  ${name}
  Run Keyword If  '${check name}' == 'False'  Ввести назву регістру  ${name}


Input Type Flex
  [Arguments]    ${locator}    ${text}
  [Documentation]    write text letter by letter
  ${items}    Get Length    ${text}
  : FOR    ${item}    IN RANGE    ${items}
  \    Press Key    ${locator}    ${text[${item}]}


Перевірити що назва звіту не порожня
  ${report_header}=  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Should Be True  "${report_header}"


Додати довільне поле
  ${random}  random_number  1  10
  ${value}  Get Text  xpath=((//*[contains(@class, 'selectable')]/table)[1]//tr//span)[${random}]
  Set Global Variable  ${added_field}  ${value}
  ${initial_count}  Get Element Count  ${right_table_elems}
  Wait Until Keyword Succeeds  10  3  Click Element  xpath=((//*[contains(@class, 'selectable')]/table)[1]//tr//span)[${random}]
  Wait Until Keyword Succeeds  10  3  Click Element  xpath=(//div[@class="dhxform_btn"])[3]  #  0  -30  ${add_filter}
  Wait Until Page Contains Element  xpath=(${right_table_elems})[${initial_count} + 1]
  ${added_table}  Get Text  xpath=(//*[contains(@class, 'selectable')]/table)[2]//td[contains(@class,"selected")]
  ${added_table}  Replace String  ${added_table}  \n  ${space}
  Should Be Equal  ${value}  ${added_table}


Запам'ятати послідовність доданих колонок
  ${columns_sequence}  Create List
  Set Global Variable  ${columns_sequence}
  ${right_count}  Get Element Count  ${right_table_elems}
  Set Global Variable  ${right_count}
  :FOR  ${items}  IN RANGE  ${right_count}
  \  ${added_column}  Get Text  xpath=(${right_table_elems})[${items} + 1]
  \  Append To List  ${columns_sequence}  ${added_column}


Обрати останній елемент правої таблиці
  Set Global Variable  ${right_table_elems}  (//*[contains(@class, "selectable")]/table)[2]//td[contains(@class,"cellmultiline")]
  Run Keyword And Ignore Error  Click Element  xpath=(${right_table_elems})[last()]
  Sleep  .5
  ${status}  Run Keyword And Return Status  Page Should Contain Element  xpath=(${right_table_elems})[last()]/parent::*[contains(@class, "rowselected")]
  Run Keyword If  '${status}' == 'False'  Обрати останній елемент правої таблиці