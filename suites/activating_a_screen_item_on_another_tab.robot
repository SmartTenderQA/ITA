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
	Ввести команду  ${activating_a_screen}
	Натиснути кнопку "1 Выполнить"


Перевірити виконання команди
	Перевірити наявність діалогового вікна по title  Для UI теста. Не удалять.
	Перевірити кількість вкладок
	Вкладка повинна бути активна  Закладка1
	Перевірити наявність поля вводу
	Перевірити наявність кнопки


Натиснути "Кнопка1"
	Click Element  ${frame}${Button1}


Перевірити результат
	Вкладка повинна бути активна  Закладка2
	Run Keyword And Expect Error  *  Перевірити наявність кнопки


*** Keywords ***
Перевірити наявність діалогового вікна по title
	[Arguments]  ${title}
	Wait Until Page Contains Element  //div[contains(@class, "active") and contains(., "${title}")]
	Set Global Variable  ${frame}  //div[contains(@class, "active") and contains(., "${title}")]


Перевірити кількість вкладок
	${count}  Get Element Count  ${frame}//ul/li
	Should Be Equal  "2"  "${count}"


Перевірити наявність поля вводу
	Wait Until Page Contains Element  ${frame}//input


Перевірити наявність кнопки
	Wait Until Element Is Visible  ${frame}${Button1}


Вкладка повинна бути активна
	[Arguments]  ${title}
	Wait Until Page Contains Element  ${frame}//ul/li[contains(., "${title}") and contains(@class, "active")]
