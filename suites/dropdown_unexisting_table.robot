*** Settings ***
Resource     ../src/keywords.robot

Suite Setup  		Test Preconditions
Suite Teardown  	Postcondition
Test Setup  		Check Prev Test Status
Test Teardown  		Run Keyword If Test Failed  Something Went Wrong


*** Test Cases ***
Перевірити виконання команди
	Перевірити що назва нового вікна  Несуществующая таблица


Спробувати відкрити випадаючий список(negative)
	Відкрити випадаючий список
	Перевірити що дропдаун порожній


Відкрити пошук(negative)
	Натиснути кнопку пошуку
	Перевірити зміну кольору поля пошуку


Закрити вікно
	Натиснути кнопку "ОК"
	Wait Until Page Contains  Консоль отладки


*** Keywords ***
Test Preconditions
	Preconditions
	Авторизуватися  ${login}  ${password}
	Настиснути кнопку "Консоль"
	Перейти на вкладку  C#
	Ввод команды в консоль  ${dropdown unexisting command}
	Натиснути кнопку "1 Выполнить"


Перевірити що назва нового вікна
  [Arguments]  ${title}
  ${selector}  Set Variable  //*[contains(@class, "dhxform_txt_label2")]
  Wait Until Element Is Visible  ${selector}
  ${text}  Get Text  ${selector}
  ${text}  Run Keyword If  '${browser}' == 'edge'  Replace String  ${text}  \xa0  ${EMPTY}
  ${title}  Run Keyword If  '${browser}' == 'edge'  Replace String  ${title}  ${SPACE}  ${EMPTY}
  Should Be Equal  ${text}  ${title}


Перевірити що дропдаун порожній
  ${text}   Get Element Attribute  //input[contains(@class, "dxeEditAreaSys")]  value
  Should Be Empty  ${text}


Відкрити випадаючий список
  Активувати вікно якщо потрібно
  Run Keyword If  '${browser}' == 'edge'  Click Element at coordinates  //*[contains(@class, "fixed-invisible-ade-buttons")]  0  0
  ...  ELSE  Click Element  //*[contains(@class, "fixed-invisible-ade-buttons")]
  Element Should Not Be Visible  //*[contains(@style, "display: none") and @class="ade-list-back"]//*


Активувати вікно якщо потрібно
    ${placeholder}  Set Variable  //*[@data-caption="+ Добавить"]
    ${status}  Run Keyword And Return Status  Element Should not Be Visible  ${placeholder}
    Run Keyword If  ${status} == ${false}  Click Element  //*[contains(@class, "multy-value-ade")]
    Sleep  3
    ${status}  Run Keyword And Return Status  element should be visible  //*[contains(@class, "dhxcombo_input_container")]//input
    Run Keyword If  ${status} == ${false}  Активувати вікно якщо потрібно


Натиснути кнопку пошуку
	Wait Until Keyword Succeeds  15  3  Click Element  //*[@id="HelpF10"]
	Дочекатись Загрузки Сторінки
	Element Should Not Be visible  //*[contains(@style, "display: block") and @class="ade-list-back"]


Перевірити зміну кольору поля пошуку
    ${selector}  Set Variable  //input[contains(@class, "dxeEditAreaSys")]
    Sleep  .5
    Click Element  ${selector}
	${list}  Create List  rgba(255, 230, 230, 1)  rgb(255, 230, 230)
	${elem}  Get Webelement  ${selector}
	${bg color}  Call Method  ${elem}  value_of_css_property  background-color
	${status}  Run Keyword And Return Status  Should Contain Any  ${list}  ${bg color}
	Run Keyword If  ${status} == ${false}  Click Element  ${selector}
	Run Keyword If  ${status} == ${false}  Перевірити зміну кольору поля пошуку


Натиснути кнопку "ОК"
	Click Element  //*[contains(@class, "dhx_toolbar_btn")]
	Wait Until Page Does Not Contain Element  //*[@class="dhxwin_active menuget"]
