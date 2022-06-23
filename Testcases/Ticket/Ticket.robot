*** Settings ***

Resource  ../../Resources/import.robot

Suite Setup      Run Keywords       Delete Screenshots
...     AND      Launch STR Application
Test Teardown    Error ScreenShot
Suite Teardown   Run Keywords    Remove screenshots from Output
#...    AND       Close Browser

*** Variables ***
${Screenshot_Master_tic}      ${EXECDIR}\\TestCases\\Ticket\\Compare_Screen\\Master
${Screenshot_Output_tic}       ${EXECDIR}\\TestCases\\Ticket\\Compare_Screen\\Output
${ticket_img}       ${Ticket_container}/div[1]/img
${Ticket_container}     xpath://*[@class="container ticket-container"]

*** Test Cases ***

TC1- Open Ticket Voice
    Select Tab       ${Voice_Tab}
    Get RXsession and CustomerproductID   voice
    Get Appointment date and time      voice    ${CustomerproductID}
    Verify Tickets Page


TC2- Open Ticket internet
    Select Tab       ${internet_Tab}
    Get RXsession and CustomerproductID   internet
    Get Appointment date and time      internet    ${CustomerproductID}
    Verify Tickets Page

