*** Settings ***
Documentation
Metadata  Задача в PLD
...  586465
Metadata  Название теста
...  Обработка клавиш полем ввода в экране, когда поверх него открыто другое окно.
Metadata  Заявитель
...  БЕСЕЛОВСЬК
Metadata  Окружения
...  - chrome
...  - ff
Metadata  Команда запуска
...  robot --consolecolors on -L TRACE:INFO -A suites/arguments.txt suites/handling_pressing_keys_with_an_input_field_on_the_screen.robot

Resource  ../src/keywords.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${message}			//*[@class='message-box-wrapper']
${text area}		//*[@class='CodeMirror-code']
${test command}		InfoManager.MessageBox("test");
${clear btn}		//*[@id='Clear']


*** Test Cases ***
Перевірити підсвітку тексту в лапках іншим кольором
	Ввод команды в консоль  handling_pressing_keys_with_an_input_field_on_the_screen
	${list}  Create List  rgba(170, 34, 34, 1)  rgb(170, 34, 34)
	${elem}    Get Webelement    ${text area}//*[@class='cm-string']
	${bg_color}    Call Method    ${elem}    value_of_css_property    color
	Should Contain Any  ${list}  ${bg_color}


Переконатися в відсутності фокусу в полі вводу
	Натиснути кнопку "1 Выполнить"
	${is focused}  Run Keyword And Return Status  Element Should Be Focused  ${text area}
	Should Be Equal  ${is focused}  ${False}  Oops! Фокус залишився в полі вводу команди


*** Keywords ***
Precondition
	Preconditions
	Відкрити сторінку ITA
	Авторизуватися  ${login}  ${password}
	Настиснути кнопку "Консоль"
	Перейти на вкладку  C#