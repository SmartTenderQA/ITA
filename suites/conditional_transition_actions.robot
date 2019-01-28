*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


#  robot -L TRACE:INFO -A suites/arguments.txt -v env:ITA_web2016 -v capability:chrome -v hub:None suites/conditional_transition_actions.robot
*** Test Cases ***
Авторизуватись
	Авторизуватися  ${login}  ${password}


Запустити Функцію Конструктор бизнес-процессов и потоков документов
    Натиснути пункт меню  Инструментальные средства развития
    Натиснути пункт меню  Конструктор бизнес-процессов и потоков документов
    Натиснути пункт меню  Конструктор бизнес-процессов и потоков документов
    Відкрити функцію  Конструктор бизнес-процессов и потоков документов
    Перевірити відкриття функції Конструктор бизнес-процессов и потоков документов


Додати документ та перевірити його додавання
    Натиснути кнопку  Добавить (F7)
    Перевірити що відкрито екран додавання об'єктів
    В поле Обьект ввести  _CONDITION
    Натиснути кнопку форми  Добавить
    Перевірити додавання об'єкту  ${object}


Перевірити роботу умов при передаванні документів
    Натиснути Кнопку  Передать вперед (Alt+Right)
    Перевірити що з'явилось вікно Условие
    В формі Условие натиснути кнопку Отмена
    Перевірити що стадія документу  1
    Натиснути Кнопку  Передать вперед (Alt+Right)
    Перевірити що з'явилось вікно Условие
    В формі Условие натиснути кнопку Да
    Переконатись що з'явилось вікно Текстовый документ та закрити його
    Перевірити що стадія документу  2

Видалити документ
    Натиснути кнопку  Удалить (F8)
    Натиснути кнопку форми  Удалить
    Перевірити видалення документу

*** Keywords ***
Перевірити відкриття функції Конструктор бизнес-процессов и потоков документов
    Wait Until Page Contains Element  xpath=(//ul[@id="MainSted2PageControl_RSO_TC"]/li)[2]//td[text()="Объекты"]


Перевірити що відкрито екран додавання об'єктів
    Page Should Contain Element  //span[@id="pcModalMode_PWH-1T" and text()="Добавление. Объекты"]
    Page Should Contain Element  //span[text()="Объект"]


Перевірити що з'явилось вікно Условие
    Wait Until Page Contains Element  //span[@id="IMMessageBox_PWH-1T" and text()="Условие"]
    Wait Until Page Contains Element  //div[@id="IMMessageBoxBtnYes"]
    Wait Until Page Contains Element  //div[@id="IMMessageBoxBtnNo"]
    Wait Until Page Contains Element  //div[@id="IMMessageBoxBtnCancel"]


В формі Условие натиснути кнопку Отмена
    Click Element  //div[@id="IMMessageBoxBtnCancel"]
    Дочекатись загрузки сторінки (web2016)


В формі Условие натиснути кнопку Да
    Click Element  //div[@id="IMMessageBoxBtnYes"]
    Дочекатись загрузки сторінки (web2016)


Перевірити видалення документу
    Page Should Not Contain Element  //tr[contains(@class, "rowselected")]//td[text()="${object}"]


Переконатись що з'явилось вікно Текстовый документ та закрити його
    Wait Until Element Is Visible  //span[text()="Текстовый документ"]
    Select Frame  //iframe[contains(@id, "PreviewIFrame")]
    Wait Until Element Is Visible  //b[text()="Протокол тестирования"]
    Unselect Frame
    Click Element  //div[@class="dxpc-closeBtn"]
    Дочекатись загрузки сторінки (web2016)