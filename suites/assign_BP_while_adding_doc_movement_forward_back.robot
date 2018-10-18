*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot

*** Variables ***


# команда для запуска через консоль
# robot -L TRACE:INFO -A suites/arguments.txt -v browser:chrome -v env:BUHETLA2 suites/assign_BP_while_adding_doc_movement_forward_back.robot
*** Test Cases ***
Відкрити сторінку BUHETLA2 та авторизуватись
  Відкрити сторінку BUHETLA2
  Sleep  1
  Авторизуватися  ${login}  ${password}


Обрати об'єкт
  Натиснути кнопку "Выбор"
  Дочекатись загрузки сторінки (buhetla2)

Запустити функцію "Реализация товаров и услуг"
  Обрати категорію меню  Продажи
  Обрати категорію меню  Документы
  Обрати категорію підменю  Реализация товаров и услуг
  Перевірити що открито сторінку "Реализация товаров и услуг"


Додати документ
  Підрахувати початкову кількість документів
  Натиснути кнопку  Добавить (F7)
  Дочекатись загрузки сторінки (buhetla2)
  Перевірка сторінки додавання документу
  Заповнити поля для додавання документу
  Натиснути кнопку форми  Добавить  //*[@id="pcModalMode_PW-1" and contains(., 'Добавление. Реестр документов')]


#Заповнити поля форми "Добавление. Строки"
#  Обрати режим формування  Ввести вручную
#  Перевірити що відкрито форму "Добавление. Строки"


Заповнити поля на екрані "Добавление Строки"
  Ввести дані в поле "Код ТМЦ"
  Ввести кількість
  Ввести вартість
  Ввести код
  Натиснути кнопку форми  Добавить
  Перевірити що открито сторінку "Реализация товаров и услуг"
  Підрахувати поточну кількість документів

Дії з документом
  Натиснути кнопку  Провести (Alt+Right)
  Перевірити проведення документу
  Натиснути кнопку  Отменить проведение (Alt+Left)
  Перевірити відміну проведення
  Натиснути кнопку  Удалить (F8)
  Натиснути кнопку форми  Удалить



*** Keywords ***
Дочекатись загрузки сторінки (buhetla2)
  ${loading_selector}  Set Variable  //span[@id="LoadingPanel_TL"]   #//div[@id="LoadingPanel"]
  ${status}  ${message}  Run Keyword And Ignore Error  Wait Until Element Is Visible  ${loading_selector}  5
  Run Keyword If  "${status}" == "PASS"  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading_selector}  120


Відкрити сторінку BUHETLA2
  Go To  ${url.${env}}


