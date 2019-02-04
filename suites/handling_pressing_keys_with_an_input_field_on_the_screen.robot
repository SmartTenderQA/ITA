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


*** Keywords ***
Precondition
	Preconditions
	Авторизуватися  ${login}  ${password}
	Настиснути кнопку "Консоль"
	Перейти на вкладку  C#
	Визначити індекс активної консолі


Перевірити корректність роботи команди
	[Arguments]  ${text}
	${command}  Set Variable  InfoManager.MessageBox("${text}");
	Ввести команду  ${command}
	Перевірити підсвітку тексту в лапках іншим кольором
	Натиснути кнопку "1 Выполнить"
	Переконатися в коректності відображення повідомлення  ${text}
	${is focused}  Run Keyword And Return Status  Element Should Be Focused  ${text area}
	Закрити повідомлення
	Should Be Equal  ${is focused}  ${False}  Oops! Фокус залишився в полі вводу команди


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