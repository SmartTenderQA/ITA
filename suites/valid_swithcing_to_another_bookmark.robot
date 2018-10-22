*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${Button1}  //div[@role="link"]

*** Test Cases ***
Виконати передумови
  Відкрити сторінку ITA
  Авторизуватися  ${login}  ${password}
  Настиснути кнопку "Консоль"
  Перейти на вкладку  C#


"Консоль". C# Виконати команду
  Ввести команду  ${activating_validation_form}
  Натиснути кнопку "1 Выполнить"


Перевірити виконання команди
  Перевірити наявність діалогового вікна по title  Для UI теста. Не удалять.
  Перевірити кількість вкладок
  Перевірити Наявність Кнопки
  Перевірити наявність поля вводу


Робота з полем вводу
  Введення тексту в поле


Перевірка можливості переходу до іншої закладки
  Click Element  ${tabs}[2]
  Перевірити що поле вводу змінило фоновий колір на червоний
  Перевірити що перша вкладка активна



*** Keywords ***
Перевірити наявність діалогового вікна по title
  [Arguments]  ${title}
  Wait Until Page Contains Element  //div[contains(@class, "active") and contains(., "${title}")]


Перевірити кількість вкладок
  Set Global Variable  ${tabs}  //li[contains(@id, "pageHeader")]
  ${count}  Get Element Count  ${tabs}
  Should Be Equal  "2"  "${count}"


Перевірити Наявність Кнопки
  Page Should Contain Element  //div[contains(@class, "form_btn_txt")]


Перевірити наявність поля вводу
  Set Global Variable  ${input_field_selector}  //input[contains(@class, "form_textarea")]
  Page Should Contain Element  ${input_field_selector}


#Отримати початковий колір поля вводу
#  ${elem}    Get Webelement    ${input_field_selector}
#  ${bg_color}    Call Method    ${elem}    value_of_css_property    background-color
#  Set Global Variable  ${initial_input_color}  ${bg_color}


Перевірити що поле вводу змінило фоновий колір на червоний
  Sleep  .5
  ${list}  Create List  rgba(255, 230, 230, 1)  rgb(255, 230, 230)
  ${elem}    Get Webelement    ${input_field_selector}
  ${bg_color}    Call Method    ${elem}    value_of_css_property    background-color
  Should Contain Any  ${list}  ${bg_color}


Введення тексту в поле
  Click Element  ${input_field_selector}
  Input Text  ${input_field_selector}  1


Перевірити що перша вкладка активна
  Page Should Contain Element  //a[contains(text(), "Закладка1")]/parent::*[contains(@class, "active")]