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
${enter_key}							\\13


*** Test Cases ***
Перевірити дані в полях
	${first_field value}  Отримати значення поля  negative
	${second_field value}  Отримати значення поля  positive
	Should Be Equal  ${first_field value}  300.0000
	Should Be Equal  ${second_field value}  200.0000


Ввести від'ємне число в перше поле
	${negative value}  Evaluate  "%.4f" % float(random.randint(-999,-1))  random
	Ввести значення в поле  negative  ${negative value}
	${get value}  Отримати значення поля  negative
	Should Be Equal  ${get value}  ${negative value}


Ввести позитивне число в друге поле
	${positive value}  Evaluate  "%.4f" % float(random.randint(1,9999))  random
	Ввести значення в поле  positive  ${positive value}
	${get value}  Отримати значення поля  positive
	Should Be Equal  ${get value}  ${positive value}


Перевірити неможливість вводу знака "-" в друге поле
	Pass Execution  '${browser}' == 'edge'  Input for edge accept negative value, does not reproduced manually
	${negative value}  Evaluate  "%.4f" % float(random.randint(-9999,-1))  random
	Ввести значення в поле  positive  ${negative value}
	${get value}  Отримати значення поля  positive
	${expected value}  Evaluate  "%.4f" % float(abs(${negative value}))
	Should Be Equal  ${get value}  ${expected value}


Перевірити неможливість вводу ascii_uppercase, ascii_lowercase, punctuation для кожного поля
	:FOR  ${field}  IN  negative  positive
	\  ${string}  Evaluate  str(''.join(random.choice(string.ascii_uppercase + string.ascii_lowercase + string.punctuation) for _ in range(50)))  random, string
	\  Ввести значення в поле  ${field}  ${string}
	\  ${get value}  Отримати значення поля  ${field}
	\  ${get value}  Evaluate  "%.4f" % float(abs(${get value}))
	\  ${expected value}  Evaluate  "%.4f" % float(0)
	\  Should Be Equal  ${get value}  ${expected value}


Перевірити формат(xxxx.xxxx) значення для кожного поля
	:FOR  ${field}  IN  negative  positive
	\  ${long value}  Evaluate  random.randint(10000000,99999999)  random
	\  Ввести значення в поле  ${field}  '${long value}'
	\  ${get value}  Отримати значення поля  ${field}
	\  ${expected value}  Evaluate  float(${long value})/10000
	\  ${status}  Evaluate  ${get value} == ${expected value}
	\  Should Be True  ${status}


Перевірити максимальну довжину значення для кожного поля
	:FOR  ${field}  IN  negative  positive
	\  ${long value}  Evaluate  random.randint(100000000000,999999999999)  random
	\  Ввести значення в поле  ${field}  '${long value}'
	\  ${get value}  Отримати значення поля  ${field}
	\  ${expected value}  Evaluate  float(int(${long value})/10000)/10000
	\  ${status}  Evaluate  ${get value} == ${expected value}
	\  Should Be True  ${status}


Перевірити можливість вводу коротких чисел з крапкою для кожного поля
	:FOR  ${field}  IN  negative  positive
	\  ${short value}  Evaluate  str(random.randint(10, 99)) + '.' + str(random.randint(10, 99))  random
	\  Ввести значення в поле  ${field}  '${short value}
	\  ${get value}  Отримати значення поля  ${field}
	\  ${expected value}  Evaluate  "%.4f" % float(${short value})
	\  ${status}  Evaluate  ${get value} == ${expected value}
	\  Should Be True  ${status}


*** Keywords ***
Precondition
	Preconditions
	Авторизуватися  ${login}  ${password}
	Настиснути кнопку "Консоль"
	Перейти на вкладку  C#
	Ввод команды в консоль  ${mask_in_adjustable_grid_cells}
	Натиснути кнопку "1 Выполнить"


Отримати значення поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${result window}${${field} field}
	${get}  Get Text  ${selector}
	${value}  Evaluate  "%.4f" % float(${get})
	[Return]  ${value}


Ввести значення в поле
	[Arguments]  ${field}  ${value}
	${selector}  Set Variable  ${result window}${${field} field}
	Активувати поле  ${selector}
	Press Key  //html/body  ${enter_key}
	Run Keyword If  '${platform}' == 'XP' or '${browser}' == 'edge'
	...  Input Text  		${selector}//input  ${value}  ELSE
	...  Input Type Flex  	${selector}//input  ${value}
	Press Key  ${selector}//input  \\13


Активувати поле
	[Arguments]  ${selector}
	${class}  Get Element Attribute  ${selector}  class
	Run Keyword If  '${class}' != 'cellselected'
	...  Click Element  ${selector}