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
    В поле Обьект ввести  _SIMPLE
    Натиснути кнопку форми  Добавить
    Перевірити додавання об'єкту  ${object}


Передати документ уперед/назад
    Натиснути Кнопку  Вторая стадия (Alt+Right)
    Перевірити що стадія документу  2
    Натиснути Кнопку  Первая стадия (Alt+Left)
    Перевірити наявність кнопки  Вторая стадия (Alt+Right)
    Перевірити що стадія документу  1


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


Перевірити видалення документу
    Page Should Not Contain Element  //tr[contains(@class, "rowselected")]//td[text()="${object}"]