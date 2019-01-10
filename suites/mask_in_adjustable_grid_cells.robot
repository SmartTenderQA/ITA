*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${mask_in_adjustable_grid_cells}  		mask_in_adjustable_grid_cells
${result window}						(//*[@class='dhx_cell_wins']
${COUNT field}							//td)[8]
${ONLY_COUNT field}						//td)[9]


*** Test Cases ***
123
	Відкрити сторінку ITA
	Авторизуватися  ${login}  ${password}
	Настиснути кнопку "Консоль"
	Перейти на вкладку  C#
	Ввод команды в консоль  ${mask_in_adjustable_grid_cells}
	Натиснути кнопку "1 Выполнить"
	${COUNT value}  Отримати значення поля  COUNT
	${ONLY_COUNT value}  Отримати значення поля  ONLY_COUNT
	Should Be Equal  ${COUNT value}  ${300}
	Should Be Equal  ${ONLY_COUNT value}  ${200}
	${NEW COUNT value}  Evaluate  random.randint(-999,-1)  random
	Ввести значення в поле  COUNT  ${NEW COUNT value}
	${NEW ONLY_COUNT value}  Evaluate  random.randint(1,999)  random
	Ввести значення в поле  ONLY_COUNT  ${NEW ONLY_COUNT value}
	${COUNT value}  Отримати значення поля  COUNT
	${ONLY_COUNT value}  Отримати значення поля  ONLY_COUNT
	Should Be Equal  ${COUNT value}  ${NEW COUNT value}
	Should Be Equal  ${ONLY_COUNT value}  ${NEW ONLY_COUNT value}
	Ввести значення в поле  ONLY_COUNT  ${NEW COUNT value}  ${False}
	${get}  Отримати значення поля  ONLY_COUNT
	${abs}  Evaluate  abs(${NEW COUNT value})
	Should Be Equal  ${get}  ${abs}


*** Keywords ***
Отримати значення поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${result window}${${field} field}
	Зробити поле активним для редагування  ${selector}
	${value}  Get Element Attribute  ${selector}//input  value
	${value}  Evaluate  int(${value})
	[Return]  ${value}


Ввести значення в поле
	[Arguments]  ${field}  ${value}  ${with_check}=True
	${selector}  Set Variable  ${result window}${${field} field}
	Зробити поле активним для редагування  ${selector}
	Input Text  ${selector}//input  ${value}
	${get}  Отримати значення поля  ${field}
	Run Keyword If  ${with_check}	Перевірити введені дані  ${get}  ${value}
	Press Key  ${selector}//input  \\13


Перевірити введені дані
	[Arguments]  ${get}  ${value}
	${status}  Run Keyword And Return Status
	...  Should Be Equal  ${get}  ${value}
	Run Keyword If  ${status} != ${True}
	...  Ввести значення в поле  ${field}  ${value}


Зробити поле активним для редагування
	[Arguments]  ${selector}
	Click Element  ${selector}
	${status}  Run Keyword And Return Status
	...  Page Should Contain Element  ${selector}//input
	Run Keyword If  ${status} != ${True}
	...  Зробити поле активним для редагування  ${selector}