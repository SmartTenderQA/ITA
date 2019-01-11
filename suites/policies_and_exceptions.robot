*** Settings ***
Resource  ../src/keywords.robot
Variables   var.py
Library   data.py
Suite Setup  Preconditions
Suite Teardown  Postcondition
Test Setup  Check Prev Test Status
Test Teardown  Run Keyword If Test Failed  Something Went Wrong


#  robot -L TRACE:INFO -A suites/arguments.txt -v env:ITA_web2016 -v capability:chrome -v hub:None suites/policies_and_exceptions.robot

*** Test Cases ***
Відкрити сторінку ITA та авторизуватись
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
    В поле Обьект ввести  _POLITICS
    Натиснути кнопку форми  Добавить
    Перевірити додавання об'єкту  ${object}


Спробувати змінити документ
    Натиснути кнопку  Изменить (F4)
    Перевірити відсутність комбобокса Действует/Отменен
    Перевірити що поле Сокращенное не доступно для вводу
    Перевірити що поле Описание не доступно для вводу
    Натиснути кнопку форми  Сохранить
    Перевірити наявність сповіщення про помилку
    Натиснути кнопку форми  Отменить


Спробувати додати таблицю
    Перейти до вкладки Таблицы
    Wait Until Element Is Visible  //*[contains(@title,'Добавить (F7)')]  30
    Wait Until Keyword Succeeds  10  2  Click Element  //*[contains(@title,'Добавить (F7)')]
    Перевірити Наявність Сповіщення Про Неможливість Додавання


Провести документ
    Перейти до вкладки Объекты
    Натиснути Кнопку  Передать вперед (Alt+Right)
    Перевірити що стадія документу  2


Перевірити можливість зміни документу
    Натиснути кнопку  Изменить (F4)
    Перевірити наявність комбобокса Действует/Отменен
    Ввести текст в поле Сокращенное и очистить  test
    Ввести текст в поле Описание и очистить
    Натиснути кнопку форми  Отменить


Перевірити можливість додавання таблиці
    Перейти до вкладки Таблицы
    Натиснути кнопку  Добавить (F7)
    Перевірити наявність форми додавання таблиць
    Натиснути кнопку форми  Отменить


Видалити документ
    Перейти до вкладки Объекты
    Натиснути кнопку  Удалить (F8)
    Натиснути кнопку форми  Удалить
    Перевірити видалення документу


*** Keywords ***
Перевірити відкриття функції Конструктор бизнес-процессов и потоков документов
    Wait Until Page Contains Element  xpath=(//ul[@id="MainSted2PageControl_RSO_TC"]/li)[2]//td[text()="Объекты"]


Перевірити що відкрито екран додавання об'єктів
    Page Should Contain Element  //span[@id="pcModalMode_PWH-1T" and text()="Добавление. Объекты"]
    Page Should Contain Element  //span[text()="Объект"]


Перевірити що поле Сокращенное не доступно для вводу
    Run Keyword And Expect Error
    ...  *Element must be user-editable*
    ...  Ввести текст в поле Сокращенное и очистить  test


Ввести текст в поле Сокращенное и очистить
    [Arguments]  ${text}
    ${input}  Set Variable  //table[@data-name="NRSO_S"]//input
    Wait Until Element Is Visible  ${input}
    Input Text  ${input}  ${text}
    Sleep  1
    Clear Element Text  ${input}


Перевірити що поле Описание не доступно для вводу
    Select Frame  //iframe[contains(@id, "PreviewIFrame")]
    Run Keyword And Expect Error
    ...  *Element must be user-editable*
    ...  Ввести текст в поле Описание  test
    Unselect Frame


Ввести текст в поле Описание
    [Arguments]  ${text}
    ${input}  Set Variable  //body[contains(@class, "PreviewArea")]
    Wait Until Element Is Visible  ${input}
    Input Text  ${input}  ${text}


Перевірити відсутність комбобокса Действует/Отменен
    Element Should Not Be Visible  //*[@data-name="PR_DO"]


Перевірити наявність сповіщення про помилку
    Wait Until Page Contains Element  //div[@class="message"]/pre[text()="Введите значение"]


Перейти до вкладки Таблицы
    Wait Until Keyword Succeeds  10  2  Click Element  //div[@id="MainSted2TabPageHeaderLabel_2"]
    Wait Until Element Is Visible  //div[@id="MainSted2TabPageHeaderLabelActive_2"]
    Дочекатись Загрузки Сторінки (ITA_web2016)


Перевірити Наявність Сповіщення Про Неможливість Додавання
    Wait Until Element Is Visible  //span[text()="Добавление на данной стадии Вам запрещено."]  10
    Wait Until Element Is Not Visible   //span[text()="Добавление на данной стадии Вам запрещено."]  6


Перейти до вкладки Объекты
   Wait Until Keyword Succeeds  10  2  Click Element  //div[@id="MainSted2TabPageHeaderLabel_1"]
   Wait Until Element Is Visible  //div[@id="MainSted2TabPageHeaderLabelActive_1"]
   Дочекатись Загрузки Сторінки (ITA_web2016)


Перевірити наявність комбобокса Действует/Отменен
    Wait Until Element Is Visible  //*[@data-name="PR_DO"]


Ввести текст в поле Описание и очистить
    Select Frame  //iframe[contains(@id, "DesignIFrame")]
    ${input}  Set Variable  //body[contains(@class, "DesignViewArea")]
    Wait Until Element Is Visible  ${input}
    Input Text  ${input}  abc
    Sleep  1
    Clear Element Text  ${input}
    Unselect Frame


Перевірити наявність форми додавання таблиць
    Wait Until Element Is Visible  //span[text()="Добавление. Таблицы"]
    Wait Until Element Is Visible  //*[@title='Добавить']


Перевірити видалення документу
    Page Should Not Contain Element  //tr[contains(@class, "rowselected")]//td[text()="${object}"]