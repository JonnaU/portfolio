*** Settings ***

Library  SeleniumLibrary
Library    OperatingSystem
Library    Collections
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
    # Palautetaan maksiminopeus kun pääsivu on ladattu
    Set Selenium speed    0
    @{tuloslista}    Create list
    # Päivässä on 8 aikajaksoa joten esim 16+1 hakee 2 päivän tapahtumat (max 10 päivää)
    FOR    ${i}    IN RANGE    1    81
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
        Log    Tuulen nopeus puuskissa ${Tuulen_nopeus_puuskissa}    console=True
        #Tuulensuunta
        ${Tuulen_suunta}    Get Element Attribute    (//div[@class='directionarrow icon-direction-solid-grey'])[${i}]    title
        ${Tuulen_suunta}    Palauta asteen ilmansuunta    ${Tuulen_suunta}
        #Lämpätila
        ${Lämpötila}    Get Text    (//span[@class='units-at'])[${i}]
        #Kuinka paljon sataa
        ${Kuinka_paljon_sataa}    Get Text    (//div[@class='data-rain data--minor weathertable__cell'])[${i}]
        Log    Kuinka paljon sataa ${Kuinka_paljon_sataa}    console=True
        #Viedään päivän tulokset listaan
        ${Tunnin_tapahtumat}    Create Dictionary    Lämpötila    ${Lämpötila}   Tuulensuunta    ${Tuulen_suunta}    Tuulen nopeus    ${Tuulen_nopeus_m/s}    Tuulen nopeus puuskissa    ${Tuulen_nopeus_puuskissa}    Sademäärä    ${Kuinka_paljon_sataa}    Päivämäärä    ${Mikä_päivä}    Kellonaika    ${aika}
        Append to list    ${tuloslista}    ${Tunnin_tapahtumat}
      
    END
    Log many    ${tuloslista}    console=True
    Sopivien purjehduskelien haku listasta    ${tuloslista}    ${MINIMITUULI}    ${MAKSIMITUULI}    ${SADEMÄÄRÄ}


*** Keywords ***
Suite Setup
    # Hidastetaan seleniumia
    Set Selenium Speed    0.5 seconds
    # Avataan selain
    Open Browser    https://www.windfinder.com/forecast/siilinkari  chrome

Sopivien purjehduskelien haku listasta
    [Arguments]    ${Sää_lista}    ${Minimituuli}    ${Maksimituuli}    ${Sade_maksimi}
    Set Test Documentation    Annetut reunaehdot säälle:(max tuuli=${Maksimituuli}, min tuuli=${Minimituuli} , max sademäärä=${Sade_maksimi}):${\n}    append=True
    FOR    ${element}    IN    @{Sää_lista}
        Log    ${element['Tuulen nopeus']}
        ${Tuuli_ok}    Set Variable    ${False}
        ${Sade_ok}    Set Variable    ${False}
        IF     (${element['Tuulen nopeus']} >= ${Minimituuli}) and (${element['Tuulen nopeus puuskissa']} <= ${Maksimituuli})
            Log    Tuuli ok
            ${Tuuli_ok}    Set Variable    ${True}
        END
        IF    $element['Sademäärä'] == ''
            Set To Dictionary    ${element}    Sademäärä    0
        END
        IF    $element['Sademäärä'] <= $Sade_maksimi
            Log    Sade ok
            ${Sade_ok}    Set Variable    ${True}
            
        END
        IF    ${Tuuli_ok} and ${Sade_ok}
            Log    Voidaan mennä purjehtimaan
            Log    ${element}
            Log    Annetut reunaehdot täyttyvät (max tuuli=${Maksimituuli}, min tuuli=${Minimituuli} , max sademäärä=${Sade_maksimi})
            Set Suite Documentation    - Sää ok : ${element['Päivämäärä']} - klo ${element['Kellonaika']},Lämpötila ${element['Lämpötila']}°,Tuulensuunta: ${element['Tuulensuunta']}${\n}    append=${True}
        ELSE
            Log    Huono purjehduskeli
        END
        Log    ${element}    console=true
    END

Palauta asteen ilmansuunta
    [Documentation]    Palauttaa annetin asteluvun ${astetta} ilmansuuntana.
    ...    Huomioi että asteluvussa pitää olla asteen merkki
    [Arguments]    ${astetta}
    # Poistataan astemerkki joka on viimeisenä ja muutetaan arvo integeriksi
    ${astetta}    Evaluate    int(${astetta}[0:-1])
    # Taarkastellaan ilmansuunta
    IF    $astetta > 135 and $astetta < 225
        ${astetta}    Set Variable     Tuulee pohjoiseen (${astetta}°)
    ELSE IF    $astetta > 225 and $astetta < 315
        ${astetta}    Set Variable     Tuulee itään (${astetta}°)
    ELSE IF    $astetta > 45 and $astetta < 135
        ${astetta}    Set Variable     Tuulee länteen (${astetta}°)
    ELSE IF    ($astetta > 0 and $astetta < 45) or ($astetta > 315)
        ${astetta}    Set Variable     Tuulee etelään (${astetta}°)
    END
        
        
        
    
    [Return]    ${astetta}