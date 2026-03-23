*** Settings ***
Library           SeleniumLibrary

Suite Setup       Open Browser   https://parking-garage-app.netlify.app/    Chrome
Suite Teardown    Close Browser

*** Variables ***
${VALID_USER}         admin
${VALID_PASSWORD}     admin123
${INVALID_USER}       notexist
${INVALID_PASSWORD}   wrongpass

*** Test Cases ***
Sikeres bejelentkezes ervenyes felhasznalonevvel es jelszoval
    [Tags]    login
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${VALID_PASSWORD}
    Click Button    id=login-btn
    Wait Until Page Contains Element    id=logout-btn

Sikertelen bejelentkezes hibas jelszo eseten
    [Tags]    login
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${INVALID_PASSWORD}
    Click Button    id=login-btn
    Wait Until Page Contains    Hibás felhasználónév vagy jelszó

Sikertelen bejelentkezes nem letezo felhasznaloval
    [Tags]    login
    Input Text    id=username    ${INVALID_USER}
    Input Text    id=password    ${INVALID_PASSWORD}
    Click Button    id=login-btn
    Wait Until Page Contains    Hibás felhasználónév vagy jelszó

Kotelezo mezok ellenorzese ures bejelentkezesi adatoknal
    [Tags]    login
    Click Button    id=login-btn
    Wait Until Page Contains    A felhasználónév megadása kötelező
    Wait Until Page Contains    A jelszó megadása kötelező

Hibauzenet helyes megjelenitese sikertelen bejelentkezesnel
    [Tags]    login
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${INVALID_PASSWORD}
    Click Button    id=login-btn
    Wait Until Page Contains Element    css=.alert-danger

Kijelentkezes utan vedett oldalak eleresenek tiltasa
    [Tags]    login
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${VALID_PASSWORD}
    Click Button    id=login-btn
    Wait Until Page Contains Element    id=logout-btn
    Click Button    id=logout-btn
    Go To    http://localhost:5173/dashboard
    Wait Until Page Contains    Bejelentkezés szükséges

Sikeres uj auto felvitele (happy path)
    [Tags]    car
    Login As Valid User
    Click Button    id=new-car-btn
    Input Text    id=plate    ABC-123
    Input Text    id=brand    Toyota
    Input Text    id=model    Corolla
    Click Button    id=save-car-btn
    Wait Until Page Contains    Sikeres mentés

Kotelezo mezok ellenorzese mentes elott
    [Tags]    car
    Login As Valid User
    Click Button    id=new-car-btn
    Click Button    id=save-car-btn
    Wait Until Page Contains    A rendszám megadása kötelező

Hibasan megadott rendszam formatum kezelese
    [Tags]    car
    Login As Valid User
    Click Button    id=new-car-btn
    Input Text    id=plate    123-ABC
    Click Button    id=save-car-btn
    Wait Until Page Contains    Hibás rendszám formátum

Duplikalt rendszam mentesenek kezelese
    [Tags]    car
    Login As Valid User
    Click Button    id=new-car-btn
    Input Text    id=plate    ABC-123
    Input Text    id=brand    Toyota
    Input Text    id=model    Corolla
    Click Button    id=save-car-btn
    Wait Until Page Contains    Már létezik ilyen rendszám

Auto adatainak sikeres modositasa
    [Tags]    car
    Login As Valid User
    Click Button    xpath=//tr[td[text()='ABC-123']]/td/button[@class='edit-btn']
    Input Text    id=model    Corolla Hybrid
    Click Button    id=save-car-btn
    Wait Until Page Contains    Sikeres mentés

Torles megerosito ablakkal
    [Tags]    car
    Login As Valid User
    Click Button    xpath=//tr[td[text()='ABC-123']]/td/button[@class='delete-btn']
    Wait Until Page Contains Element    id=confirm-delete-modal

Torles megszakitasa (Megse folyamattal)
    [Tags]    car
    Login As Valid User
    Click Button    xpath=//tr[td[text()='ABC-123']]/td/button[@class='delete-btn']
    Click Button    id=cancel-delete-btn
    Wait Until Page Does Not Contain Element    id=confirm-delete-modal

Megerosito ablak gombjainak helyes mukodese
    [Tags]    car
    Login As Valid User
    Click Button    xpath=//tr[td[text()='ABC-123']]/td/button[@class='delete-btn']
    Click Button    id=confirm-delete-btn
    Wait Until Page Contains    Sikeres törlés

*** Keywords ***
Login As Valid User
    Go To    https://parking-garage-app.netlify.app/n
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${VALID_PASSWORD}
    Click Button    id=login-btn
    Wait Until Page Contains Element    id=logout-btn