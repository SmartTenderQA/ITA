*** Settings ***
Documentation    Suite description
Resource  ../src/keywords.robot

Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${registr text}          (//*[text()='Регистр']/../..//input)[1]
${button univ. report}   //*[@class="module-item-container" and @title="Универсальный отчет"]
${message}				 //*[@class="message-content-body" and contains (text(), 'Запись не найдена')]


*** Test Cases ***
Авторизуватись
	Авторизуватися  ${login}  ${password}


Відкрити головне меню та знайти пункт меню "Универсальный отчет"
    Натиснути на логотип IT-Enterprise
    Натиснути пункт головного меню  Администрирование системы
 	Натиснути пункт головного меню  Администрирование системы и управление доступом
	Натиснути кнопку "Универсальный отчет"


В поле «Регистр» ввести UI-Тестирование та перевірити поле «Отчет».
	В поле «Регистр» ввести  UI-Тестирование
	Перевірити що поле не пусте  ${report_title}
    Запам'ятати назву звіту


Створити та ввести нову назву регістру
	Створити та ввести нову назву регістру
	Run Keyword If  '${browser}' == 'edge'  Edge magic


Перевірити поведінку системи на зміну назви Регістру
	Перевірити Назву Регістру
	Перевірити поле "Отчет"
	Перевірити Наявність Messagebox
	Перевірити Зміну Кольору Поля "Регистр"


*** Keywords ***
Edge magic
    Click Element  (//*[text()='Регистр']/../..//input)[1]
    Sleep  1
    Click Element  ${report_title}
    Sleep  1


Натиснути кнопку "Универсальный отчет"
    Wait Until Element Is Visible  ${button univ. report}
    Click Element				   ${button univ. report}


В поле «Регистр» ввести
	[Arguments]  ${name}
	Wait Until Page Contains Element  ${registr text}  timeout=15
    Ввести назву регістру  ${name}


Створити та ввести нову назву регістру
	${text}  create_sentence  1
	Wait Until Page Contains Element  ${registr text}  timeout=15
    Set Global Variable  ${text}
    Ввести назву регістру  ${text}


Перевірити Назву Регістру
	Wait Until Page Contains Element  ${registr text}
	${check}  Get Element Attribute  ${registr text}   value
	Should Be Equal  ${text}  ${check}


Перевірити поле "Отчет"
	${value}  Get Element Attribute  ${report_title}   value
	Should Be Equal  ${report_title_value}  ${value}


Перевірити Наявність Messagebox
	Element Should Be Visible  ${message}


Перевірити Зміну Кольору Поля "Регистр"
	${list}  Create List  rgba(255, 230, 230, 1)  rgb(255, 230, 230)
	Click Element At Coordinates  ${registr text}  0  10
	${elem}  Get Webelement  ${registr text}
	${bg color}  Call Method  ${elem}  value_of_css_property  background-color
	Should Contain Any  ${list}  ${bg color}


Запам'ятати назву звіту
    ${report_title_value}  Get Element Attribute  ${report_title}  value
	Set Global Variable  ${report_title_value}