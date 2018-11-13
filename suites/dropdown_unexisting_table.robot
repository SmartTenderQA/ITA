*** Settings ***
Resource     ../src/keywords.robot
Variables    var.py
Library      data.py

Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
	Авторизуватися  ${login}  ${password}


Відкрити "Консоль"
	Настиснути кнопку "Консоль"


Консоль. Перейти на вкладку C#
	Перейти на вкладку  C#


Консоль. C# Виконати команду
	Ввести команду  ${dropdown unexisting command}
	Натиснути кнопку "1 Выполнить"


Перевірити виконання команди
  Перевірити що назва нового вікна  Несуществующая таблица
  Перевірити що дропдаун порожній


Спробувати відкрити випадаючий список
  Відкрити випадаючий список
  Відкрити пошук


Завершити роботу з відкритим вікном
  Натиснути кнопку "ОК"


*** Keywords ***
Перевірити що назва нового вікна
  [Arguments]  ${title}
  ${selector}  Set Variable  //*[contains(@class, "dhxform_txt_label2")]
  Wait Until Element Is Visible  ${selector}
  ${text}  Get Text  ${selector}
  Should Be Equal  ${text}  ${title}


Перевірити що дропдаун порожній
  ${text}   Get Element Attribute  //input[contains(@class, "dxeEditAreaSys")]  value
  Should Be Empty  ${text}


Відкрити випадаючий список
  Click Element  //*[contains(@class, "fixed-invisible-ade-buttons")]
  Element Should Not Be Visible  //*[contains(@style, "display: none") and @class="ade-list-back"]


Відкрити пошук
  Wait Until Keyword Succeeds  15  3  Click Element  //*[@id="HelpF10"]
  Element Should Not Be visible  //*[contains(@style, "display: block") and @class="ade-list-back"]
  Перевірити зміну кольору поля пошуку


Перевірити зміну кольору поля пошуку
  ${selector}  Set Variable  //input[contains(@class, "dxeEditAreaSys")]
  ${list}  Create List  rgba(255, 230, 230, 1)  rgb(255, 230, 230)
  Click Element  ${selector}
  ${elem}  Get Webelement  ${selector}
  ${bg color}  Call Method  ${elem}  value_of_css_property  background-color
  Should Contain Any  ${list}  ${bg color}


Натиснути кнопку "ОК"
  Click Element  //*[contains(@class, "dhx_toolbar_btn")]
  Wait Until Page Contains  Консоль отладки
  Page Should Not Contain Element  //*[@class="dhxwin_active menuget"]
