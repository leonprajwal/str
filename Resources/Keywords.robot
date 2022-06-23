*** Keywords ***
open Chrome browser
    ${options}=    Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method    ${options}    add_argument    incognito
    Create WebDriver    ${BROWSER}    executable_path=${Chrome_DIR}    chrome_options=${options}
    Maximize Browser Window

Wait for text
     [Arguments]     ${Text}
     Wait until Keyword succeeds     3min    1ms     Page Should Contain       ${Text}   #loglevel=INFO
     Take Screenshot     ${EXECDIR}/ScreenShots/Text

Error ScreenShot
    Run Keyword If Test Failed    Take Screenshot     ${EXECDIR}/Failed_ScreenShot/Error

Remove screenshots from Output
    Remove Files   Output\\selenium-screenshot-*.png

Delete Screenshots
    Empty Directory     Failed_ScreenShot
    Empty Directory     ScreenShots

Capture and compare screenshot
    [Arguments]         ${Element}       ${Output}        ${master}     ${Imgname}
     Capture Element Screenshot      ${Element}        ${Output}\\${Imgname}
    ${Img}=     compare images and return   ${Output}\\${Imgname}           ${master}\\${Imgname}
    Run Keyword If    '${Img}'=='False'         Fail     Image Didnot Match

dashboard Text Container
     [Arguments]     ${Container}
    Sleep   20s
    ${text}=      Get Text   ${Container}  #STR_Container
    Set Global Variable    ${text}      ${text}
    #Log to Console    ${text}

verify title of new tab
    [Arguments]     ${Element}    ${Title}
    Click Element and Take ScreenShot    ${Element}
    Sleep   10s
    ${handle}=  Switch Window	NEW
    Sleep   5s
    ${tit}=    Get Title
    #Log to console         ${tit}
    Should Be Equal As Strings    ${tit}   ${Title}
    close window
    Sleep   10s
    Switch Window	 ${handle}

Launch STR Application
    Get Zipcode
    open Chrome browser
    go to     ${STR_URL}
    sleep   10s
    Verify the Opening Content dashbord
    Verify the Signin page

Verify the Opening Content dashbord
    dashboard Text Container    ${STR_Container}
    Should contain     ${text}    ${use_CenturyLink_1}
    Should contain     ${text}    ${use_CenturyLink_2}
    Should contain     ${text}    ${use_CenturyLink_3}
    Should contain     ${text}    ${Sign_In}
    Should contain     ${text}    ${New_Centurylink}
    Should contain     ${text}    ${Click_Billing}
    Should contain     ${text}    ${Phone_Auth}

Click Element and Take ScreenShot
    [Arguments]     ${Element}
    Take Screenshot     ${EXECDIR}/ScreenShots/click
    Click Element   ${Element}

Verify the Signin page
    Click Element and Take ScreenShot       ${Click_here}
    dashboard Text Container    ${STR_Container}
    Should contain     ${text}    ${Troubleshooter_msg}
    Should contain     ${text}    ${TroubleShoot_Login_msg}
    Should contain     ${text}    ${Acc_number_bill}
    Should contain     ${text}    ${Acc_Zip_msg}
    Should contain     ${text}    ${Forgot_msg}
    Should contain     ${text}    ${New_Centurylink}
    Should contain     ${text}    ${Continue_msg}
    Should contain     ${text}    ${Cant_find_msg}
    Should contain     ${text}    ${Retrieve_account_msg}
    Should contain     ${text}    ${Find_account_msg}
    Should contain     ${text}    ${My_CenturyLink_msg}
    Should contain     ${text}    ${Sign_In}
    Input Text         ${acc_num_field }        ${Number}
    Input Text         ${zip_code_field}        ${Zip_code}
    Click Element and Take ScreenShot           ${Continue_Login}
    Wait for text           ${relax}
    Sleep    50s

Select Tab
    [Arguments]     ${Tab}
    Click Element and Take ScreenShot     ${Tab}

