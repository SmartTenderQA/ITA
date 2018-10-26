*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${Button1}  //div[@role="link"]


*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
	Авторизуватися  ${login}  ${password}


Запуск функції «Планировщик задач»
	Запустити функцію  Планировщик задач
	debug
	Перевірити вибрану строку
	Виділити екран "Условие"



Ввести дати у фільтр
	:FOR  ${i}  in  1  2
	\  Заповнити поле з датою  ${i}


Натиснути ctrl+Enter
	Send Ctrl Enter To Current Element


Перевірити дату в колонці "Начало" екрану "Планировщик задач"
	${list}  Отримати всі дати
	Перевірити всі дати  ${list}


*** Keywords ***
Перевірити вибрану строку
	${count}  Set Variable  count(//td[@draggable and contains(., "Код")]/preceding-sibling::td)
	${code grid}  Set Variable  //tr[contains(., "Диспетчер")]/td[${count}+1]
	${get}  Get Text  ${code grid}
	Should Be Equal  ${get}  ${EMPTY}


Виділити екран "Условие"
	Click Element  (//*[@data-guid-id and contains(., "Установить")])[last()]
	Sleep  1
	Click Element  (//*[@data-guid-id and contains(., "Установить")])[last()]


Виділити екран "Планировщик задач"
	Click Element  (//*[@data-guid-id and contains(., "Планировщик задач")])[last()]
	Sleep  2
	Click Element  (//*[@data-guid-id and contains(., "Планировщик задач")])[last()]


Заповнити поле з датою
	[Arguments]  ${i}
	${input}  Set Variable  (//*[@class="dhxform_base"]//input)[${i}]
	${date}  smart_get_time  -4  d
	Input Text  ${input}  ${date}
	Set Global Variable  ${date}


Send Ctrl Enter To Current Element
    ${keys}=    Evaluate    selenium.webdriver.common.keys.Keys    selenium
    ${s2l}=    Get Library Instance    Selenium2Library
    ${actionchain module}=    Evaluate    selenium.webdriver.common.action_chains    selenium
    ${action chain}=    Call Method    ${actionchain module}    ActionChains    ${s2l._current_browser()}
    Call Method    ${action chain}    key_down    ${keys.CONTROL}
    Call Method    ${action chain}    send_keys    ${keys.ENTER}
    Call Method    ${action chain}    key_up    ${keys.CONTROL}
    Call Method    ${action chain}    perform


Send PAGE_UPx40 To Current Element
    ${keys}=    Evaluate    selenium.webdriver.common.keys.Keys    selenium
    ${s2l}=    Get Library Instance    Selenium2Library
    ${actionchain module}=    Evaluate    selenium.webdriver.common.action_chains    selenium
    ${action chain}=    Call Method    ${actionchain module}    ActionChains    ${s2l._current_browser()}
    Repeat Keyword  40  Call Method    ${action chain}    key_down    ${keys.PAGE_UP}
    Call Method    ${action chain}    perform


Отримати всі дати
	Sleep  5
	Виділити екран "Планировщик задач"
	${list}  Create List
	${frame}  Set Variable  (//*[@data-guid-id and contains(., "Планировщик задач")])[last()]
	${date element}  Set Variable  //div[@data-ps-id]//tr[@class]/td[1]
	${n}  Get Element Count  ${frame}${date element}
	${last}  Get Text  xpath=(${frame}${date element})[${n}]
	Send PAGE_UPx40 To Current Element
	${first}  Get Text  xpath=(${frame}${date element})[1]
	Append To List  ${list}  ${last}
	Append To List  ${list}  ${first}
	[Return]  ${list}


Перевірити всі дати
	[Arguments]  ${list}
	:FOR  ${i}  IN  @{list}
	\	Should Contain  ${i}  ${date}
