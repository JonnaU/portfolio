*** Settings ***

Library  SeleniumLibrary
Library    OperatingSystem
Library    Collections
Variables    muuttujat.py
Suite Setup    Suite Setup

*** Variables ***
#Reunaehdot
${MINIMITUULI}    2
${MAKSIMITUULI}    6
${SADEMÄÄRÄ}    0    #maksimi sallittu määrä

*** Test Cases ***

Haetaan Siilinkarin säätiedot
    Click Element    id:accept-choices
    #Vaihdetaan tuulen nopeus m/s
    Click Element    //span[contains(text(),'Settings')]
    Click Element    //button[contains(text(),'m/s')]
    Click Element    //span[contains(text(),'Settings')]
    #Tutkitaan paljonko säätä 
    ${indeksi}    set variable    1
    ${indeksiMax}    set variable    2
    ${Päivän_indeksi}    set variable    1
    ${Ajan_indeksi}    set variable    0
    @{ajankohdat}    Create List    00    03    06    09    12    15    18    21
    Set Selenium speed    0
    @{tuloslista}    Create list
    FOR    ${i}    IN RANGE    1    17
        ${Päivän_indeksi}    Evaluate    math.ceil(int(${i})/8)
        ${Mikä_päivä}    Get Text    (//h3[@class="h h--4 weathertable__headline"])[${Päivän_indeksi}]
        Log    Tänään on ${Mikä_päivä}    console=true
        ${aika}    Set Variable    ${ajankohdat}[${Ajan_indeksi}]
        Log    Ajankohta ${aika}    console=True
        IF    ${Ajan_indeksi} == 7    
            ${Ajan_indeksi}    set Variable    0
        ELSE
            ${Ajan_indeksi}    Evaluate    int(${Ajan_indeksi})+1
        END
        #Tuulen nopeus
        ${Tuulen_nopeus_m/s}    Get Text    (//span[@class="units-ws"])[${indeksi}]
        ${indeksi}    Evaluate    int(${indeksi})+2
        Log    Tuulen nopeus ${Tuulen_nopeus_m/s}    console=True
        #Tuulen nopeus puuskissa
        ${Tuulen_nopeus_puuskissa}    Get Text    (//span[@class="units-ws"])[${indeksiMax}]
        ${indeksiMax}    Evaluate    int(${indeksiMax})+2
        Log    Tuueln nopeus puuskissa ${Tuulen_nopeus_puuskissa}    console=True
        #Kuinka paljon sataa
        ${Kuinka_paljon_sataa}    Get Text    (//div[@class='data-rain data--minor weathertable__cell'])[${i}]
        Log    Kuinka paljon sataa ${Kuinka_paljon_sataa}    console=True
        #Viedään päivän tulokset listaan
        ${Tunnin_tapahtumat}    Create Dictionary    Tuulen nopeus    ${Tuulen_nopeus_m/s}    Tuulen nopeus puuskissa    ${Tuulen_nopeus_puuskissa}    Sademäärä    ${Kuinka_paljon_sataa}    Päivämäärä    ${Mikä_päivä}    Kellonaika    ${aika}
        Append to list    ${tuloslista}    ${Tunnin_tapahtumat}
      
    END
    Log many    ${tuloslista}    console=True

Listan läpikäynti
    Set Test Documentation    Annetut reunaehdot säälle:(max tuuli=${MAKSIMITUULI}, min tuuli=${MINIMITUULI} , max sademäärä=${SADEMÄÄRÄ}):${\n}    append=True
    FOR    ${element}    IN    @{esimerkkilista}
        Log    ${element['Tuulen nopeus']}
        ${Tuuli_ok}    Set Variable    ${False}
        ${Sade_ok}    Set Variable    ${False}
        IF     (${element['Tuulen nopeus']} >= ${MINIMITUULI}) and (${element['Tuulen nopeus puuskissa']} <= ${MAKSIMITUULI})
            Log    Tuuli ok
            ${Tuuli_ok}    Set Variable    ${True}
        END
        IF    $element['Sademäärä'] == ''
            Set To Dictionary    ${element}    Sademäärä    0
        END
        IF    $element['Sademäärä'] <= $SADEMÄÄRÄ
            Log    Sade ok
            ${Sade_ok}    Set Variable    ${True}
            
        END
        IF    ${Tuuli_ok} and ${Sade_ok}
            Log    Voidaan mennä purjehtimaan
            Log    ${element}
            Log    Annetut reunaehdot täyttyvät (max tuuli=${MAKSIMITUULI}, min tuuli=${MINIMITUULI} , max sademäärä=${SADEMÄÄRÄ})
            Set Test Documentation    - Sää ok : ${element['Päivämäärä']} - klo ${element['Kellonaika']}${\n}    append=${True}
        ELSE
            Log    Huono purjehdus keli
        END
        Log    ${element}    console=true
    END

*** Keywords ***
Suite Setup

    # Avataan selain
    Set Selenium Speed    0.5 seconds
    Open Browser    https://www.windfinder.com/forecast/siilinkari  chrome