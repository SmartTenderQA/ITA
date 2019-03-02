*** Settings ***
Documentation  Проверяет что кнопка отбора сохраняет свое состояние после последнего открытия универсальнього отчета
Resource  ../src/keywords.robot
Suite Setup  Suite Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


#robot --consolecolors on -L TRACE:INFO -A suites/arguments.txt -v browser:chrome -v platform:WIN10 -v env:EMPO -v hub:none suites/universal_report_selection_bookmark_display.robot
*** Test Cases ***
Перевірити що вкладка відбору не активна
	[Tags]  universal_report_selection_tab
	universal_report.Статус кнопки відбір повинен бути  unselect


Перевірити що вкладка відбору активна
	[Tags]  universal_report_selection_tab
	[Setup]  ${TESTNAME} preconditions
	universal_report.Статус кнопки відбір повинен бути  select


*** Keywords ***
Suite Preconditions
	Preconditions
	Авторизуватися  ${login}  ${password}
	Натиснути на логотип IT-Enterprise
	main_menu.Виконати пошук пункта меню  Универсальный отчет
	Ввести назву регістру  UI-Тестирование
	Ввести назву звіту  UI-Тестирование (отчет с отбором)
	Дочекатись загрузки сторінки (ita)
	universal_report.Деактивувати кнопку відбір
	Натиснути кнопку "Esc"
	Перевірити що відкрито початкову сторінку ITA
	Натиснути на логотип IT-Enterprise
	main_menu.Виконати пошук пункта меню  Универсальный отчет
	Перевірити що обрано пункт  UI-Тестирование
	Перевірити заголовок звіту


Перевірити що вкладка відбору активна preconditions
	universal_report.Активувати кнопку відбір
	Натиснути кнопку "Esc"
	Перевірити що відкрито початкову сторінку ITA
	Натиснути на логотип IT-Enterprise
	main_menu.Виконати пошук пункта меню  Универсальный отчет
	Перевірити що обрано пункт  UI-Тестирование
	Перевірити заголовок звіту


Ввести назву звіту
	[Arguments]  ${name}
	Input Type Flex  ${report_title}  ${name}
	Sleep  .5
	Press Key  ${report_title}  \\09
	Дочекатись загрузки сторінки (ita)
	${report}  Get Element Attribute  ${report_title}  value
	${check_title}  Run Keyword And Return Status  Should Be Equal  ${report}  ${name}
	Run Keyword If  '${check_title}' == 'False'  Clear Element Text  ${report_title}
	Run Keyword If  '${check_title}' == 'False'  Ввести назву звіту  ${name}


Натиснути кнопку "Esc"
	Press Key   //html/body    \\27
	Дочекатись Загрузки Сторінки (ita)


Перевірити що відкрито початкову сторінку ITA
	Page Should Contain Element  (//*[@title="Вид"])[2]


Перевірити заголовок звіту
	${report_title}  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
	Should Be Equal  UI-Тестирование (отчет с отбором)  ${report_title}