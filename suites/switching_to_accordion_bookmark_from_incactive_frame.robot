*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


*** Variables ***

# Команда для запуска
# robot -L TRACE:INFO -A suites/arguments.txt -v capability:edge -v env:ITA -v hub:None suites/switching_to_accordion_bookmark_from_incactive_frame.robot

*** Test Cases ***
Авторизуватись
  Авторизуватися  ${login}  ${password}


Відкрити "Консоль"
  Настиснути кнопку "Консоль"


Консоль. Перейти на вкладку C#
  Перейти на вкладку  C#


Консоль. C# Виконати команду
  Ввод команды в консоль  ${data_editor_call}
  Натиснути кнопку "1 Выполнить"
  Дочекатись Загрузки Сторінки (ita)


Відкрити закладку
  Перевірка відкритої сторінки
  Активувати верхній фрейм
  Wait Until Keyword Succeeds  15  3  Натиснути На Панель  Закладка2


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
  Wait Until Page Does Not Contain Element  //span[contains(text(), '${title}')]/ancestor::div[3][contains(@class,'closed')]  15
  ${tab_class}  Get Element Attribute   ${selector}/ancestor::div[contains(@class, "cell_acc")]  class
  Should Be Equal  '${tab_class}'  'dhx_cell_acc'
