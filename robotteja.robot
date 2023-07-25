*** Settings ***

Library  ./test.py
Library  ./kutsut.py
Library  SeleniumLibrary
Library  Collections

*** Test Cases ***
	
Mene työvoimatoimiston sivulle
    Set Selenium Speed    0.4 seconds
    Open Browser    https://paikat.te-palvelut.fi/tpt/    chrome
    Capture Page Screenshot
    Click Link    Hyväksy vain välttämättömät
    #Tehdään haku
    Input Text    sanahaku    Python
    Input Text    id:alueet    Pirkanmaa
    Press Keys    None    RETURN

    Sleep    0.5
    Click Element    id:searchButton    #//*[@id="searchButton"]
    Capture Page Screenshot
    #Tehdään lista
    ${MontakoPaikkaa}    Get Text    //span[@class="badge adCount"]
    Log    Haulla löytyi ${MontakoPaikkaa} paikkaa.    console=True
    ${Paikat}    Get Text    id:groupedList
    Set test documentation    ${Paikat}
    ${Määrä}    Get Element Count    //span[@class="listItemId"]
    Log    Paikkoja löytyi ${Määrä}.    console=True
    Should be true    ${MontakoPaikkaa} == ${Määrä}
    @{lista}    Create List    
    FOR    ${i}    IN RANGE     1    ${Määrä + 1}
        ${linkki}    Get Element Attribute    (//tpt-resultlist//a)[${i}]    href
        ${kohteen_teksti}    Get Text    (//tpt-resultlist//a)[${i}]
        Append To List    ${lista}    ${linkki}  
        Log    ${linkki}    console=True
        Log    ${kohteen_teksti}    console=True 
    END
    Log List    ${lista}
    #Selataan työpaikkailmoituksia
    FOR    ${linkki}    IN    @{lista}
        Go to    ${linkki}
        Click Element    //a[contains(text(),'Tiedot')]
        ${palkkaus}    Get Text    //span[contains(text(),'Palkkaus')]/../..
        Log    Työn ${palkkaus} ja linkki ${linkki}    console=True
    END

Mennään Duunitorin sivuille
    #Haetaan paikat
    Set Selenium Speed    0.4 seconds
    Open Browser    https://duunitori.fi/    chrome   
    Click Button    Hyväksy evästeet
    Capture Page Screenshot
    Input Text    (//input[@type="search"])[1]   Python
    Input Text    (//input[@type="search"])[2]   Tampere
    Press Keys    None    RETURN
    Capture Page Screenshot
    #Tehdään listaa
    ${MääräD}    Get Text    //h5/b
    Log    Duunitorilla paikkoja löytyi ${MääräD}.    console=True
    ${SivuMäärä}=    Evaluate    round(${MääräD}/20)
    Log    ${SivuMäärä}    console=True
    ${indeksi}    set variable    1
    FOR    ${i}    IN RANGE    1    ${MääräD}
        Log    ${i}    console=True
        ${Dammatti_teksti}    Get Text    (//a[@data-id])[${indeksi}]
        ${Dyritys_teksti}    Get Element Attribute    (//a[@data-id])[${indeksi}]    data-company
        ${indeksi}    Evaluate    int(${indeksi})+1
        Log    ${Dammatti_teksti}    console=True
        Log    ${Dyritys_teksti}    console=True
        IF    ${indeksi} == 21     
            Klikkaa kunnes onnistuu    //a/img[@alt="Seuraava sivu"]
            Run Keyword And Return Status    Klikkaa jos elementti on sivulla    //a[contains(text(),'Ei kiitos')]
            ${indeksi}=    Set Variable     1
        END
        Log    ${indeksi}    console=True

    END
    #Selataan työpaikkailmoituksia
    Sleep    10

lista työpaikoista
    ${ListaTYö}    työpaikat


*** Keywords ***
Klikkaa kunnes onnistuu
    [Documentation]    Klikataan elementtiä kolme kertaa 200ms välein kunnes klikkaus onnistuu
    [Arguments]    ${locator}
    Wait Until Keyword Succeeds    	3x    200ms    Click Element    ${locator}

Klikkaa jos elementti on sivulla
    [Documentation]    Klikkaa elementtiä vain jos se on olemassa
    [Arguments]    ${locator}
    ${count}    Get Element count    ${locator}
    Run Keyword If    ${count} > 0    Click element    ${locator}   