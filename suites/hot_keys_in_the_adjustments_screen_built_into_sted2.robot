*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${Button1}  //div[@role="link"]

#  robot -L TRACE:INFO -A suites/arguments.txt -v capability:chrome -v env:ITA -v hub:None suites/hot_keys_in_the_adjustments_screen_built_into_sted2.robot
*** Test Cases ***
Авторизуватись
	Авторизуватися  ${login}  ${password}


Запуск функції «Планировщик задач»
	Натиснути на логотип IT-Enterprise
	Натиснути пункт головного меню   Администрирование системы
	Натиснути пункт головного меню   Администрирование системы и управление доступом
	Відкрити Функцію  Планировщик задач
	Виділити екран "Условие"



Ввести дати у фільтр
	:FOR  ${i}  in  1  2
	\  Заповнити поле з датою  ${i}


Натиснути ctrl+Enter
	Send Ctrl Enter To Current Element
	Дочекатись Загрузки Сторінки (ita)


Перевірити дату в колонці "Начало" екрану "Планировщик задач"
	${list}  Отримати всі дати
	Перевірити всі дати  ${list}


*** Keywords ***
Відкрити Функцію
    [Arguments]  ${function}
    Wait Until Keyword Succeeds  15  3  Click Element  //div[@class="module-item-text" and text()="${function}"]
    Дочекатись Загрузки Сторінки


Перевірити вибрану строку
	${count}  Set Variable  count(//td[@draggable and contains(., "Код")]/preceding-sibling::td)
	${code grid}  Set Variable  //tr[contains(., "Диспетчер")]/td[${count}+1]
	${get}  Get Text  ${code grid}
	Should Be Equal  ${get}  ${EMPTY}


Виділити екран "Условие"
    Дочекатись Загрузки Сторінки (ita)
	Click Element  (//*[@data-guid-id and contains(., "Установить")])[last()]
	Sleep  1
	Click Element  (//*[@data-guid-id and contains(., "Установить")])[last()]


Виділити екран "Планировщик задач"
    Дочекатись Загрузки Сторінки (ita)
	Click Element  (//*[@data-guid-id and contains(., "Планировщик задач")])[last()]
	Sleep  2
	Click Element  (//*[@data-guid-id and contains(., "Планировщик задач")])[last()]
	Дочекатись Загрузки Сторінки (ita)


Заповнити поле з датою
	[Arguments]  ${i}
	${input}  Set Variable  (//*[@class="dhxform_base"]//input)[${i}]
	${date}  smart_get_time  -4  d
	Click Element At Coordinates  ${input}  -10  0
	Clear Element Text  ${input}
	Input Type Flex  ${input}  ${date}
	Set Global Variable  ${date}
	${text}  Get Element Attribute  ${input}  value
	Sleep  2
	${status}  Run Keyword And Return Status  Should Be Equal  ${text}  ${date}
	Run Keyword If  ${status} == ${false}  Заповнити поле з датою  ${i}



Send Ctrl Enter To Current Element
    ${keys}=    Evaluate    selenium.webdriver.common.keys.Keys    selenium
    ${s2l}=    Get Library Instance    Selenium2Library
    ${actionchain module}=    Evaluate    selenium.webdriver.common.action_chains    selenium
    ${action chain}=    Call Method    ${actionchain module}    ActionChains    ${s2l._current_browser()}
    Call Method    ${action chain}    key_down    ${keys.CONTROL}
    Call Method    ${action chain}    send_keys    ${keys.ENTER}
    Call Method    ${action chain}    key_up    ${keys.CONTROL}
    Call Method    ${action chain}    perform


Send PAGE_UPx2 To Current Element
    ${keys}=    Evaluate    selenium.webdriver.common.keys.Keys    selenium
    ${s2l}=    Get Library Instance    Selenium2Library
    ${actionchain module}=    Evaluate    selenium.webdriver.common.action_chains    selenium
    ${action chain}=    Call Method    ${actionchain module}    ActionChains    ${s2l._current_browser()}
    Repeat Keyword  2  Call Method    ${action chain}    key_down    ${keys.PAGE_UP}
    Call Method    ${action chain}    perform


Отримати всі дати
	Виділити екран "Планировщик задач"
	${list}  Create List
	${frame}  Set Variable  (//*[@data-guid-id and contains(., "Планировщик задач")])[last()]
	${date element}  Set Variable  //div[contains(@class, "scrollable")]//tr[@class]/td[1]
	${n}  Get Element Count  ${frame}${date element}
	${last}  Get Text  xpath=(${frame}${date element})[${n}]
	${status}  Run Keyword And Return Status  Should Not Be Empty  ${last}
	Run Keyword If  ${status} == ${false}  Отримати всі дати
	:FOR  ${items}  IN RANGE  40
	\  Send PAGE_UPx2 To Current Element
	Дочекатись Загрузки Сторінки (ita)
	${status}  Run Keyword And Return Status  Element Should Be Visible  //*[contains(text(), "История")]/following::tr[contains(@class, "Row")][1]
	Run Keyword If  ${status} == "False"  Send PAGE_UPx40 To Current Element
	${first}  Get Text  xpath=(${frame}${date element})[1]
	Append To List  ${list}  ${last}
	Append To List  ${list}  ${first}
	[Return]  ${list}


Перевірити всі дати
	[Arguments]  ${list}
	:FOR  ${i}  IN  @{list}
	\	Should Contain  ${i}  ${date}
