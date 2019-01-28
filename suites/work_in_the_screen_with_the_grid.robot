*** Settings ***
Documentation
Metadata  Задача в PLD
...  585710
Metadata  Название теста
...  Работа в экране с гридом
Metadata  Заявитель
...  ТРОШИНА
Metadata  Окружения
...  - chrome
...  - ff
...  - chrome-XP
...  - edge
Metadata  Проекты
...  ITA
...  ITA_web2016
Metadata  Команда запуска
...  robot --consolecolors on -L TRACE:INFO -A suites/arguments.txt suites/work_in_the_screen_with_the_grid.robot

Resource  ../src/keywords.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
&{page_dict}
...					webrmd=//*[@class="dhxwin_active menuget"]
...					web2016=//*[@id="pcModalMode_PW-1"]
${grid}				//tr[contains(@class, "Row")]//td[2]
${dropdown list}	//*[@class="dhxcombolist_material" and contains(@style, "display: block;")]//*[@id="1" or @id="2" or @id="3"]


*** Test Cases ***
Додати комірку та вибрати значення з випадаючого списку
	:FOR  ${i}  IN RANGE  1  4
	\  Натиснути "Добавить"
	\  ${get}  Отримати значення з комірки  ${i}
	\  Should Be Equal  ${get}  ${EMPTY}
	\  Виділити комірку  ${i}
	\  Відкрити випадаючий список комірки  ${i}
	\  Вибрати елемент випадаючого списку за номером  ${i}
	\  ${get}  Отримати значення з комірки  ${i}
	\  Should Be Equal  '${get}'  '${i}'


*** Keywords ***
Precondition
	Preconditions
	Авторизуватися  ${login}  ${password}
	Настиснути кнопку "Консоль"
	Перейти на вкладку  C#
	Ввод команды в консоль  work_in_the_screen_with_the_grid
	Натиснути кнопку "1 Выполнить"
	${page}  Set Variable  ${page_dict.${ui}}
	Set Global Variable  ${page}


Натиснути "Добавить"
	${n}  Get Element Count  ${page}${grid}
	Click Element  ${page}//*[@title="Добавить"]
	Wait Until Keyword Succeeds  10  1  Count After  ${n}


Count After
	[Arguments]  ${n}
	${n after}  Get Element Count  ${page}${grid}
	${should}  Evaluate  ${n} + 1
	Should Be Equal  ${n after}  ${should}


Виділити комірку
	[Arguments]  ${number}
	${selector}  Set Variable  (${page}${grid})[${number}]
	${class value}  Get Element Attribute  ${selector}  class
	Run Keyword If  '${class value}' != 'cellselected'
	...  Click Element  ${selector}


Отримати значення з комірки
	[Arguments]  ${number}
	${selector}  Set Variable  (${page}${grid})[${number}]
	${value}  Get Text  ${selector}
	[Return]  ${value}


Відкрити випадаючий список комірки
	[Documentation]  при клике по выделенной ячейке открывается выпадающий список
	[Arguments]  ${number}
	${selector}  Set Variable  (${page}${grid})[${number}]
	${class value}  Get Element Attribute  ${selector}  class
	Run Keyword If
	...  '${class value}' == 'cellselected'
	...  Click Element  ${selector}  ELSE
	...  Run Keywords
	...  Виділити комірку  ${number}  AND
	...  Click Element  ${selector}
	Wait Until Page Contains Element  ${dropdown list}


Вибрати елемент випадаючого списку за номером
	[Arguments]  ${number}
	${selector}  Set Variable  (${dropdown list})[${number}]
	Click Element  ${selector}
	Wait Until Page Does Not Contain Element  ${selector}
