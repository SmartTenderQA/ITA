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
${text area}		//textarea[@name]
${test command}		InfoManager.MessageBox("test");


*** Test Cases ***
Перевірити підсвітку тексту в лапках іншим кольором
	[Template]  Перевірити корректність роботи команди
	Купи слона или гараж																					#[а-Я]
	Buy an elephant																							#[a-Z]
	1234567890																								#[0-9]
	!@#$%^&*()_=`																							#[Спецсимволы] Экранировал двойные кавычки
	-																										#[len=1]
	wFNЁёhИz947LЭГuщюяг4dтШ9U794UЮ9!}ЭЦЁU*й^Г9Ш9Ю!дR,(чbЁ7=JЖ7=J}qd9#ыП;ю7Й=dvW9RULuЫ*W7чsяuzgмW]тLы~vLz	#[len=100]


Переконатися в відсутності фокусу в полі вводу
	Ввод команды в консоль  handling_pressing_keys_with_an_input_field_on_the_screen
	Click Element  ${text area}
	Натиснути кнопку "1 Выполнить"
	${is focused}  Run Keyword And Return Status  Element Should Be Focused  ${text area}
	Should Be Equal  ${is focused}  ${False}  Oops! Фокус залишився в полі вводу команди


*** Keywords ***
Precondition
	Preconditions
	Авторизуватися  ${login}  ${password}
	Настиснути кнопку "Консоль"
	Перейти на вкладку  C#
	Ввод команды в консоль  handling_pressing_keys_with_an_input_field_on_the_screen


Перевірити корректність роботи команди
	[Arguments]  ${text}
	Ввести текст в консоль  ${text}
	Перевірити підсвітку тексту в лапках іншим кольором
	Натиснути кнопку "1 Выполнить"
	Переконатися в коректності відображення повідомлення  ${text}
	Закрити повідомлення


Ввести текст в консоль
	[Arguments]  ${text}
	${command}  Set Variable  InfoManager.MessageBox("${text}");
	Очистити поле вводу
	Input Text  ${text area}  ${command}
	${is command}  Get Element Attribute  ${text area}  value
	Should Be Equal  ${command}  ${is command}  Oops! Введено текст ${is command} а ми вводили ${command}


Перевірити підсвітку тексту в лапках іншим кольором
	[Documentation]  Тестируемую возможность отключили и продолжать тестирование не нужно.
	No Operation


Переконатися в коректності відображення повідомлення
	[Arguments]  ${text}
	Wait Until Element Is Visible  ${message}
	Element Should Contain  ${message}  ${text}


Закрити повідомлення
	Click Element  ${message}//*[contains(text(),'ОК')]
	Wait Until Element Is Not Visible  ${message}


Очистити поле вводу
    Execute JavaScript
    ...  document.evaluate('${text area}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.value=""
	Sleep  .5
	${text}  Get Element Attribute  ${text area}  value
	Run Keyword If  ${text==''} == ${False}
	...	Очистити поле вводу
