*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Виконати передумови
  Відкрити сторінку ITA
  Авторизуватися  ${login}  ${password}
  Відкрити головне меню та знайти пункт меню "Универсальный Отчет"


Створити звіт "UI-Тестирование"
  Ввести назву регістру  UI-Тестирование
  Ввести назву звіту  UI-Тестирование (отчет с отбором)
  Дочекатись загрузки сторінки (ita)
  Перевірка що відкрито закладку відбір
  Натиснути активну кнопку "Отбор"


Вийти З Функції "Универсальный Отчет"
  Натиснути кнопку "Esc"
  Перевірити що відкрито початкову сторінку ITA


Знов зайти в функцію "Универсальный Отчет"
  Натиснути на логотип IT-Enterprise
  Виконати пошук пункта меню  Универсальный отчет
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити заголовок звіту
  Перевірити що закладка відбір закрита
  Натиснути неактивну кнопку "Отбор"
  Натиснути кнопку "Esc"
  Перевірити що відкрито початкову сторінку ITA


І ще раз
  Натиснути на логотип IT-Enterprise
  Виконати пошук пункта меню  Универсальный отчет
  Перевірити що обрано пункт  UI-Тестирование
  Перевірити заголовок звіту
  Перевірка що відкрито закладку відбір


*** Keywords ***
Відкрити головне меню та знайти пункт меню "Универсальный Отчет"
  Натиснути на логотип IT-Enterprise
  Натиснути пункт головного меню  Администрирование системы
  Натиснути пункт головного меню  Администрирование системы и управление доступом
  Запустити функцію додаткового меню  Универсальный отчет


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


Перевірка що відкрито закладку відбір
  Wait Until Page Contains Element  //div[@title="Отбор" and contains(@class, "checked")]  15
  Wait Until Element Is Visible         //div[contains(@help-id, "CHECKBOX")]
  ${checkbox_count}  Get Element Count  //div[contains(@help-id, "CHECKBOX")]
  Should Be True  ${checkbox_count} > 1
  # наименования полей и операций
  ${label_count}  Get Element Count
  ...  //div[@class="dhxform_txt_label2" and text()[.="по"]]/following::div[contains(@class, "dhxform_txt_label2")]
  Should Be True  ${label_count} >= 4


Натиснути активну кнопку "Отбор"
  ${selector}  Set Variable  //div[@title="Отбор" and contains(@class, "checked")]
  Run Keyword And Ignore Error  Click Element   ${selector}
  ${status}  Run Keyword And Return Status
  ...  Element Should Not Be Visible  (//div[@class="dhxform_obj_material"])[2]
  Run Keyword If  ${status} == ${False}  Натиснути активну кнопку "Отбор"
  Дочекатись Загрузки Сторінки (ita)


Натиснути неактивну кнопку "Отбор"
  ${selector}  Set Variable  //div[@title="Отбор"]
  Run Keyword And Ignore Error  Click Element   ${selector}
  Sleep  1
  ${status}  Run Keyword And Return Status
  ...  Element Should Be Visible  (//div[@class="dhxform_obj_material"])[2]
  Run Keyword If  ${status} == ${False}  Натиснути неактивну кнопку "Отбор"
  Дочекатись Загрузки Сторінки (ita)


Натиснути кнопку "Esc"
  Press Key   //html/body    \\27
  Дочекатись Загрузки Сторінки (ita)


Перевірити що відкрито початкову сторінку ITA
  Page Should Contain Element  (//*[@title="Вид"])[2]


Перевірити що закладка відбір закрита
  Page Should Not Contain  //div[@title="Отбор" and contains(@class, "checked")]
  Element Should Not Be Visible  (//div[@class="dhxform_obj_material"])[2]


Перевірити заголовок звіту
  ${report_title}  Get Element Attribute  xpath=((//*[contains(text(), 'Отчет')])[3]/ancestor::div[2]//input)[4]  value
  Should Be Equal  UI-Тестирование (отчет с отбором)  ${report_title}