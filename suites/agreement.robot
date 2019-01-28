*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


#  robot -L TRACE:INFO -A suites/arguments.txt -v env:ITA_web2016 -v capability:chrome -v hub:None suites/change_of_stages.robot

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
    В поле Обьект ввести  _AGREE
    Натиснути кнопку форми  Добавить
    Перевірити додавання об'єкту  ${object}


Провести документ та додати зауваження
    Натиснути Кнопку  Передать вперед (Alt+Right)
    Перевірити що стадія документу  Согласование
    Додати зауваження  Замечание
    Перевірити що стадія документу  1


Перевірити наявність зауваження
    Натиснути Кнопку  Бизнес-процессы (Shift+F12)
    Перевірити інформацію про зауваження
    Закрити вікно Бізнес процесс


Спробувати провести документ в архів
    Натиснути Кнопку  Передать вперед (Alt+Right)
    Перевірити що стадія документу  Согласование
    Натиснути Кнопку  Передать вперед (Alt+Right)
    Перевірити наявність повідомлення про помилку


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


Розкрити випадаючий список кнопки Вернуть назад
    Click element  //a[@class="dxr-lblText" and text()="Вернуть назад"]
    ${status}  Wait Until Element Is Visible  //span[@class="dx-vam" and text()="Замечание"]  10
    Run Keyword If  ${status} == ${false}  Розкрити випадаючий список кнопки Вернуть назад


Додати зауваження
    [Arguments]  ${remark}
    Розкрити випадаючий список кнопки Вернуть назад
    Click Element  //span[@class="dx-vam" and text()="Замечание"]
    Дочекатись загрузки сторінки (web2016)
    Wait Until Element Is Visible  //span[@class="dxpc-headerText dx-vam" and text()="Замечание"]
    Select Frame  //iframe[contains(@name, "DesignIFrame")]
    Input Text  //body  ${remark}
    Unselect Frame
    Click Element  //span[@class="dxr-lblText" and text()="OK"]
    Дочекатись загрузки сторінки (web2016)


Перевірити інформацію про зауваження
    Wait Until Page Contains Element  xpath=((//tr[@class="evenRow rowselected"])[last()]//td)[8 and text()="Замечание"]
    Wait Until Page Contains Element  xpath=((//tr[@class="evenRow rowselected"])[last()]//td)[9 and text()="c комментарием"]


Закрити вікно Бізнес процесс
    Click Element  //div[@class="dxpc-closeBtn"]


Перевірити наявність повідомлення про помилку
    Wait Until Page Contains Element  //pre[@class="message-content wrap"]
    ${text}  Get Text  //pre[@class="message-content wrap"]
    Should Contain  ${text}  Движение невозможно! Не выполнено согласование документа:


Перевірити видалення документу
    Page Should Not Contain Element  //tr[contains(@class, "rowselected")]//td[text()="${object}"]