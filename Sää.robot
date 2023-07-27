*** Settings ***

Library  SeleniumLibrary
Suite Setup    Suite Setup

*** Test Cases ***

Haetaan Siilinkarin säätiedot
    Click Element    id:accept-choices
    #Tutkitaan paljonko kts on 
    ${indeksi}    set variable    1
    FOR    ${i}    IN RANGE    16
        ${Tuulen_nopeus_kts}    Get Text    (//span[@class="units-ws"])[${indeksi}]
        ${indeksi}    Evaluate    int(${indeksi})+2
        Capture Page Screenshot
        Log    ${Tuulen_nopeus_kts}    console=True
    END

*** Keywords ***
Suite Setup
    # Poistetaan vanhat screenshotit
    # Avataan selain
    Set Selenium Speed    0.5 seconds
    Open Browser    https://www.windfinder.com/forecast/siilinkari  chrome