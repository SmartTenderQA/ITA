*** Settings ***
Documentation
Metadata  Задача в PLD
...  586464
Metadata  Название теста
...  Динамическое изменение Message для элементов экрана.
Metadata  Заявитель
...  БЕСЕЛОВСЬК
Metadata  Окружения
...  - chrome
...  - ff
Metadata  Команда запуска
...  robot --consolecolors on -L TRACE:INFO -A suites/arguments.txt suites/dynamic_message_modification_for_screen_elements.robot

Resource  ../src/keywords.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${page}				//*[@help-id="_UI_MSG"]
${checkbox}			//*[@class="dhxform_img"]//i


*** Test Cases ***
Перевірити виконання команди
	Page Should Contain Element  ${page}${checkbox}
	Wait Until Keyword Succeeds  10  1
	...  tooltip-panel value should be equal  [VAR1]


Активувати чекбокс та перевірити результат
	Операція над чекбоксом  select
	Wait Until Keyword Succeeds  10  1
	...  tooltip-panel value should be equal  Checked [VAR1]


Зробити чекбокс не активнми та перевірити результат
	Операція над чекбоксом  unselect
	Wait Until Keyword Succeeds  10  1
	...  tooltip-panel value should be equal  Unchecked [VAR1]


*** Keywords ***
Precondition
	Preconditions
	Відкрити сторінку ITA
	Авторизуватися  ${login}  ${password}
	Настиснути кнопку "Консоль"
	Перейти на вкладку  C#
	Ввод команды в консоль  dynamic_message_modification_for_screen_elements
	Натиснути кнопку "1 Выполнить"


tooltip-panel value should be equal
	[Arguments]  ${text}
	${value}  get_tooltip-panel_value
	Should Be Equal  ${value}  ${text}


Операція над чекбоксом
	[Arguments]  ${action}
	Run Keyword If
	...  '${action}' == 'select'	Select Checkbox  	ELSE IF
	...  '${action}' == 'unselect'	UnSelect Checkbox


Select Checkbox
	${text}  Get Text  ${page}${checkbox}
	Run Keyword If  '${text}' != 'check_box'
	...  Click Element   ${page}${checkbox}


UnSelect Checkbox
	${text}  Get Text  ${page}${checkbox}
	Run Keyword If  '${text}' != 'check_box_outline_blank'
	...  Click Element   ${page}${checkbox}