*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***

*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
  Авторизуватися  ${login}  ${password}


Відкрити "Консоль"
  Настиснути кнопку "Консоль"


"Консоль". Перейти на вкладку C#
  Перейти на вкладку  C#


"Консоль". C# Виконати команду
  Ввести команду  ${data_editor_call}
  Натиснути кнопку "1 Выполнить"
  Дочекатись Загрузки Сторінки (ita)


Відкрити закладку
  Перевірка відкритої сторінки
  Активувати верхній фрейм
  Натиснути На Панель  Закладка2


*** Keywords ***
Перевірка відкритої сторінки
  Set Suite Variable  ${frame_caption}  //div[@class="frame-caption"]/span[@title="UI-test"]
  Page Should Contain Element  ${frame_caption}
  ${tabs_count}  Get Element Count  //div[@class="dhx_cell_hdr_text"]
  Should Be True  ${tabs_count} != 0


Активувати верхній фрейм
  Click Element  ${frame_caption}


Натиснути на панель
  [Arguments]  ${title}
  ${selector}  Set Variable  //div[@class="dhx_cell_hdr_text"]/span[contains(text(), '${title}')]
  Click Element  ${selector}
  Wait Until Element Is Not Visible  (//div[@class="dhxform_obj_material"])[1]  15
  ${tab_class}  Get Element Attribute   ${selector}/ancestor::div[contains(@class, "cell_acc")]  class
  Should Be Equal  '${tab_class}'  'dhx_cell_acc'
