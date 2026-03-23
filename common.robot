*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}           https://parking-garage-app.netlify.app/
${BROWSER}       chrome

*** Keywords ***
Open Browser And Load Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains   Parking Garage    10s