*** Settings ***
Library           SeleniumLibrary

Suite Setup       Open Browser   https://parking-garage-app.netlify.app/    Chrome
Suite Teardown    Close Browser

*** Variables ***
${VALID_USER}         admin
${LOGIN_BUTTON_CLASS}     css=.button.primary.svelte-amvzu1
${REGISTER_BUTTON_CLASS}  css=.button.secondary.svelte-amvzu1
${VALID_PASSWORD}     admin123
${INVALID_USER}       notexist
${INVALID_PASSWORD}   wrongpass

*** Test Cases ***
Sikeres bejelentkezes ervenyes felhasznalonevvel es jelszoval
    [Tags]    login
    Click Button    class = ${LOGIN_BUTTON_CLASS}"
    Input Text    id=email   ${VALID_USER}
    Input Text    id=password    ${VALID_PASSWORD}
    Wait Until Page Contains Element    "Parkolóház"

Sikertelen bejelentkezes hibas jelszo eseten
    [Tags]    login
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${INVALID_PASSWORD}
    Click Button    class = ${LOGIN_BUTTON_CLASS}
    Wait Until Page Contains    Hibás felhasználónév vagy jelszó

Sikertelen bejelentkezes nem letezo felhasznaloval
    [Tags]    login
    Input Text    id=username    ${INVALID_USER}
    Input Text    id=password    ${INVALID_PASSWORD}
    Click Button    class = ${LOGIN_BUTTON_CLASS}
    Wait Until Page Contains    Hibás felhasználónév vagy jelszó

Kotelezo mezok ellenorzese ures bejelentkezesi adatoknal
    [Tags]    login
    Click Button    class = ${LOGIN_BUTTON_CLASS}
    Wait Until Page Contains    A felhasználónév megadása kötelező
    Wait Until Page Contains    A jelszó megadása kötelező

Hibauzenet helyes megjelenitese sikertelen bejelentkezesnel
    [Tags]    login
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${INVALID_PASSWORD}
    Click Button    class = ${LOGIN_BUTTON_CLASS}
    Wait Until Page Contains Element    css=.alert-danger

Kijelentkezes utan vedett oldalak eleresenek tiltasa
    [Tags]    login
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${VALID_PASSWORD}
    Click Button    class = ${LOGIN_BUTTON_CLASS}
    Wait Until Page Contains Element    id=logout-btn
    Click Button    id=logout-btn
    Go To    http://localhost:5173/dashboard
    Wait Until Page Contains    Bejelentkezés szükséges

