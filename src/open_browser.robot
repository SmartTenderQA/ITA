*** Keywords ***
Відкрити браузер firefox
    [Arguments]  ${alias}
    ${class_options}=  Evaluate  sys.modules['selenium.webdriver'].FirefoxOptions()  sys, selenium.webdriver
    Run Keyword If  ${headless} == ${True}  Run Keywords
    ...  Call Method    ${class_options}    set_headless    ${True}  AND
    ...  Call Method    ${class_options}    add_argument    disable-gpu
    Run Keyword If  '${browser_version}' == ''
    ...  Call Method    ${class_options}    set_capability  version  65.0.1
    ...  ELSE
    ...  Call Method    ${class_options}    set_capability  version  ${browser_version}

    ${options}  Call Method  ${class_options}  to_capabilities

    Run Keyword If  '${hub.lower()}' != 'none'  Run Keywords
    ...  Create Webdriver  Remote  alias=${alias}  command_executor=${hub}  desired_capabilities=${options}  AND
    ...  Отримати та залогувати data_session  ELSE
    ...  Create Webdriver  Firefox  alias=${alias}
    Go To  ${start_page}
    Set Window Size  1280  1024


Відкрити браузер chrome
    [Arguments]  ${alias}
    ${class_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Run Keyword If  ${headless} == ${True}  Run Keywords
    ...  Call Method    ${class_options}    set_headless    ${True}  AND
    ...  Call Method    ${class_options}    add_argument    disable-gpu

    Run Keyword If  '${browser_version}' != ''
    ...  Call Method    ${class_options}    set_capability  version  ${browser_version}

    Run Keyword If  '${platform}' != 'ANY'
    ...  Call Method    ${class_options}    set_capability  platform  ${platform}

    ${options}  Call Method  ${class_options}  to_capabilities

    Run Keyword If  '${hub.lower()}' != 'none'  Run Keywords
    ...  Create Webdriver  Remote  alias=${alias}  command_executor=${hub}  desired_capabilities=${options}  AND
    ...  Отримати та залогувати data_session  ELSE
    ...  Create Webdriver  Chrome  alias=${alias}
    Go To  ${start_page}
    Set Window Size  1280  1024


Відкрити браузер edge
    [Arguments]  ${alias}
#    ${class_options}=  Evaluate  sys.modules['selenium.webdriver'].DesiredCapabilities.EDGE  sys, selenium.webdriver
    Run Keyword If  '${hub.lower()}' != 'none'  Run Keywords
    ...  Open Browser  ${start_page}  edge  ${alias}  ${hub}  AND
    ...  Отримати та залогувати data_session  ELSE
    ...  Open Browser  ${start_page}  edge  ${alias}


Отримати та залогувати data_session
	${s2b}  get_library_instance  Selenium2Library
	${webdriver}  Call Method  ${s2b}  _current_browser
	Create Session  api  http://autotest.it.ua:4444/grid/api/testsession?session=${webdriver.__dict__['capabilities']['webdriver.remote.sessionid']}
	${data}  Get Request  api  \
	${data}  Set Variable  ${data.json()}
	Log  ${webdriver}
	Log  ${webdriver.__dict__}
	Log To Console  ${webdriver.__dict__['capabilities']}
	Log  ${webdriver.__dict__['capabilities']}
	Log To Console  ${data}
	Log  ${data}
