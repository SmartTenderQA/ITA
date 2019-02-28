*** Variables ***
${login_page}							//*[@class="dhxwin_active menuget"]
${login_name_field}						(${login_page}//input)[1]
${login_pass_field}						(${login_page}//input)[2]
${login_rememberme_checkbox}			(${login_page}//input)[3]
${login_forgot_password}				(${login_page}//*[contains(@class, "button") and @role="link"])[1]
${login_login_button}					(${login_page}//*[contains(@class, "button") and @role="link"])[2]


*** Keywords ***
Fill login field
	[Arguments]  ${login}
	Input Text  ${login_name_field}  ${login}


Fill password field
	[Arguments]  ${password}
	Input Text  ${login_pass_field}  ${password}


Sign In
	Click Element  ${login_login_button}
