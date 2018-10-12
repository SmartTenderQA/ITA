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
	Перевірити вибрану строку


Ввести дати у фільтр
	:FOR  ${i}  in  1  2
	\  Заповнити поле з датою  ${i}


Натиснути ctrl+Enter
	debug
	Press combination    key.ctrlleft    key.enter
    Press combination    key.alt    key.F4
    Type    key.right
	Press Key  //*[@class="dhxform_base"]//input  CONTROL  ENTER


*** Keywords ***
Перевірити вибрану строку
	${count}  Set Variable  count(//td[@draggable and contains(., "Код")]/preceding-sibling::td)
	${code grid}  Set Variable  //tr[contains(., "Диспетчер")]/td[${count}+1]
	${get}  Get Text  ${code grid}
	Should Be Equal  ${get}  ${EMPTY}


Заповнити поле з датою
	[Arguments]  ${i}
	${input}  Set Variable  (//*[@class="dhxform_base"]//input)[${i}]
	${date}  smart_get_time  -4  d
	Input Text  ${input}  ${date}
