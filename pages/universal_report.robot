*** Variables ***
${selection button}						//*[@id="REP_SIMPLEQUERY"]
${select status}						[contains(@class, 'checked-button')]
${unselect status}						[not(contains(@class, 'checked-button'))]

*** Keywords ***
Активувати кнопку відбір
	selection button operation  ${select status}


Деактивувати кнопку відбір
	selection button operation  ${unselect status}


Статус кнопки відбір повинен бути
	[Arguments]  ${status}
	Run Keyword If
	...  "${status}" == "select"		Page Should Contain Element  ${selection button}${select status} 		ELSE IF
	...  "${status}" == "unselect" 		Page Should Contain Element  ${selection button}${unselect status}



######################################################################################
####################				*** KEYWORDS ***				###################
######################################################################################
selection button operation
	[Arguments]  ${selector}
	${status}  Run Keyword And Return Status
	...  Page Should Contain Element  ${selection button}${selector}
	Run Keyword If  ${status} == ${False}  Run Keywords
	...  Click Element  ${selection button}  AND
	...  Wait Until Keyword Succeeds  10  .5  Mouse Over  ${selection button}  AND
	...  Wait Until Page Contains Element  ${selection button}${selector}  30