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
${registr text}          xpath=(//*[text()='Регистр']/../..//input)[1]
${button univ. report}   xpath=//*[@class="module-item-container" and @title="Универсальный отчет"]


*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
	Відкрити сторінку ITA
	Авторизуватися  ${login}  ${password}


Запустити функцію 'Универсальный отчет'
	Натиснути на логотип IT-Enterprise
	Натиснути пункт головного меню   Администрирование системы
	Натиснути пункт головного меню   Администрирование системы и управление доступом
	Натиснути кнопку "Универсальный отчет"


Створити новий універсальний звіт
	Ввести назву регістру  Любой текст 90

Перевірити поведінку системи на зміну назви Регістру
	Перевірити Назву Регістру
	Перевірити Наявність Messagebox

*** Keywords ***
Натиснути кнопку "Универсальный отчет"
    Wait Until Element Is Visible     ${button univ. report}
    Click Element                     ${button univ. report}


Ввести назву регістру
	[Arguments]  ${name}
	Wait Until Page Contains Element   ${registr text}    timeout=10
	Input Text    ${registr text}  ${name}
    Press Key  ${registr text}    \\13
    Sleep  1

Перевірити Назву Регістру
	Wait Until Page Contains Element    ${registr text}
	${check}   Get Element Attribute    ${registr text}   value
	Should Be Equal     ${saved_report}  ${check}

Перевірити Наявність Messagebox
	Wait Until Page Contains Element  ${message-box}
	Wait Until Keyword Succeeds  10  3  Click Element  //*[@class="message-content-body" and contains(text="Запись не найдена")]