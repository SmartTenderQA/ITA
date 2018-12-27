*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***
${add field btn}                    xpath=(//div[@class="dhxform_btn"])[3]
${scroll field btn}                 xpath=//*[@help-id="REPZSMPLGRDSELECTFIELDS"]//*[@class="ps__scrollbar-y"]
${added fields}                     xpath=(//td[contains(@class,'multiline')])
${a}                                10


#  robot -L TRACE:INFO -A suites/arguments.txt -v browser:chrome -v hub:None suites/adding_non_register_fields_template.robot
#  команда для запуска
*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
  Авторизуватися  ${login}  ${password}
  Створити пустий список


Відкрити головне меню та запустити функцію "Универсальный отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


В полі регістр вибрати пункт UI-Тестирование
  Ввести назву регістру  UI-Тестирование
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити що поле не пусте  ${report_title}


Створити звіт та перейти на вкладку поля
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Создать отчет"
  Ввести довільну назву звіту
  Натиснути кнопку "Мастер создания шаблона"


Додати довільні поля з довідника основного поля
  [Template]  Вибрати довільні поля з довідників
  1
  2
  3


Перевірити вибір полів значень та запам'ятати їх
  Перевірити вибір полів
  Set Global Variable  ${values}  ${selected fields}


Обрати поля у вкладці Групи
  Set Global Variable  ${add field btn}  xpath=(//div[@class="dhxform_btn"])[7]
  Перейти На Вкладку  Группы


Додати довільні поля з довідника на вкладцы групи
  [Template]  Вибрати довільні поля з довідників
  1
  2
  3


Перевірити вибір полів груп та запам'ятати їх
  Перевірити вибір полів
  Set Global Variable  ${groups}  ${selected fields}
  Натиснути кнопку "ОК"


Перевірити додавання полей на сторінці настройка отчета
  Порівняти додані поля
  Натиснути Кнопку "Добавить"
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити відповідність заголовка звіту


Сформувати звіт та пеевірити додавання полей
  Натиснути кнопку "Сформировать отчет"
  Select Frame  //iframe
  Порівняти поля груп
  Порівняти відображення полей значень
  Unselect Frame


Видалити створений звіт
  Натиснути випадаючий список кнопки "Конструктор"
  Натиснути пункт "Удалить отчет"

*** Keywords ***
Створити пустий список
  ${list}  Create List
  Set Global Variable  ${list}


Натиснути кнопку "Мастер создания шаблона"
  ${selector}  Set Variable  xpath=//div[@help-id="REPZSMPLBTNWIZARD"]
  Wait Until Keyword Succeeds  15  3  Click Element  ${selector}
  Дочекатись Загрузки Сторінки (ita)
  ${status}  Run Keyword And Return Status  Wait Until Element Is Visible  xpath=//div[@class="float-container-header-text" and text()="Мастер создания шаблона. Новый шаблон"]
  Run Keyword If  ${status} == ${false}  Натиснути кнопку "Мастер создания шаблона"


Перейти На Вкладку
  [Arguments]  ${title}
  Click Element  //a[text()="${title}"]
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  xpath=//a[text()="${title}"]/parent::*[contains(@class, "active")]
  Run Keyword If  ${status} == ${false}  Перейти На Вкладку  ${title}


Визначити Індекс Активного Вікна
  :FOR  ${i}  In Range  6
  \  ${status}  Run Keyword And Return Status  Element Should Be Visible  xpath=((//*[contains(@class, 'selectable')]/table)[${i}]//tr//div[1]//i)
  \  Run Keyword If  ${status} == ${true}  Set Global Variable  ${exp field}  xpath=((//*[contains(@class, 'selectable')]/table)[${i}]//tr//div[1]//i)
  \  Run Keyword If  ${status} == ${true}  Set Global Variable  ${dict field}  xpath=((//*[contains(@class, 'selectable')]/table)[${i}]//tr//*[@style="padding-left:60px"]//span)
  \  Exit For Loop If  ${status} == ${true}


Перевірити вибір полів
  ${selected fields}  Create List
  Set Global Variable  ${selected fields}
  ${fields count}  Get Element Count  ${added fields}
  Set Global Variable  ${fields count}
  :FOR  ${i}  IN RANGE   ${fields count} + 1
  \  ${status}  Run Keyword And Return Status  Element Should Be Visible  ${added fields}[${i}]
  \  Continue For Loop If  ${status} == ${false}
#  \  ${i}  Evaluate  ${i} + 1
  \  ${fieldname}  Get Text  ${added fields}[${i}]
  \  ${fieldname}  Replace String  ${fieldname}  ${\n}  ${space}
  \  Append To List  ${selected fields}  ${fieldname}
  Should Be Equal  ${list}  ${selected fields}
  ${list}  Create List
  Set Global Variable  ${list}


Натиснути кнопку "ОК"
  Click Element  //*[contains(@class, "dhx_toolbar_btn")]
  Дочекатись Загрузки Сторінки (ita)
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  //div[@class="float-container-header-text" and text()="Настройка отчета"]
  Run Keyword If  ${status} == ${false}  Натиснути кнопку "ОК"


Порівняти додані поля
  Select Frame  (//div[@class="spreadsheet"])[2]//iframe
  Дочекатись Загрузки Сторінки (ita)
  Порівняти відображення полей значень
  Порівняти відображення полей груп
  Unselect Frame



Порівняти відображення полей значень
  ${selected fields}  Create List
  Set Global Variable  ${selected fields}
  ${fields_count}  Get Length  ${values}
  :FOR  ${field}  IN RANGE  1  ${fields_count} + 1
  \  ${fieldname}  Get Text  (//div[contains(@id, "TR_tb.")])[${field}]
  \  ${fieldname}  Replace String  ${fieldname}  ${\n}  ${space}
  \  Append To List  ${selected fields}  ${fieldname}
  Should Be Equal  ${values}  ${selected fields}


Порівняти відображення полей груп
  ${selected fields}  Create List
  Set Global Variable  ${selected fields}
  ${fields_count}  Get Length  ${groups}
  :FOR  ${field}  IN RANGE  3  6
  \  Run Keyword If  '${capability}' != 'firefox'  click element at coordinates  xpath=(//div[contains(@id, "TR_tb.0.") and @class="dxss-tb"])[${field}]  0  30
  \  Run Keyword If  '${capability}' == 'firefox'  Click Element  xpath=(//div[contains(@id, "TR_tb.0.") and @class="dxss-tb"])[${field}]
  \  Sleep  2
  \  ${fieldname}  Get Text  xpath=(//div[contains(@id, "TR_tb.0.") and @class="dxss-tb"])[${field}]
  \  ${fieldname}  Fetch From Left  ${fieldname}  ]
  \  ${fieldname}  Fetch From Right  ${fieldname}  [
  \  Append To List  ${selected fields}  ${fieldname}
  Should Be Equal  ${groups}  ${selected fields}


Натиснути кнопку "Сформировать отчет"
  Wait Until Keyword Succeeds  15  3  Click Element  xpath=//*[contains(text(), 'Сформировать отчет')]
  Дочекатись Загрузки Сторінки (ita)


Порівняти поля груп
  ${selected fields}  Create List
  Set Global Variable  ${selected fields}
  ${grp}  Get Text  //*[contains(@id, "R_tb.0.2")]
  @{displayed_groups}   Split String  ${grp}  \u2193
  ${length}  Get Length  ${displayed_groups}
  :FOR  ${i}  IN RANGE  ${length} - 1
  \  ${item}  Get From List  ${displayed_groups}  ${i}
  \  ${item}  Strip String  ${item}
  \  Append To List  ${selected fields}  ${item}
  Should Be Equal  ${groups}  ${selected fields}