Get Zipcode
    ${Auth}=     create list        ${username_api}    ${Pwd_api}
    Create Session    mysession     ${Base_Url}    auth=${Auth}
    ${response}=     GET On Session    mysession   ${Productinfo_URL}
    ${rx_info}=    Get From Dictionary      ${response.json()}     recordsChoice
    ${Cust_detail}=    Get From List        ${rx_info}     0
    #log to console    ${Cust_detail}
    ${test_info}=    Get From Dictionary     ${Cust_detail}      address
    #log to console   ${test_info}
    ${cust_info}=    Get From Dictionary      ${test_info}     postalCode
    #log to Console      ${cust_info}
    #${words} =	Split String	${cust_info}
    ${Zip_code}=     Get Substring        ${cust_info}    0    5
    set global variable     ${Zip_code}   ${Zip_code}
    log to console  ${Zip_code}


Verify Tickets Page
     dashboard Text Container    ${Ticket_container}
     Capture and compare screenshot      ${ticket_img}      ${Screenshot_Output_tic}    ${Screenshot_Master_tic}      Ticket_img.png
     Should Contain     ${text}    ${Tickets}
     Should Contain     ${text}    ${Help_Way}
     Should Contain     ${text}    ${Open_repair_service}
     Should Contain     ${text}    ${App_Date}
     Should Contain     ${text}    ${App_Time}
     Should Contain     ${text}    ${Repair_ticket}
     Should Contain     ${text}    ${tic_Created}
     Should Contain     ${text}    ${Reschedule_App}
     Should Contain     ${text}    ${Cancel_app}
     Should Contain     ${text}    ${update_app}
     Should Contain     ${text}    ${Updated_time}
     Should Contain     ${text}     ${Appoint_date}
     Should Contain     ${text}     ${create_date}
     Should Contain     ${text}     ${Repair_number}

Time Convert
    [Arguments]   ${hour}  ${Min}
    ${converted hour}=  Evaluate   ${hour} - 12
    Set Global Variable   ${Updated_time}       ${converted hour}:${Min} PM
    Log to Console     ${Updated_time}

Get Appointment date and time
    [arguments]    ${Ticket_type}    ${Customerproduct}
    #Get RXsession and CustomerproductID
    ${Auth}=     create list        ${username_api}    ${Pwd_api}
    Create Session    mysession     ${Base_Url}    auth=${Auth}
    ${response}=     GET On Session    mysession     url=${rel_Url}/rxTicketInfo?wtn=${Number}&customerProductId=${Customerproduct}&rxSessionIdentifier=${RXsession}
    ${rx_info}=    Get From Dictionary      ${response.json()}     troubleReports
    #Log to Console      ${rx_info}
     ${item}=    Get From List       ${rx_info}   0
     ${Repair_num}=    Get From Dictionary      ${item}     nativeTroubleReportIdentifier
     Set Global Variable     ${Repair_number}    ${Repair_num}
     Log to Console      ${Repair_number}
     ${rx2_info}=    Get From Dictionary      ${item}     commitmentDateTime
      ${str_info}=   Split String  ${rx2_info}
      ${Appoint_date1}=  Get From List       ${str_info}   0
      ${Appoint_date2}=      Replace String      ${Appoint_date1}   /    -
      Run keyword if     "${Ticket_type}" == "voice"    Set Global Variable     ${Appoint_date}    ${Appoint_date2}
      ...   ELSE    Set Global Variable       ${Appoint_date}     ${Appoint_date1}
