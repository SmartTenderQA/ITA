*** Settings ***
Documentation    Suite description
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${registr text}          (//*[text()='Регистр']/../..//input)[1]
${button univ. report}   //*[@class="module-item-container" and @title="Универсальный отчет"]
${message}				 //*[@class="message-content-body" and contains (text(), 'Запись не найдена')]


*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
	Відкрити сторінку ITA
	Авторизуватися  ${login}  ${password}


Відкрити головне меню та знайти пункт меню "Универсальный отчет"
    Натиснути на логотип IT-Enterprise
    Натиснути пункт головного меню  Администрирование системы
 	Натиснути пункт головного меню  Администрирование системы и управление доступом
	Натиснути кнопку "Универсальный отчет"


Створити та ввести нову назву регістру
	Створити та ввести нову назву регістру


Перевірити поведінку системи на зміну назви Регістру
	Перевірити Назву Регістру
	Перевірити Наявність Messagebox
	Перевірити Зміну Кольору Поля "Регистр"


*** Keywords ***
Натиснути кнопку "Универсальный отчет"
    Wait Until Element Is Visible     ${button univ. report}
    Click Element					  ${button univ. report}


Створити та ввести нову назву регістру
	${text}  create_sentence  1
	Wait Until Page Contains Element  ${registr text}  timeout=10
    Set Global Variable  ${text}
    Input Text  ${registr text}  ${text}
	Press Key  ${registr text}  \\13
    Sleep  1


Перевірити Назву Регістру
	Wait Until Page Contains Element  ${registr text}
	${check}   Get Element Attribute  ${registr text}   value
	Should Be Equal  ${text}  ${check}


Перевірити Наявність Messagebox
	Element Should Be Visible  ${message}


Перевірити Зміну Кольору Поля "Регистр"
	${elem}  Get Webelement  ${registr text}
	${bg color}  Call Method  ${elem}  value_of_css_property  background-color
	Should Be Equal  ${bg color}  rgba(255, 230, 230, 1)
