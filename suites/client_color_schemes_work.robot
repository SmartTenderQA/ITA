*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${user icon}                            //*[@help-id="USERICONWRAPPER"]
${user settings btn}                    //*[@id="RmdClientSettings"]/i
${color scheme tab}                     //div[@data-settings-type="1"]
${main color btn}                       //*[text()="Основной цвет"]/../following-sibling::div
${palette colors}                       //*[@class="color-palette"]//tr[1]/td
${client header}                        //*[@class="csw-header"]
${top toolbar}                          //*[@class="top-toolbar-wrapper"]


*** Test Cases ***
# команда запуску
# robot -L TRACE:INFO -A suites/arguments.txt -v browser:chrome -v platform:WIN10 -v hub:none suites/client_color_schemes_work.robot


Авторизуватися
  Авторизуватися  ${login}  ${password}


Перейти в налаштування користувача
  Розгорнути вікно браузера (для XP)
  Натиснути іконку з фото користувача
  Натиснути на кнопку налаштувань користувача


Змінити основний колір в налаштуваннях "Цветовые схемы"
  Визначити поточний основний колір
  Перейти на вкладку "Цветовые схемы"
  Змінити основний колір в налаштуваннях
  Закрити вікно налаштувань користувача
  Визначити новий основний колір

Перевірити що заголовок клієнта має новий колір
  Звірити що поточний колір відповідає новому


Запустить новый сеанс та перевірити що заголовок клієнта має новий колір
  Запустить новый сеанс ITA в новому браузері
  Звірити що поточний колір відповідає новому



*** Keywords ***
Розгорнути вікно браузера (для XP)
  Run Keyword If  '${browser}' != 'edge'  Maximize Browser Window


Натиснути іконку з фото користувача
  Wait Until Element Is Visible  ${user icon}
  Дочекатись Загрузки Сторінки (ita)
  Click Element  ${user icon}
  Wait Until Element Is Visible  ${user settings btn}


Натиснути на кнопку налаштувань користувача
  Wait Until Element Is Visible  ${user settings btn}
  Дочекатись Загрузки Сторінки (ita)
  Click Element  ${user settings btn}
  Wait Until Page Contains  Мои настройки  10


Визначити новий основний колір
  ${new color}  Визначити колір елемента  ${top toolbar}
  Set Global Variable  ${new color}


Визначити поточний основний колір
  ${present color}  Визначити колір елемента  ${top toolbar}
  Set Global Variable  ${present color}


Перейти на вкладку "Цветовые схемы"
  Wait Until Element Is Visible  ${color scheme tab}
  Дочекатись Загрузки Сторінки (ita)
  Click Element  ${color scheme tab}
  Wait Until Element Is Visible  //span[contains(text(),'Цвет')]


Змінити основний колір в налаштуваннях
  Capture Page Screenshot
  Дочекатись Загрузки Сторінки (ita)
  Click Element  ${main color btn}
  Wait Until Element Is Visible  ${palette colors}
  ${n}  Get Element Count  ${palette colors}
  :FOR  ${colors}  IN  RANGE ${n}
  \  ${random}  random_number  1  ${n}
  \  ${new color}  Визначити колір елемента  ${palette colors}\[${random}]
  \  Exit For Loop If  '${new color}' != '${present color}'
  Click Element  ${palette colors}\[${random}]
  Wait Until Element Is Not Visible  ${palette colors}
  Capture Page Screenshot


Визначити колір елемента
  [Arguments]  ${selector}
  ${elem}  Get Webelement  ${selector}
  ${elem color}  Call Method  ${elem}  value_of_css_property  background-color
  [Return]  ${elem color}


Звірити що поточний колір відповідає новому
  Визначити поточний основний колір
  Should Be Equal  ${present color}  ${new color}


Закрити вікно налаштувань користувача
  Wait Until Page Contains  Завершить
  Click Element  ${client header}//*[text()="Завершить"]
  Wait Until Element Is Visible  ${user icon}


Запустить новый сеанс ITA в новому браузері
  Postcondition
  Preconditions
  Авторизуватися  ${login}  ${password}