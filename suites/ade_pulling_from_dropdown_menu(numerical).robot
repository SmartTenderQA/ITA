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
  Ввести команду  ${pulling from dropdown numerical1}
  Натиснути кнопку "1 Выполнить"


Перевірити виконання команди
  Перевірити що назва нового вікна  Код
  ${first_value}  Get Text  (//*[@class="ade-val-caption"])[1]
  Should Be Equal  '${first_value}'  'Ноль (0)'
  ${second_value}  Get Text  (//*[@class="ade-val-caption"])[2]
  Should Be Equal  '${second_value}'  'Четыре (4)'


Очистити вибір та обрати вісі доступні опції
  Очистити вибір
  Обрати всі
  Натиснути кнопку "Esc"
  Запам'ятати додані поля
  Натиснути кнопку "ОК"
  Перевірити порядок цифр в вспливаючому вікні


Консоль. C# Виконати наступну команду
  Ввести команду  ${pulling from dropdown numerical2}
  Натиснути кнопку "1 Выполнить"


Перевірити виконання наступної команди
  Перевірити що назва нового вікна  Код
  ${first_value}  Get Text  (//*[@class="ade-val-caption"])[1]
  Should Be Equal  '${first_value}'  'Один (1)'
  ${second_value}  Get Text  (//*[@class="ade-val-caption"])[2]
  Should Be Equal  '${second_value}'  'Два (2)'


Додати кілька опцій
  Обрати довільні варіанти
  Натиснути кнопку "Esc"
  Запам'ятати додані поля
  Натиснути кнопку "ОК"
  Перевірити порядок цифр в наступному вспливаючому вікні


*** Keywords ***
Перевірити що назва нового вікна
  [Arguments]  ${title}
  ${selector}  Set Variable  //*[contains(@class, "dhxform_txt_label2")]
  Wait Until Element Is Visible  ${selector}
  ${text}  Get Text  ${selector}
  Should Be Equal  ${text}  ${title}


Очистити вибір
  ${selector}  Set Variable  //*[@class="dhxcombo_option dhxcombo_option_selected"]/../div//input
  Click Element  //*[contains(@class, "fixed-invisible-ade-buttons")]
  Wait Until Element Is Visible  //*[contains(@style, "display: block") and @class="ade-list-back"]
  Click Element  //*[contains(@class, "dhxcombo_hdrcell_check")]//input
  ${options_quantity}  Get Element Count  ${selector}
  :FOR  ${i}  IN RANGE  1  ${options_quantity} + 1
  \  Checkbox Should Not Be Selected  xpath=(${selector})[${i}]
  Page Should Not Contain Element  //*[@class="ade-val-caption"]


Обрати всі
  ${selector}  Set Variable  //*[@class="dhxcombo_option dhxcombo_option_selected"]/../div//input
  Click Element  //*[contains(@class, "dhxcombo_hdrcell_check")]//input
  ${options_quantity}  Get Element Count  ${selector}
  :FOR  ${i}  IN RANGE  1  ${options_quantity} + 1
  \  Checkbox Should Be Selected  xpath=(${selector})[${i}]
  ${numbers_quantity}  Get Element Count  //*[@class="ade-val-caption"]
  Should Be Equal  ${options_quantity}  ${numbers_quantity}


Натиснути кнопку "Esc"
  Press Key   //input[contains(@class, "dxeEditAreaSys")]    \\27
  Wait Until Element Is Not Visible  //*[contains(@style, "display: block") and @class="ade-list-back"]


Запам'ятати додані поля
  ${added_numbers}  Create List
  Set Global Variable  ${added_numbers}
  ${selector}  Set Variable  (//*[@class="ade-val-caption"])
  ${numbers_quantity}  Get Element Count  ${selector}
  Sleep  .5
  :FOR  ${i}  IN RANGE  1  ${numbers_quantity}+1
  \  ${text}  Get Text  (//*[@class="ade-val-caption"])[${i}]
  \  ${text}  Fetch From Right  ${text}  (
  \  ${text}  Fetch From Left  ${text}  )
  \  Append To List  ${added_numbers}  ${text}


Натиснути кнопку "ОК"
  Click Element  //*[contains(@class, "dhx_toolbar_btn")]
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  //*[@class="message-box-content-body"]
  Run Keyword If  ${status} == ${false}  Натиснути кнопку "ОК"


Перевірити порядок цифр в вспливаючому вікні
  ${text}  Get Text  //*[@class="message-box-content-body"]/p
  ${text}  Get Regexp Matches  ${text}  \\d+
  Should Be Equal  ${text}  ${added_numbers}
  Click Element  //*[contains(@class, "message-box-button")]
  Wait Until Page Contains  Консоль отладки C#


Обрати довільні варіанти
   ${selector}  Set Variable  //*[@class="dhxcombo_option dhxcombo_option_selected"]/../div//input
   Click Element  //*[contains(@class, "fixed-invisible-ade-buttons")]
   Wait Until Element Is Visible  //*[contains(@style, "display: block") and @class="ade-list-back"]
   ${options_quantity}  Get Element Count  ${selector}
   :FOR  ${i}  IN RANGE  3
   \  ${random}  random_number  3  ${options_quantity}
   \  Click Element  (${selector})[${random}]


Перевірити порядок цифр в наступному вспливаючому вікні
  ${text}  Get Text  //*[@class="message-box-content-body"]/p
  ${text}  Fetch From Right  ${text}  -
  Should Contain  ${text}  ;
  ${text}  Get Regexp Matches  ${text}  \\d+
  Should Be Equal  ${text}  ${added_numbers}
  Click Element  //*[contains(@class, "message-box-button")]
  Wait Until Page Contains  Консоль отладки C#