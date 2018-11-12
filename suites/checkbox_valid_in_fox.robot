*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


#robot -L TRACE:INFO -A suites/arguments.txt -v capability:chrome -v hub:None suites/checkbox_valid_in_fox.robot
*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
	Авторизуватися  ${login}  ${password}


Відкрити "Консоль" та виконати команду
	Настиснути кнопку "Консоль"
    Перейти на вкладку  Vfp
    Ввести команду  ${vfp checkbox}
    Натиснути кнопку "1 Выполнить"


Перевірити роботу чек-бокса
    Перевірити наявність чек-бокса
    Натиснути на чек-бокс
    Перевірити відсутність чек-бокса





*** Keywords ***
Перевірити наявність чек-бокса
    ${name}  Get Text  //*[@class="dhxform_label_nav_link"]
    Should Be Equal  '${name}'  ' Функция доступна для вызова'
    Page Should contain element  //i[text()="check_box"]


Натиснути на чек-бокс
    Click Element  //*[@help-id="CHECK"]/div
    Sleep  .5


Перевірити відсутність чек-бокса
    Page Should Not Contain Element  //i[text()="check_box"]







