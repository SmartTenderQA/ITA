*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


#robot -L TRACE:INFO -A suites/arguments.txt -v capability:chrome -v hub:None suites/checkbox_valid_in_fox.robot
*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
	Авторизуватися  ${login}  ${password}


Відкрити "Консоль" та виконати команду
	Настиснути кнопку "Консоль"
    Перейти на вкладку  Vfp
    Ввод команды в консоль  ${vfp checkbox}
    Натиснути кнопку "1 Выполнить"


Перевірити роботу чек-бокса
    Перевірити наявність чек-бокса
    Натиснути на чек-бокс
    Перевірити відсутність чек-бокса


*** Keywords ***
Input By Line
#  Ввод теста построчно
  [Arguments]  ${input_field}  ${text}
  ${lines_count}  Get Line Count  ${text}
  Sleep  .5
#  Wait Until Keyword Succeeds  15  2  Click Element At Coordinates  ${input_field}  5  5
  Wait Until Keyword Succeeds  15  2  Click Element  ${input_field}
  Clear Element Text  ${input_field}
  :FOR  ${i}  IN RANGE  ${lines_count}
  \  ${line}  Get Line  ${text}  ${i}
  \  Input Type Flex  ${input_field}  ${line}
  \  Sleep  .3
  \  Press Key  ${input_field}  ${enter btn}
  \  Sleep  .3


Ввод команды в консоль
  [Arguments]  ${command}
  Визначити індекс активної консолі
  ${input_field}  set variable  //textarea[contains(@name, "DEBUGCONSOLE")][${console_index}]
  Run Keyword If  '${capability}' != 'edge'  Ввести команду  ${command}
  ...  ELSE  Input By Line  ${input_field}  ${command}


Визначити індекс активної консолі
  :FOR  ${console_index}  in range  1  5
  \  ${status}  Run Keyword And Return Status
  ...  Element Should Be Visible  (//textarea[contains(@name, "DEBUGCONSOLE")])[${console_index}]
  \  debug
  \  Set Suite Variable  ${console_index}
  \  Exit For Loop If  ${status} == ${true}


Перевірити наявність чек-бокса
    ${name}  Get Text  //*[@class="dhxform_label_nav_link"]
    ${text}  Set Variable   Функция доступна для вызова
    ${name}  Remove String  ${name}  \xa0
    ${name}  Remove String  ${name}  ${SPACE}
    ${text}  Remove String  ${text}  ${SPACE}
    Should Be Equal  '${name}'  '${text}'
    Page Should contain element  //i[text()="check_box"]


Натиснути на чек-бокс
    Click Element  //*[@help-id="CHECK"]/div
    Sleep  .5


Перевірити відсутність чек-бокса
    Page Should Not Contain Element  //i[text()="check_box"]







