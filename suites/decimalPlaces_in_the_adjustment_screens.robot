*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${dialog_window}  //div[contains(@class, "active")]//div[@class="float-container-header"]/..

*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
	Авторизуватися  ${login}  ${password}


Відкрити "Консоль"
	Настиснути кнопку "Консоль"


"Консоль". Перейти на вкладку C#
	Перейти на вкладку  C#


"Консоль". C# Виконати коман
	Ввести команду  ${decimalPlaces_in_the_adjustment_screens}
	Натиснути кнопку "1 Выполнить"


Перевірити виконання команди
	Sleep  5
	Перевірити наявність діалогового вікна
	Перевірити наявність двух input field


Змінити значення першого input field та перевірити результат
	Змінити значення першого input field
	Перевірити результат


*** Keywords ***
Перевірити наявність діалогового вікна
	Wait Until Page Contains Element  ${dialog_window}


Перевірити наявність двух input field
	${count}  Get Element Count  ${dialog_window}//input
	Should Be Equal  "2"  "${count}"


Перевірити значення першого поля
	${amount}  Get Element Attribute  ${dialog_window}//input  value
	${etalon}  Set Variable  1.00000
	Should Be Equal  ${etalon}  ${amount}


Змінити значення першого input field
	Input Text  ${dialog_window}//input  2.2
    Sleep  .5
    Click Element  xpath=(//*[@class="float-container-header"])[1]    #(${dialog_window}//input)[2]
    Sleep  .5


Перевірити результат
	${amount}  Get Element Attribute  ${dialog_window}//input  value
	${etalon}  Set Variable  2.20000
	Should Be Equal  ${etalon}  ${amount}
