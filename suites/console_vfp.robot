*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Test Cases ***
Авторизуватись
	Авторизуватися  ${login}  ${password}


Відкрити "Консоль"
	Настиснути кнопку "Консоль"


Консоль. Перейти на вкладку VFP
	Перейти на вкладку  Vfp


Консоль. VFP Виконати команду
	Ввод команды в консоль  ${VFP command}
	Натиснути кнопку "1 Выполнить"
	Перевірити виконання команди VFP
	Перевірити наявність кнопок "Да/Нет"
	Натиснути кнопку "Да" для закриття діалогу