#      Set Global Variable     ${Appoint_date}    ${Appoint_date2}
#      Set Global Variable       ${Appoint_date1}     ${Appoint_date1}
     Log to Console      ${Appoint_date}
     Log to Console      ${Appoint_date1}
     ${Appoint_time1}=  Get From List       ${str_info}   1
     Set Global Variable     ${Appoint_time}    ${Appoint_time1}
     Log to Console      ${Appoint_time}
     ${Appoint_hour_min}=   Split String   ${Appoint_time}   :
     ${Appoint_hour}=  Get From List       ${Appoint_hour_min}   0
     ${Appoint_min}=  Get From List       ${Appoint_hour_min}   1
     ${Appoint_test}=   Convert To Integer   ${Appoint_hour}
     log to console   ${Appoint_test}
     Run Keyword If     ${Appoint_test} == 12      Set Global Variable   ${Updated_time}      ${Appoint_time} PM
      ...   ELSE IF   ${Appoint_test} >= 13    Time Convert   ${Appoint_test}  ${Appoint_min}
     ...  ELSE    Set Global Variable   ${Updated_time}      ${Appoint_time} AM
     ${rx3_info}=    Get From Dictionary      ${item}     createDateTime
     #Log to Console      ${rx3_info}
     ${create_info}=   Split String  ${rx3_info}
     ${create_date1}=  Get From List       ${create_info}   0
     ${create_date2}=      Replace String      ${create_date1}   /    -
     Run keyword if     "${Ticket_type}" == "voice"    Set Global Variable     ${create_date}    ${create_date2}
      ...   ELSE    Set Global Variable     ${create_date}    ${create_date1}
     Log to Console      ${create_date}

Get RXsession and CustomerproductID
    [arguments]     ${product}
    Check the TN type
    ${product}=    Convert To Lower Case   ${product}
    ${Acc_type}=   Convert To Lower Case    ${Acc_type}
    Run Keyword IF     '${product}'=='voice' and '${Acc_type}'=='ensemble'      Set Global Variable    ${pro_type}     VOICE
    ...    ELSE IF     '${product}'=='voice' and '${Acc_type}'=='cris'        Set Global Variable    ${pro_type}     POTS
    ...    ELSE IF     '${product}'=='internet' and '${Acc_type}'=='ensemble'     Set Global Variable    ${pro_type}    HSI
    ...    ELSE IF     '${product}'=='internet' and '${Acc_type}'=='cris'     Set Global Variable    ${pro_type}     IP_DATA
    ${Auth}=     create list        ${username_api}    ${Pwd_api}
    Create Session    mysession     ${Base_Url}    auth=${Auth}
    ${response}=     GET On Session    mysession   ${Productinfo_URL}
    ${rx_info}=    Get From Dictionary      ${response.json()}     rxSessionIdentifier
   # Log to Console      ${rx_info}
    Set Global Variable    ${RXsession}     ${rx_info}
    ${cust_info}=    Get From Dictionary      ${response.json()}     serviceLines
   # log to Console      ${cust_info}
    ${item}=    Get From List       ${cust_info}   0
    ${test_info}=    Get From Dictionary     ${item}      customerProducts
    #log to console    ${test_info}
    ${Cust_list}=   Get length   ${test_info}
    #log to console     ${Cust_list}
    ${Cust_detail}=    Get From List       ${test_info}     0
    Set Global Variable    ${Cust_detail}     ${Cust_detail}
    FOR   ${list}  IN RANGE   ${Cust_list}
        ${Cust_detail}=    Get From List       ${test_info}     ${list}
        ${item_type}=    Get From Dictionary     ${Cust_detail}      highLevelProduct
        #Log to console    ${item_type}
        Run keyword IF    '${pro_type}'=='${item_type}'   set customer product ID
    END

set customer product ID
       #Log to console    ${Cust_detail}
      ${item_Cust_id}=    Get From Dictionary    ${Cust_detail}     customerProductIdentifier
      Set Global Variable    ${CustomerproductID}     ${item_Cust_id}
      #log to console    ${CustomerproductID}

Check the TN type
    ${Auth}=     create list        ${username_api}    ${Pwd_api}
    Create Session    mysession     ${Base_Url}    auth=${Auth}
    ${response}=     GET On Session    mysession   ${Productinfo_URL}
    ${Acc_info}=    Get From Dictionary      ${response.json()}     accountInformation
    ${Tn_Type}=    Get From Dictionary      ${Acc_info}     billingSystem
    Run Keyword IF     '${Tn_Type}'=='L-CTL'     Set Global Variable    ${Acc_type}     Ensemble
    ...    ELSE    Set Global Variable    ${Acc_type}     cris
    #[Return]  ${Tn_Type}