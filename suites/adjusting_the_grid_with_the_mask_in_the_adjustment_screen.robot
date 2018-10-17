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


Відкрити "Консоль"
	Настиснути кнопку "Консоль"


"Консоль". Перейти на вкладку C#
	Перейти на вкладку  C#


"Консоль". C# Виконати коман
	Ввести команду  ${adjusting_the_grid_with_the_mask_in_the_adjustment_screen}
	Натиснути кнопку "1 Выполнить"


Перевірити виконання команди
	Перевірити наявність екрану коригування з полем undoc
	Перевірити значення в полях


Вибрати комірку для редагування
	Вибрати довільну комірку


Змінити значення комірки на 1000 та перевірити
	Змінити значення в комірці  1000
	Закрити валідаційне вікно  1000
	Отримати та порівняти значення поля  1000


Змінити значення комірки на 0 та перевірити
	Змінити значення в комірці  0
	Закрити валідаційне вікно  0
	Отримати та порівняти значення поля  0


*** Keywords ***
Перевірити наявність екрану коригування з полем undoc
	Wait Until Page Contains Element  //div[contains(@class, "active") and contains(., "undoc")]
	Set Global Variable  ${frame}  //div[contains(@class, "active") and contains(., "undoc")]


Перевірити значення в полях
	:FOR  ${i}  IN  1  2
	\  ${amount}  Get Text  (${frame}//td[contains(@style, "right")])[${i}]
	\  Should Be Equal  .00  ${amount[-3:]}


Вибрати довільну комірку
	${n}  Get Element Count  ${frame}//td[contains(@style, "right")]
	${grid}  random_number  1  ${n}
	Set Global Variable  ${grid}


Змінити значення в комірці
	[Arguments]  ${value}
	${field}  Set Variable  (${frame}//td[contains(@style, "right")])[${grid}]
	Click Element  ${field}
	Sleep  2
	Click Element  ${field}
	Sleep  2
	Click Element  ${field}
	Sleep  2
	Input Text  ${field}//input  ${value}
	Sleep  1
	Run Keyword And Ignore Error  Press Key  ${field}  \\13
	Click Element  ${field}


Закрити валідаційне вікно
	[Arguments]  ${value}
	${selector}  Set Variable  //div[@class="message-box" and contains(., "${value}")]
	Wait Until Page Contains Element  ${selector}
	Click Element  ${selector}//*[contains(text(), "ОК")]
	Sleep  1
	Run Keyword And Ignore Error  Click Element  ${selector}//*[contains(text(), "ОК")]
	Wait Until Page Does Not Contain Element  ${selector}


Отримати та порівняти значення поля
	[Arguments]  ${value}
	${should}  Run Keyword If  "${value}" == "1000"  Set Variable  1 000.00
	...  ELSE IF  "${value}" == "0"  Set Variable
	${get}  Get Text  (${frame}//td[contains(@style, "right")])[${grid}]
	Should Be Equal  ${should}  ${get}