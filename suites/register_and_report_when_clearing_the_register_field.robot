*** Settings ***
Documentation    Suite description
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${registr text}          //*[contains(text(), 'Регистр')]/ancestor::div[@class="dhxform_base"]//input
${button univ. report}   //*[@class="module-item-container" and @title="Универсальный отчет"]



*** Test Cases ***
Авторизуватись
	Авторизуватися  ${login}  ${password}


Відкрити головне меню та знайти пункт меню "Универсальный отчет"
    Натиснути на логотип IT-Enterprise
    Натиснути пункт головного меню  Администрирование системы
 	Натиснути пункт головного меню  Администрирование системы и управление доступом
	Натиснути кнопку "Универсальный отчет"


В поле «Регистр» ввести UI-Тестирование та перевірити поле «Отчет».
	В полі регістр вибрати пункт  UI-Тестирование
	Перевірити що поле не пусте  ${report_title}


Очистити поле "Регистр" та перевести фокус на поле "Отчет"
	Очистити поле "Регистр"
	Натиснути "Tab"


Перевірити Що Поля "Регистр" та "Отчет" Не Порожні
	Перевірити що поле не пусте  ${registr text}
	Перевірити що поле не пусте  ${report_title}


*** Keywords ***
Натиснути кнопку "Универсальный отчет"
    Wait Until Element Is Visible  ${button univ. report}
    Click Element				   ${button univ. report}


Натиснути "Tab"
	Press Key  ${registr text}  \\9
	Дочекатись Загрузки Сторінки (ita)


Очистити поле "Регистр"
	Wait Until Element Is Visible  ${registr text}
	Sleep  1
	Click Element  ${registr text}
	Sleep  1
	Click Element  (//*[contains(text(), "Очистить")])[2]/..