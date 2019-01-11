*** Settings ***
Documentation
Metadata  Задача в PLD
...  586000
Metadata  Название теста
...  Маска в корректируемых ячейках Grid
Metadata  Заявитель
...  МЕЛЕНТЬЕВ
Metadata  Окружения
...  - chrome
...  - ff
...  - chrome-XP
Metadata  Идея теста
...  Валидационные проверки на вводимые значения двух полей
...
...  Первое поле принимает позитивные и негативные значения
...
...  Второе только позитивные
Metadata  Команда запуска
...  robot --consolecolors on -L TRACE:INFO -A suites/arguments.txt suites/mask_in_adjustable_grid_cells.robot

Resource  ../src/keywords.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${mask_in_adjustable_grid_cells}  		mask_in_adjustable_grid_cells
${result window}						(//*[@class='dhx_cell_wins']
${negative field}						//td)[8]
${positive field}						//td)[9]


*** Test Cases ***
Перевірити дані в полях
	${first_field value}  Отримати значення поля  negative
	${second_field value}  Отримати значення поля  positive
	Should Be Equal  ${first_field value}  ${300}
	Should Be Equal  ${second_field value}  ${200}


Ввести від'ємне число в перше поле
	${negative value}  Evaluate  random.randint(-999,-1)  random
	Ввести значення в поле  negative  ${negative value}
	${get value}  Отримати значення поля  negative
	Should Be Equal  ${get value}  ${negative value}


Ввести позитивне число в друге поле
	${positive value}  Evaluate  random.randint(1,999)  random
	Ввести значення в поле  positive  ${positive value}
	${get value}  Отримати значення поля  positive
	Should Be Equal  ${get value}  ${positive value}


Перевірити неможливість введення знака "-" в друге поле
	${negative value}  Evaluate  random.randint(-999,-1)  random
	Ввести значення в поле  positive  ${negative value}  ${False}
	${get value}  Отримати значення поля  positive
	${absolute value}  Evaluate  abs(${negative value})
	Should Be Equal  ${get value}  ${absolute value}


*** Keywords ***
Precondition
	Preconditions
	Відкрити сторінку ITA
	Авторизуватися  ${login}  ${password}
	Настиснути кнопку "Консоль"
	Перейти на вкладку  C#
	Ввод команды в консоль  ${mask_in_adjustable_grid_cells}
	Натиснути кнопку "1 Выполнить"



Отримати значення поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${result window}${${field} field}
	Зробити поле активним для редагування  ${selector}
	${value}  Get Element Attribute  ${selector}//input  value
	${value}  Evaluate  int(${value})
	[Return]  ${value}


Ввести значення в поле
	[Arguments]  ${field}  ${value}  ${with_check}=True
	${selector}  Set Variable  ${result window}${${field} field}
	Зробити поле активним для редагування  ${selector}
	Input Text  ${selector}//input  ${value}
	${get}  Отримати значення поля  ${field}
	Run Keyword If  ${with_check}	Перевірити введені дані  ${get}  ${value}
	Press Key  ${selector}//input  \\13


Перевірити введені дані
	[Arguments]  ${get}  ${value}
	${status}  Run Keyword And Return Status
	...  Should Be Equal  ${get}  ${value}
	Run Keyword If  ${status} != ${True}
	...  Ввести значення в поле  ${field}  ${value}


Зробити поле активним для редагування
	[Arguments]  ${selector}
	Click Element  ${selector}
	${status}  Run Keyword And Return Status
	...  Page Should Contain Element  ${selector}//input
	Run Keyword If  ${status} != ${True}
	...  Зробити поле активним для редагування  ${selector}
	Sleep  1
