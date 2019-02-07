*** Settings ***
Resource  ../src/keywords.robot
Suite Setup  Preconditions
Suite Teardown  Видалити документ та закрити браузер
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


#  robot -L TRACE:INFO -A suites/arguments.txt -v env:ITA_web2016 -v browser:chrome -v hub:None suites/copier_stapler.robot

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
    В поле Обьект ввести  _COPIER
    Натиснути кнопку форми  Добавить
    Перевірити додавання об'єкту  ${object}


Створити копію документа
    Натиснути Кнопку  Передать вперед (Alt+Right)
    Перевірити що з'явилось вікно Копир
    В формі Копир натиснути кнопку Да
    Перевірити створення копії документа


Спробувати передати вперед копію документа
    Обрати копію документа
    Натиснути Кнопку  Передать вперед (Alt+Right)
    Перевірити що з'вилось вікно з помилкою


Провести оригінал документу
    Обрати оригінал документу
    Натиснути Кнопку  Передать вперед (Alt+Right)
    ${status}  Перевірити що стадія документу  Архив
    Run Keyword If  ${status} == ${false}  Натиснути Кнопку  Передать вперед (Alt+Right)
    Перевірити відсутність копії документу


*** Keywords ***
Перевірити що відкрито екран додавання об'єктів
    Page Should Contain Element  //span[@id="pcModalMode_PWH-1T" and text()="Добавление. Объекты"]
    Page Should Contain Element  //span[text()="Объект"]


Перевірити що з'явилось вікно Копир
    Wait Until Page Contains Element  //span[@id="IMMessageBox_PWH-1T" and text()="Копир"]
    Wait Until Page Contains Element  //div[@id="IMMessageBoxBtnYes"]
    Wait Until Page Contains Element  //div[@id="IMMessageBoxBtnNo"]


В формі Копир натиснути кнопку Да
    Click Element  //div[@id="IMMessageBoxBtnYes"]
    Дочекатись загрузки сторінки (web2016)


Перевірити створення копії документа
    Wait Until Page Contains Element  xpath=//tr[contains(@class, "Row")]//td[text()="${object}"]/parent::*//td[last() and text()="Копия"]


Обрати копію документа
    Click Element  xpath=//tr[contains(@class, "rowselected")]/following-sibling::tr
    ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  //tr[contains(@class, "rowselected")]//td[last() and text()="Копия"]
    Run Keyword If  ${status} == ${false}  Обрати копію документа


Перевірити що з'вилось вікно з помилкою
    Wait Until Page Contains Element  xpath=//div[@class="message"]//font[contains(text(), "Движение вперед невозможно")]


Обрати оригінал документу
    Click Element  xpath=//tr[contains(@class, "rowselected")]/preceding::tr//td[last() and text()="Оригинал"]/parent::*
    ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  //tr[contains(@class, "rowselected")]//td[last() and text()="Оригинал"]
    Run Keyword If  ${status} == ${false}  Обрати оригінал документу


Перевірити відсутність копії документу
    Page Should Not Contain Element  xpath=//tr[contains(@class, "rowselected")]/following-sibling::tr//td[last() and text()="Копия"]