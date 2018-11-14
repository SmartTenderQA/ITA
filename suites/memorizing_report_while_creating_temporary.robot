*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${button univ. report}   xpath=//*[@class="module-item-container" and @title="Универсальный отчет"]
${input report title}    //div[contains(@title, 'Введите наименование отчета')]/preceding-sibling::*//input
${input test report title}                //div[@help-id="REP_SMPLREPORTID"]//input[1]


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
	Ввести назву регістру  UI-Тестирование
	Натиснути кнопку "Мои настройки"
	Перейти до вкладки  Общие
	Ввести довільну назву звіту
	Натиснути кнопку "Сохранить"


Перевірити назву створеного звіту
	Натиснути кнопку "Назад"
	Натиснути на логотип IT-Enterprise
	Натиснути кнопку   Администрирование системы и управление доступом
	Виконати пошук пункта меню  Универсальный отчет
	Перевірити назву звіту


*** Keywords ***
Натиснути кнопку "Универсальный отчет"
    Wait Until Element Is Visible  ${button univ. report}
    Click Element                  ${button univ. report}


Натиснути кнопку "Мои настройки"
	Дочекатись Загрузки Сторінки (ita)
    Click Element  xpath=//*[@id="REP_SIMPLETEMP_SET"]
    Дочекатись Загрузки Сторінки (ita)


Створити та ввести назву звіту
	${text}  create_sentence  1
    Ввести назву регістру  ${text}
    Set Global Variable  ${saved_report}  ${text}


Натиснути кнопку "Сохранить"
    Click Element  xpath=//*[text()='Сохранить']
    Дочекатись Загрузки Сторінки (ita)


Натиснути кнопку "Назад"
    Go Back
    Дочекатись Загрузки Сторінки (ita)


Перевірити назву звіту
   Дочекатись Загрузки Сторінки (ita)
   Wait Until Page Contains Element  ${input test report title}
   ${check}  Get Element Attribute  ${input test report title}  value
   Should Not Be Equal  ${text}  ${check}


Натиснути кнопку
    [Arguments]  ${menu_name}
    Дочекатись Загрузки Сторінки (ita)
    ${selector}  Set Variable  xpath=//*[@class='menu-item-text' and contains(text(), '${menu_name}')]
    Click Element  ${selector}
