*** Comments ***
Testit esimerkki sivustolle http://timvroom.com/selenium/playground/
Joka on tehty automaatiotestauksen harjoittelemiseen
*** Settings ***
Library  SeleniumLibrary
Library    OperatingSystem
Suite Setup    Suite Setup
Test Teardown    Test Teardown
Suite Teardown    Suite Teardown

*** Test Cases ***

Testi 1 
    [Documentation]    Grab page title and place title text in answer slot #1
    ${Teksti_1}    Get Title
    Input Text    id:answer1    ${Teksti_1}
    
Testi 2
    [Documentation]     Fill out name section of form to be Kilgore Trout
    Input Text    id:name    Kilgore Trout

Testi 3
    [Documentation]    Set occupation on form to Sci-Fi Author
    Select From List By Value    id:occupation    scifiauthor

Testi 4
    [Documentation]    Count number of blue_boxes on page after form and enter into answer box #4
    ${Sinisten_laatikoiden_kpl}    Get Element Count    //span[@class="bluebox"]
    Input Text    id:answer4    ${Sinisten_laatikoiden_kpl}

Testi 5
    [Documentation]    Click link that says 'click me'
    Click Link    click me

Testi 6
    [Documentation]    Find red box on its page find class applied to it, and enter into answer box #6
    ${Punaisen_luokka}    Get Element Attribute   id:redbox    class
    Input Text    id:answer6    ${Punaisen_luokka}

Testi 7
    [Documentation]    Run JavaScript function as: ran_this_js_function() from your Selenium script
    Execute Javascript      ran_this_js_function()

Testi 8
    [Documentation]    Run JavaScript function as: got_return_from_js_function() from your Selenium script, 
    ...    take returned value and place it in answer slot #8
    ${Vastaus8}    Execute Javascript    return got_return_from_js_function()
    Input Text    id:answer8    ${Vastaus8}

Testi 9
    [Documentation]    Mark radio button on form for written book? to Yes
    Select Radio Button    wrotebook    wrotebook
Testi 10
    [Documentation]    Get the text from the Red Box and place it in answer slot #10
    ${Punaisen_vastaus}    Get Text    //*[@id="redbox"]
    Input Text    id:answer10    ${Punaisen_vastaus}

Testi 11
    [Documentation]    Which box is on top? orange or green -- place correct color in answer slot #11
    ${y_orange}    Get Vertical Position    id:orangebox
    ${y_green}    Get Vertical Position    id:greenbox
    Log    ${y_green} ja ${y_orange}
    IF    ${y_green} > ${y_orange}
        Input Text    id:answer11     orange   
    ELSE
        Input Text    id:answer11     green
    END

Testi 12
    [Documentation]    Set browser width to 850 and height to 650
    Set Window Size    850    650

Testi 13
    [Documentation]    Type into answer slot 13 yes or no depending on whether item by id of ishere is on the page
    ${Onko_elementtiä}    Get Element Count    id:ishere
    IF    ${Onko_elementtiä} > 0
        Input Text    id:answer13   yes
    ELSE
        Input Text    id:answer13   no
    END

Testi 14
    [Documentation]    Type into answer slot 14 yes or no depending on whether item with id of purplebox is visible 
    ${Onko_laatikkoa}    Run Keyword And Return Status     Element Should Be Visible    id:purplebox
    Log    ${Onko_laatikkoa}    console=true
    IF    ${Onko_laatikkoa}
        Input Text    id:answer14   yes
    ELSE
        Input Text    id:answer14   no
    END

Testi 15
    [Documentation]    Waiting game: click the link with link text of 'click then wait' a random wait 
    ...    will occur (up to 10 seconds) and then a new link will get added with link text of 
    ...    'click after wait' - click this new link within 500 ms of it appearing to pass this test 
    [Teardown]    No Operation
    Click Element    //a[contains(text(),'click then wait')]
    Wait Until Element Is Visible    //a[contains(text(),'click after wait')]    10
    Click Element    //a[contains(text(),'click after wait')]

Testi 16
    [Documentation]    Click OK on the confirm after completing task 15 
    Handle Alert     ACCEPT   	15 s

Testi 17
    [Documentation]    Click the submit button on the form 
    Click Element    id:submitbutton

*** Keywords ***
Suite Setup
    # Avataan selain
    #Set Selenium Speed    0.5 seconds
    Remove File    *.png
    Open Browser    http://timvroom.com/selenium/playground/  chrome

Test Teardown
    Capture Page Screenshot    ${TEST_NAME}.png

Suite Teardown
    Click Element    id:checkresults
    Click Element    id:tophead
    Capture page Screenshot   Testin_tulokset.png