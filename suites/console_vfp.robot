*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
	Відкрити сторінку ITA
	Авторизуватися  ${login}  ${password}


Відкрити "Консоль"
	Настиснути кнопку "Консоль"


Консоль. Перейти на вкладку VFP
	Перейти на вкладку  Vfp


Консоль. VFP Виконати команду
	#Ввести команду  ${VFP command}
	Натиснути кнопку "1 Выполнить"
	Перевірити виконання команди VFP
	Перевірити наявність кнопок "Да/Нет"
	Натиснути кнопку "Да" для закриття діалогу
