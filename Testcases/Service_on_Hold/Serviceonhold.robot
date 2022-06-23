*** Settings ***

Resource  ../../Resources/import.robot

Suite Setup      Run Keywords       Delete Screenshots
...     AND      Launch STR Application
Test Teardown    Error ScreenShot
Suite Teardown   Run Keywords    Remove screenshots from Output
#...    AND       Close Browser

*** Variables ***
#${Screenshot_Master_SOH}      ${EXECDIR}\\TestCases\\Service_on_Hold\\Compare_Screen\\Master
#${Screenshot_Output_SOH}       ${EXECDIR}\\TestCases\\Service_on_Hold\\Compare_Screen\\Output
${Vaction_img}       vaction.png
${vacation_screen}     xpath://*[@id="vacation-screen"]
${Vaction_link}      xpath://*[text()='How vacation service works']
${link_title}       Vacation Hold: Temporarily Pause Your Service | CenturyLink

#//*[@class="service-on-hold-outerdiv"]

*** Keywords ***

Verify vacation Page
     dashboard Text Container    ${STR_Container}
     #Capture and compare screenshot      ${vacation_screen}      ${Screenshot_Output_SOH}}    ${Screenshot_Master_SOH}}      vaction.png
     Should Contain     ${text}    ${SOH}
     Should Contain     ${text}    ${SoH_Msg}
     Should Contain     ${text}    ${Chat_Exit}
     Should Contain     ${text}    ${Additional_resour}
     Should Contain     ${text}    ${SOH_Link}



*** Test Cases ***

TC1 Vacation Suspend
    Verify vacation Page
    verify title of new tab   ${Vaction_link}   ${link_title}
