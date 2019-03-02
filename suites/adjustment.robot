*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Test Cases ***
Авторизуватись
  Авторизуватися  ${login}  ${password}


Відкрити головне меню та знайти пункт меню "Учет изменений ПО"
  [Tags]  adjustment
  Натиснути на логотип IT-Enterprise
  main_menu.Виконати пошук пункта меню  Учет изменений ПО


Учет изменений ПО. "Коректировка"
  [Tags]  adjustment
  debug
  Перейти до екрану "Коректировка"
  Натиснути "Требует действий со стороны службы поддержки"


*** Keywords ***
Перейти до екрану "Коректировка"
  Click Element  ${F7}
  Wait Until Element Is Visible  xpath=(//div[@class="float-container-header-text" and text()="Добавление. Учет изменения ПО"])


Натиснути "Требует действий со стороны службы поддержки"
  Click Element  xpath=//*[@title="[NEEDACTIONS]"]
  ${value}  get_tooltip-panel_value
  Wait Until Element Is Visible  xpath=//*[contains(@title, '[OASU_ACTS]')]/preceding-sibling::*
  Run Keyword And Expect Error  *  Click Element  xpath=//*[@title="[NEEDACTIONS]"]