Вибрати користувача
  [Arguments]  ${login}
  ${selector}  Set Variable  (//input[contains(@class, "EditArea")])[1]
  Wait Until Element Is Visible  ${selector}  30
  Wait Until Element Is Enabled  ${selector}  30
  Input Text  ${selector}  ${login}
  Sleep  1


Ввести пароль
  [Arguments]  ${login}
  Input Text  (//input[contains(@class, "EditArea")])[2]  ${password}


Натиснути кнопку вхід BUHETLA2
  Click Element  //*[contains(text(), 'Войти')]


Авторизуватися BUHETLA2
  [Arguments]  ${login}  ${password}=None
  Wait Until Page Contains  Вход в систему  60
  Вибрати користувача  ${login}
# Ввести пароль  ${password}
  Натиснути кнопку вхід
  Дочекатись загрузки сторінки (buhetla2)
  Wait Until Page Contains  Выберите объект  60


Натиснути кнопку "Выбор"
  Wait Until Page Contains Element  //*[contains(@class, "Text") and contains(text(), "Выбор")]  30
  Click Element  //*[contains(@class, "Text") and contains(text(), "Выбор")]


Обрати категорію меню
  [Arguments]  ${item}
  Wait Until Page Contains Element  //label[contains(@style, "vertical-align") and contains(text(), '${item}')]  30
  Click Element  //label[contains(text(), '${item}')]


Обрати категорію підменю
  [Arguments]  ${item}
  Wait Until Page Contains Element   //label[contains(@style, "vertical-align") and contains(text(), '${item}')]  30
  Double Click Element  //label[contains(@style, "vertical-align") and contains(text(), '${item}')]
  Дочекатись загрузки сторінки (buhetla2)


Перевірити що открито сторінку "Реализация товаров и услуг"
  Wait Until Page Contains Element  //td[contains (@valign, "top") and contains(text(), "Реестр")]  30


Підрахувати початкову кількість документів
  ${quantity}  Get Element Count
  ...  //td[contains (@valign, "top") and contains(text(), "Строки")]/preceding::tr[contains(@class, "Row")]
  Set Global Variable  ${initial_documents_quantity}  ${quantity}


Натиснути кнопку
  [Arguments]  ${button_name}
  Wait Until Page Contains Element  //*[@title='${button_name}']  30
  Wait Until Element Is Visible  //*[@title='${button_name}']  30
  Click Element  //*[@title='${button_name}']
  Дочекатись загрузки сторінки (buhetla2)


Перевірка сторінки додавання документу
  Wait Until Page Contains Element  //li[contains(@class, "activeTab")]/a/span[contains(text(), "Документ")]  30
  ${value}  Get Element Attribute  //span[contains(., "Тип процесса")]/following-sibling::div//input  value
  ${list}  Create List  Акт оказанных услуг _ACTOUTS  Акт оказанных услуг (_ACTOUTS)
  Should Contain Any  ${list}  ${value}


Заповнити поля для додавання документу
  Заповнити поле Контр агента
  Заповнити поле Договір
  Вибрати відповідального


Заповнити поле Контр агента
  ${contractor_selector}  Set Variable  //span[contains(., "Контрагент")]/following-sibling::div//input
  Input Text  ${contractor_selector}  13356
  Press Key  ${contractor_selector}  \\09
  Sleep  2


Заповнити поле Договір
  ${agreement_selector}  Set Variable  //span[contains(., "Договор")]/following-sibling::div//input
  Input Text  ${agreement_selector}  *
  Press Key  ${agreement_selector}  \\09
  Sleep  2


Вибрати відповідального
  ${responsible_selector}  Set Variable  //span[contains(., "Ответственный")]/following-sibling::div//input
  ${responsible_dropdown_selector}  Set Variable
  ...  //span[contains(., "Ответственный")]/following-sibling::div//td[contains(@title, "Поиск элементов по введенному")]
  ${cell_selector}  Set Variable  //div[contains(@class, "combo_cell_text")]
  Click Element  ${responsible_selector}
 #Sleep  2
  Wait Until Element Is Visible  ${responsible_selector}  15
  Click Element  ${responsible_dropdown_selector}
  Wait Until Element Is Visible  ${cell_selector}  15
  Sleep  2
  Click Element  ${cell_selector}
  Sleep  3



Натиснути кнопку форми
  [Arguments]  ${button}  ${window}=${EMPTY}
  ${selector}  Set Variable  ${window}//*[@title='${button}']
  Wait Until Element Is Visible  ${selector}  30
  Sleep  .5
  Click Element  ${selector}
  Sleep  5
  Дочекатись загрузки сторінки (buhetla2)
  ${status}  Run Keyword And Return Status  Wait Until Element Is Not Visible    ${selector}
  Run Keyword If  ${status} == ${False}  Натиснути кнопку форми  ${button}


Обрати режим формування
  [Arguments]  ${mode}
  Wait Until Page Contains Element  //span[contains(text(), '${mode}')]  60
  Click Element  //span[contains(text(), '${mode}')]
  Дочекатись загрузки сторінки (buhetla2)


Перевірити що відкрито форму "Добавление. Строки"
  Wait Until Page Contains Element  //span[contains(., "Добавление. Строки")]  45
  Click Element  (//li/a/span[contains(., "Параметры")])[2]
  ${value}  Get Element Attribute  (//span[contains(., "Тип строки")]/following-sibling::table//input)[2]  value
  Should Be Equal  Услуги оказанные  ${value}


Ввести дані в поле "Код ТМЦ"
  ${TMC_code_selector}  Set Variable  (//table[@class="dhxcombo_outer"])[3]//input
  Wait Until Page Contains Element  ${TMC_code_selector}  30
  Input Text  ${TMC_code_selector}  200200000000016
  Sleep  2
#  без этого ожидания поле очищается
  Press Key  ${TMC_code_selector}  \\09
  Sleep  3
  ${TMC_code}  Get Element Attribute  ${TMC_code_selector}  value
  ${status}  Run Keyword And Return Status  Should Be Equal  '${TMC_code}'  'Аренда помещения (200200000000016)'
  Run Keyword If  ${status} == ${False}  Ввести дані в поле "Код ТМЦ"


Ввести кількість
  ${quantity_selector}  Set Variable  //table[@data-name="KOL"]//input
  Wait Until Element Is Visible  ${quantity_selector}  30
  Input Text  ${quantity_selector}  1
  Press Key  ${quantity_selector}  \\09
  Дочекатись загрузки сторінки (buhetla2)
  Sleep  2


Ввести вартість
  ${price_selector}  Set Variable  //table[@data-name="CENA_1VAL"]//input
  Input Text  ${price_selector}  4000
  Sleep  1
  Press Key  ${price_selector}  \\09
  Sleep  2
  Дочекатись загрузки сторінки (buhetla2)


Ввести код
  ${code_selector}  Set Variable  (//td[contains(@class, "editable")])//input
  Wait Until Element Is Visible  (//td[@class="cellselected"])[3]  30
  Click Element  (//td[@class="cellselected"])[3]
  Sleep  1
  Wait Until Element Is Enabled  ${code_selector}  30
  Input Text  ${code_selector}  D0201
  Press Key  ${code_selector}  \\09
  Sleep  4


Підрахувати поточну кількість документів
  ${quantity}  Get Element Count
  ...  //td[contains (@valign, "top") and contains(text(), "Строки")]/preceding::tr[contains(@class, "Row")]
  Set Global Variable  ${current_documents_quantity}  ${quantity}


Перевірити додавання документу
  Should Be True  ${current_documents_quantity} == (${initial_documents_quantity} + 1)
  Перевірити що статус поточного документу  Ввод


Перевірити проведення документу
  Дочекатись загрузки сторінки (buhetla2)
  Перевірити що статус поточного документу  Проведен


Перевірити відміну проведення
  Дочекатись загрузки сторінки (buhetla2)
  Перевірити що статус поточного документу  Ввод
  Page Should Contain Element  //*[@title="Провести (Alt+Right)"]


Перевірити що статус поточного документу
  [Arguments]  ${status}
  ${active_row_selector}  Set Variable
  ...  //td[contains (@valign, "top") and contains(text(), "Строки")]/preceding::tr[contains(@class, "rowselected")]/td[3]
  ${text}  Get Text  ${active_row_selector}
  Should Be True  '${text}' == '${status}'

