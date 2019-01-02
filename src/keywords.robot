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
...                                   ITA=https://webclient.it-enterprise.com/clientrmd/(S(nwqigpdz3z031icvawluswqc))/?qa-mode=1&win=1&ClientDevice=Desktop&isLandscape=true&tz=3
...                                   ITA_web2016=https://webclient.it-enterprise.com/client/(S(4rlzptork1sl10dr1uhr0vdi))/?qa-mode=1&win=1&tz=3
...                                   ITCopyUpgrade=https://m.it.ua/ITCopyUpgrade/CLIENTRMD/(S(iuhcsthigv3rjj1qattj3aby))/?qa-mode=1&proj=it_RU&win=1&ClientDevice=Desktop&isLandscape=true&tz=3
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
${create_report}                      xpath=//div[@class="menu-item-text" and contains(text(), "Создать отчет")]
${delete_report}                      xpath=//div[@class="menu-item-text" and contains(text(), "Удалить отчет")]
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
${C# command}                         C# command
${VFP command}                        VFP command
${C# grid}                            C# grid                       # \x43\x23\x20\x67\x72\x69\x64
${dropdown unexisting command}        dropdown unexisting command
${pulling from dropdown numerical1}   pulling from dropdown numerical1
${pulling from dropdown numerical2}   pulling from dropdown numerical2
${dropdown letters}                   dropdown letters
${vfp checkbox}                       vfp checkbox
${VFP command}                        VFP command
${activating_validation_form}         activating_validation_form
${activating_a_screen}                activating_a_screen
${data_editor_call}                   data_editor_call
${edi_polling}                        edi_polling

${adjusting_the_grid_with_the_mask_in_the_adjustment_screen}  adjusting_the_grid_with_the_mask_in_the_adjustment_screen
${decimalPlaces_in_the_adjustment_screens}  decimalPlaces_in_the_adjustment_screens


*** Keywords ***
Preconditions
  ${login}  ${password}  Отримати дані проекту  ${env}
  Run Keyword If  '${capability}' == 'chrome'    Open Browser  ${url.${env}}  chrome   ${alies}  ${hub}  platformName:WIN10
  ...  ELSE IF    '${capability}' == 'chromeXP'  Open Browser  ${url.${env}}  chrome   ${alies}  ${hub}  platformName:XP
  ...  ELSE IF    '${capability}' == 'firefox'   Open Browser  ${url.${env}}  firefox  ${alies}  ${hub}
  ...  ELSE IF    '${capability}' == 'edge'      Open Browser  ${url.${env}}  edge     ${alies}  ${hub}
  #Run Keyword If  '${capability}' != 'edge'      Set Window Size  1280  1024


Postcondition
  Close All Browsers


Something Went Wrong
  Capture Page Screenshot
  Log Location
  Зберегти дані з логів


Зберегти дані з логів
  Run Keyword And Ignore Error  Unselect Frame
  ${logQA}  Execute JavaScript  return document.getElementById("requests-log-target").textContent;
  log  ${logQA}
  ${json}  convert dict to json  ${logQA}
  ${random}  Evaluate  random.randint(0, 999999)  modules=random
  Create File  ${OUTPUTDIR}/logQA_${random}.json  ${json}


convert dict to json
	[Arguments]  ${dict}
	${json}  evaluate  json.dumps(${dict})  json
	[Return]  ${json}


convert json to dict
	[Arguments]  ${json}
	${dict}  Evaluate  json.loads('''${json}''')  json
	[Return]  ${dict}


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
  Wait Until Element Is Visible  //div[@class="float-container-header-text" and text()="Вход в систему"]  60
  Вибрати користувача  ${login}
  Ввести пароль  ${password}
  Натиснути кнопку вхід
  Дочекатись загрузки сторінки (ita)
  Wait Until Page Contains Element  xpath=//*[@title="Вид"]  60
  Wait Until Element Is Visible  xpath=//*[@title="Вид"]  30


Авторизуватися ITA_web2016
  [Arguments]  ${login}  ${password}=None
  Wait Until Page Contains  Вход в систему  60
  #Input Text  xpath=//*[@data-name="Login"]//input  ${login}
  Sleep  1
  #${text}  Get Element Attribute  xpath=//*[@data-name="Login"]//input  value
  #${status}  Run Keyword And Return Status  Should Be Equal  ${text}  ${login}
  #Run Keyword If  ${status} == ${false}  Авторизуватися ITA_web2016  ${login}  ${password}
  Run Keyword If  "${capability}" == "edge"  Execute JavaScript   document.querySelector("[data-name=Login] input").value = ""
  Run Keyword If  "${capability}" != "edge"  Input Text  xpath=//*[@data-name="Login"]//input  ${login}  ELSE
#  ...  Execute JavaScript  document.querySelector("[data-name=Login] input").value = "${login}"
  ...  Input Login ITA_web2016  ${login}
  Run Keyword If  "${capability}" != "edge"  Input Text  xpath=//*[@data-name="Password"]//input  ${password}  ELSE
#  ...  Execute JavaScript  document.querySelector("[data-name=Password] input").value = "${password}"
  ...  Input password ITA_web2016  ${password}
  Run Keyword If  "${capability}" != "edge"  Натиснути кнопку вхід  ELSE
  ...  Execute JavaScript  document.querySelector("div.dxb").click()
  Дочекатись загрузки сторінки (ita)
  Wait Until Element Is Visible  xpath=//*[@title='Новое окно']  120

#  Execute JavaScript  document.querySelector("[data-name=Login] input").value = "${login}"
#  Execute JavaScript  document.querySelector("[data-name=Password] input").value = "${password}"
#  Execute JavaScript  document.querySelector("div.dxb").click()


Input Login ITA_web2016
  [Arguments]  ${login}
  ${a}  Get WebElement  css=[data-name="Login"] input
  Call Method    ${a}    send_keys  ${login}

Input password ITA_web2016
  [Arguments]  ${password}
  ${b}  Get WebElement  xpath=//*[@data-name="Password"]//input
  Call Method    ${b}    send_keys  ${password}

##  ${c}  Get WebElement  css=div.dxb
##  Call Method    ${c}  click
#  Execute JavaScript  document.querySelector("div.dxb").click()


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
  ${status}  Run Keyword And Return Status  Wait Until Element Is Not Visible  xpath=(//*[contains(text(), 'Войти')])[2]  120
  Run Keyword If  ${status} == ${false}  Run Keyword And Ignore Error  Натиснути кнопку вхід ITA


Натиснути кнопку вхід ITA_web2016
  Click Element At Coordinates  xpath=(//*[contains(text(), 'Войти')])[1]  -40  0


Дочекатись загрузки сторінки (ita)
  ${status}  ${message}  Run Keyword And Ignore Error  Wait Until Element Is Visible  ${loading}  5
  Run Keyword If  "${status}" == "PASS"  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  120


Настиснути кнопку "Консоль"
  Дочекатись Загрузки Сторінки (ita)
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
  Run Keyword  Очистити поле пошуку команд якщо необхідно ${env}
  Wait Until Keyword Succeeds  15  2  Input Text  (//input[contains(@class, "dxeEditAreaSys")])[${console_index}]  ${command}
  Press Key  (//input[contains(@class, "dxeEditAreaSys")])[${console_index}]  \\13
  Дочекатись Загрузки Сторінки (ita)


Очистити поле пошуку команд якщо необхідно ITA
  ${command_input}  Set Variable  (//input[contains(@class, "dxeEditAreaSys")])[${console_index}]
  ${clear_button}  Set Variable  //div[@id="Clear"]
  Click Element  ${command_input}
  Sleep  1
  ${text}  Get Element Attribute   ${command_input}  Value
  ${status}  Run Keyword And Return Status  Should Be Empty  ${text}
  Run Keyword If  ${status} == ${false}  Wait Until Element Is Visible  ${clear_button}
  Run Keyword If  ${status} == ${false}  Wait Until Keyword Succeeds  15  3  Click Element  ${clear_button}
  Sleep  1


Очистити поле пошуку команд якщо необхідно ITA_web2016
  ${command_input}  Set Variable  (//input[contains(@class, "dhxcombo_input dxeEditAreaSys")])
  Click Element  ${command_input}
  Sleep  1
  ${status}  Run Keyword And Return Status  Page Should Contain Element  //div[@data-caption="+ Добавить" and contains(@class , "actv")]
  Run Keyword If  ${status} == ${false}  Очистити поле пошуку команд якщо необхідно ITA_web2016
  ${text}  Get Element Attribute   ${command_input}  Value
  ${status1}  Run Keyword And Return Status  Should Be Empty  ${text}
  Run Keyword If  ${status1} == ${false}  Clear Element Text  ${command_input}


Ввести команду ITA_web2016
  [Arguments]  ${command}
  ${command_input}  Set Variable  (//input[@class="dhxcombo_input dxeEditAreaSys"])
  Run Keyword  Очистити поле пошуку команд якщо необхідно ${env}
  Wait Until Keyword Succeeds  15  3  Input Type Flex  ${command_input}  ${command}
  Sleep  .5
  Press Key  ${command_input}  \\13
  Sleep  1
  Run Keyword If  '${capability}' == 'edge'  Click Element  (//div[contains(@class, "dhxcombolist_multicolumn ")]//div[@class="dhxcombo_cell "])[2]


Натиснути кнопку "1 Выполнить"
  Run Keyword  Натиснути кнопку "1 Выполнить" ${env}



Натиснути Кнопку "1 Выполнить" ITA
  ${confirm btn}  Set Variable  //*[@aria-hidden="false"]//*[contains(text(), 'Выполнить')]
  Click Element At Coordinates  ${confirm btn}  -40  0
  Дочекатись загрузки сторінки (ita)
  ${status}  Run Keyword And Return Status  Run Keyword And Ignore Error
  ...  Wait Until Page Does Not Contain Element  xpath=//*[@class="tooltip-panel" and @style="display: block;"]
  Run Keyword If  '${status}' == 'False'  Натиснути Кнопку "1 Выполнить" ITA


Натиснути кнопку "1 Выполнить" ITA_web2016
  Sleep  5
  Визначити потрібну кнопку
  Press Button Execute
  Sleep  1
#  Click Element At Coordinates  xpath=(//*[contains(text(), 'Выполнить')])[1]  -40  0
#  ${status}  run keyword and return status  Wait Until Element Is Not Visible  (//div[@class="dxb" and contains(@id, "DEBUG")])[${button_index}]  10
#  Run Keyword If  ${status} == ${false}  Натиснути кнопку "1 Выполнить" ITA_web2016

Press Button Execute
  ${a}  Get WebElement  xpath=(//div[@class="dxb" and contains(@id, "DEBUG")])[${button_index}]
  Call Method    ${a}    click


Autistick Clicking
  :FOR  ${i}  IN RANGE  15
  \  Execute Javascript  document.querySelector("input[value='1 Выполнить']").click()
  \  Sleep  1

Визначити потрібну кнопку
  ${button}  Set Variable  (//div[@class="dxb" and contains(@id, "DEBUG")])
  :FOR  ${button_index}  IN RANGE  1  5
  \  ${text}  Get Text  ${button}[${button_index}]
  \  ${status}  run keyword and return status  Should Contain  ${text}  \u0412\u044b\u043f\u043e\u043b\u043d\u0438\u0442\u044c  #Выполнить
  \  Set Suite Variable  ${button_index}
  \  Exit For Loop If  ${status} == ${true}


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
  Дочекатись загрузки сторінки (ita)
  Wait Until Element Is Visible  ${register_input}  30
  Click Element  ${register_input}
  ${status}  Run Keyword And Return Status  Wait Until Element Is Visible  ${register_dropdown button}
  Run Keyword If  ${status} == ${False}  В полі регістр вибрати пункт  ${value}
  Розкрити випадаючий список та обрати пункт  ${value}
  ${status2}  Run Keyword And Return Status  Перевірити що обрано пункт  ${value}
  Run Keyword If  ${status2} == ${False}  В полі регістр вибрати пункт  ${value}


Розкрити випадаючий список та обрати пункт
  [Arguments]  ${value}
  ${register_dropdown button}  Set Variable  (//*[@data-caption="+ Добавить"])[1]//*[@code='0']
  ${selector}  Set variable  (//*[contains(text(),'${value}')])[1]
  Double Click Element  ${register_dropdown button}
  Sleep  1
  ${status}  Run Keyword And Return Status  Element Should Be Visible  //div[contains(@class, "dhxcombolist_multicolumn")]
  Run Keyword If  ${status} == ${False}  Розкрити випадаючий список та обрати пункт  ${value}
  Scroll To Element  div[class*=dhxcombo_cell_text_content]>span  ${value}



Scroll To Element
  [Arguments]  ${iterable_css}  ${target}
  ${counter}  Get Element Count  css=${iterable_css}
  ${dropdown_items}  Get WebElements  css=div[class*=dhxcombo_cell_text_content]>span
  :FOR  ${i}  IN RANGE  ${counter}
  \  ${text}  Execute JavaScript  let spans = document.querySelectorAll("${iterable_css}");  spans[${i}].scrollIntoView();  return spans[${i}].innerText;
  \  ${status}  Run Keyword And Return Status  Should Be Equal  ${text}  ${target}
  \  ${item}  Run Keyword If  ${status} == ${true}  Get From List  ${dropdown_items}  ${i}
  \  Run Keyword If  ${status} == ${true}  Call Method  ${item}  click
  \  Exit For Loop If  ${status} == ${True}


Перевірити що обрано пункт
  [Arguments]  ${value}
  ${register} =  Get Element Attribute  (//*[contains(text(), 'Регистр')]/ancestor::div[2]//input)[1]    value
  Capture Page Screenshot
  Should Be Equal  '${register}'  '${value}'


Вийти з функції "Универсальный отчет"
  Go Back
  Sleep  1
  Wait Until Element Is Not Visible  xpath=//*[contains(text(), 'Сформировать отчет')]


Натиснути випадаючий список кнопки "Конструктор"
  ${deleted_report_title}  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Set Global Variable  ${deleted_report_title}
  Wait Until Keyword Succeeds  30  3  Click Element  ${constructor_drop_down}
  Дочекатись Загрузки Сторінки (ita)
  ${stat}  Run Keyword And Return Status  Element Should Be Visible  ${create_report}
  Run Keyword If  '${stat}' == 'False'  Натиснути випадаючий список кнопки "Конструктор"


Натиснути пункт "Создать отчет"
  Click Element  ${create_report}
  Дочекатись Загрузки Сторінки (ita)
  Element Should Be Visible  //*[@class="float-container-header-text" and text()="Настройка отчета"]


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
  ${status}  Run Keyword And Return Status  Element Should Not Be Visible  ${add_report}
  Run Keyword If  ${status} == ${False}  Натиснути кнопку "Добавить"


Перевірити відповідність заголовка звіту
  ${report_title}  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Should Be Equal  "${text}"  "${report_title}"


Натиснути пункт "Удалить отчет"
  Wait Until Keyword Succeeds  30  3  Click Element  ${delete_report}
  Перейти до вкладки  Общие
  Wait Until Element Is Visible  xpath=//*[@class="float-container-header-text" and text()="Настройка отчета"]  15
  ${current_title}  Get Element Attribute  //div[@help-id="REPZSMPLRN"]/input  value
  Should Be Equal  "${current_title}"  "${deleted_report_title}"
  Wait Until Keyword Succeeds  30  3  Click Element  //*[@class = "dhxtoolbar_text" and text() = "Удалить"]
  Дочекатись Загрузки Сторінки (ita)


Перевірити видалення звіту
  ${title}  Get Element Attribute  ${report_title}  value
  Should Not Be Equal  ${title}  ${text}
  Element Should Be Visible  ${toolbar}


Натиснути на логотип IT-Enterprise
  Дочекатись Загрузки Сторінки (ita)
  Click Element  ${logo}
  Дочекатись Загрузки Сторінки (ita)
  Wait Until Element Is Visible  xpath=//*[@class="start-menu-tree-view-container"]  20


Виконати пошук пункта меню
  [Arguments]  ${menu_name}
  #Wait Until Element Is Visible  xpath=//*[@start-menu-search-panel]  30
  :FOR  ${i}  IN RANGE  10
  \  ${menu_name1}  Set Variable  ${menu_name}
  \  Input Text  ${search}  ${menu_name}
  \  Sleep  1
  \  ${text}  Get Element Attribute  ${search}  value
  \  ${text}  Run Keyword If  '${capability}' == 'edge'  Replace String  ${text}  \xa0  ${EMPTY}
  \  ${menu_name1}  Run Keyword If  '${capability}' == 'edge'  Replace String  ${menu_name}  ${SPACE}  ${EMPTY}
  \  ${status}  Run Keyword And Return Status  Should be Equal  ${text}  ${menu name1}
  \  Exit For Loop If  ${status} == ${true}
#  Wait Until Keyword Succeeds  20  2  Input Text  ${search}  ${menu_name}
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
  Wait Until Element Is Visible  xpath=(//div[@class="float-container-header-text" and text()="Добавление. Учет изменения ПО"])


Натиснути "Требует действий со стороны службы поддержки"
  Click Element  xpath=//*[@title="[NEEDACTIONS]"]
  Wait Until Element Is Visible  xpath=//*[contains(@title, '[OASU_ACTS]')]/preceding-sibling::*
  Run Keyword And Expect Error  *  Click Element  xpath=//*[@title="[NEEDACTIONS]"]


Перевірити наявність діалогу з таблицею
  Wait Until Element Is Visible  xpath=//table[contains(@class,'obj ')]  30


Активувати комірку для редагування
  ${row}  Set Variable  //table[contains(@class,'obj')]//tr/td[2]
  ${count}  Get Element Count  ${row}
  ${n}  random_number  1   ${count}
  Click Element  (${row})[${n}]
  Sleep  2
  Press Key  //html/body  \\13
  Дочекатись Загрузки Сторінки (ita)
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
  Дочекатись Загрузки Сторінки (ita)
  Run Keyword And Ignore Error  Click Element  xpath=(${selector}/../following-sibling::*/td)
  Sleep  .5
  ${text}  Get Text  ${selector}
  ${status}  Run Keyword And Return Status  Should Not Be Empty  ${text}
  Run Keyword If  ${status} == ${false}  Вибрати іншіу довільну комірку  ${selector}
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
	Дочекатись Загрузки Сторінки (ita)
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
  Дочекатись Загрузки Сторінки (ita)
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


Перейти до вкладки
  [Arguments]  ${value}
  ${selector}  Set variable  //a[contains(text(), '${value}')]
  Wait Until Element Is Visible  ${selector}  15
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${selector}/parent::*[contains(@class, "active")]
  Run Keyword If  ${status} == ${False}  Перейти До Вкладки  ${value}
  Дочекатись Загрузки Сторінки (ita)

#
#Input By Line
##  Ввод теста построчно
#  [Arguments]  ${input_field}  ${text}
#  ${lines_count}  Get Line Count  ${text}
#  Sleep  .5
#  Wait Until Keyword Succeeds  15  2  Click Element  ${input_field}
#  Clear Element Text  ${input_field}
#  :FOR  ${i}  IN RANGE  ${lines_count}
#  \  ${line}  Get Line  ${text}  ${i}
#  \  Input Type Flex  ${input_field}  ${line}
#  \  Sleep  .3
#  \  Press Key  ${input_field}  ${enter btn}
#  \  Sleep  .3


Ввод команды в консоль
  [Arguments]  ${command}
  Визначити індекс активної консолі
  Ввести команду  ${command}


Визначити індекс активної консолі
  :FOR  ${console_index}  in range  1  5
  \  ${status}  Run Keyword And Return Status
  ...  Element Should Be Visible  (//div[contains(@help-id, "DEBUGCONSOLECMD")])[${console_index}]
  \  Set Suite Variable  ${console_index}
  \  Exit For Loop If  ${status} == ${true}



Вибрати довільні поля з довідників
  [Arguments]  ${index}
  Визначити Індекс Активного Вікна
  Розкрити батьківське поле що має expander  ${index}
  Розкрити дочірній довідник з полями  ${index}
  Перевірити успішніть розгортання довідника полів  ${index}
  Додати довільне поле з довідника  ${index}
  Згорнути батьківське поле
#  Прокрутити список полів


Розкрити батьківське поле що має expander
  [Arguments]  ${i}
  Click Element  ${exp field}[${i}]
  Wait Until Page Contains Element  ${exp field}[${i}]/ancestor::tr/following-sibling::tr[1]//*[contains(text(),'right')]


Розкрити дочірній довідник з полями
  [Arguments]  ${i}
  ${i}  Evaluate  ${i} + 1
  Click Element  ${exp field}[${i}]
  Wait Until Page Contains Element  ${exp field}[${i}][contains(text(),'down')]


Перевірити успішніть розгортання довідника полів
  [Arguments]  ${i}
  ${i}  Evaluate  ${i} + 1
  Wait Until Element Is Visible  ${exp field}[${i}][contains(text(),'down')]/..//*[contains(text(),'Справочник')]
  ${status}  Run Keyword And Return Status  Wait Until Element Is Visible  xpath=(//*[contains(@class, 'selectable')]/table)[1]//tr//*[@style="padding-left:60px"][1]
  Run Keyword If  ${status} == ${false}  Wait Until Element Is Visible  xpath=(//*[contains(@class, 'selectable')]/table)[3]//tr//*[@style="padding-left:60px"][1]



Згорнути батьківське поле
  Sleep  .5
  Click Element  ${exp field}[contains(text(),'down')][1]
  Sleep  .5


Створити пустий список
  ${list}  Create List
  Set Global Variable  ${list}


Додати довільне поле з довідника
  [Arguments]  ${index}
  ${random}  random_number  1  4
  ${random}  Set Variable If  '${index}' == '3'  1  ${random}
  Click Element  ${dict field}[${random}]
  Wait Until Page Contains Element  ${dict field}[${random}]/ancestor::td[@class="cellselected"]
  ${fieldname}  Get Text  ${dict field}[${random}]
  Append To List  ${list}  ${fieldname}
  Wait Until Element Is Visible  ${add field btn}
  Wait Until Keyword Succeeds  15  3  Click Element  ${add field btn}
  Sleep  1
  ${added_table}  Get Text  xpath=(//td[@class="cellmultiline cellselected"])[last()]
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
