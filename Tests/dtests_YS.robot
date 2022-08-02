*** Settings ***
Library         SeleniumLibrary
Library         BuiltIn
Library         String

*** Variables ***
${base_url}    https://www.directferries.co.uk
${browser}    chrome

*** Test Cases ***
Changing Language on the Special Offers Page
    [Documentation]    We check when a user changes language to another on the Special Offers page:
    ...    1) The user is redirected to the main page
    ...    2) The language of the page has changed (Search button and lang attribute in html tag)
    ...    3) The URL of the page has changed
    [Setup]    Open Browser and Maximaze Window
    Open Special Offers
    FOR    ${new_lang}      ${new_lang_id}    ${new_search}     ${new_url}    IN
    ...    Italia           it                Cerca             www.directferries.it
    ...    United States    en-us             Search            www.directferries.com
    ...    Portugal         pt                Pesquisar         www.directferries.pt
    ...    المغرب             ar                بحث                ar.directferries.ma
    ...    France           fr                Rechercher        www.directferries.fr
    ...    Australia        en                Search            www.directferries.com.au
        Setting Variables    ${new_lang}      ${new_lang_id}    ${new_search}    ${new_url}
        Language Change
        Checking New Language
        Checking New Url
        Go Back
    END
    [Teardown]    Close Browser

Calais - Dover
    [Setup]    Open Browser and Maximaze Window
    Input Text    //input[@id='route_outbound']    Calais Dover
    Wait Until Element Is Visible    //li[@data-routename='Calais - Dover']    15s
    Click Element    //li[@data-routename='Calais - Dover']
    mk.Click Element    //span[text()='How are you travelling?']
    mk.Click Element    //label[text()='Car']
    mk.Click Element    //label[text()='Aston Martin']
    mk.Click Element    //label[text()='DB11']
    Js Click Element    //button[text()='Done']
    Js Click Element    //button[@data-orig-txt='Search']
    Wait Until Element Is Visible    //span[text()='Continue']   20s
    Click Element    //span[text()='Continue']
    Wait Until Element Is Visible    //h1[text()='Calais - Dover']   20s
    [Teardown]    Close Browser

*** Keywords ***
mk.Click Element
    [Arguments]    ${xpath}
    Wait Until Keyword Succeeds    5s    1s     Click Element    ${xpath}

Open Special Offers
    Wait Until Keyword Succeeds    5s    1s     Click Element    //*[@id='main-nav-content']//a[text()='Special offers']

Open Browser and Maximaze Window
    Open Browser    ${base_url}    ${browser}
    Maximize Browser Window

Setting Variables
    [Arguments]    ${new_lang}    ${new_lang_id}    ${new_search}    ${new_url}
    Set Test Variable    ${new_lang}
    Set Test Variable    ${new_lang_id}
    Set Test Variable    ${new_search}
    Set Test Variable    ${new_url}

Checking New Language
    Wait Until Element Is Visible    //button[@type='submit' and text()='${new_search}']    15s
    Page Should Contain Element     //html[@lang='${new_lang_id}']

Checking New Url
    ${current_url}    Get Location
    ${current_url}   Fetch From Left    ${current_url}    /?dfutm
    ${current_url}   Fetch From Right    ${current_url}    https://
    Should Be Equal As Strings    ${current_url}    ${new_url}

Language Change
    Js Click Element    //a[@id='lang']
    Wait Until Element Is Visible    //li[@class='lang open']//a[text()='${new_lang}']    15s
    Click Element    //li[@class='lang open']//a[text()='${new_lang}']

Js Click Element
    [Arguments]    ${xpath}
    Execute JavaScript    document.evaluate("${xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,
    ...    null).snapshotItem(0).click();
