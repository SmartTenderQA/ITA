*** Variables ***
${main_menu_search}                             xpath=//*[@class="search-panel-text"]


*** Keywords ***
Виконати пошук пункта меню
	[Arguments]  ${menu_name}
	Wait Until Keyword Succeeds  10  .5  Ввести текст в поле пошуку  ${menu_name}
	Press Key  ${main_menu_search}  ${enter btn}
	Wait Until Keyword Succeeds  10  .5
	...  Click Element  //*[@class="menu-item-text" and contains(., "${menu_name}")][not(following-sibling::*[@class="tree-view-expand-button"])]
	Дочекатись Загрузки Сторінки


Ввести текст в поле пошуку
	[Arguments]  ${menu_name}
	Input Text  ${main_menu_search}  ${menu_name}
	${text}  Get Element Attribute  ${main_menu_search}  value
	Should be Equal  ${text}  ${menu name}
