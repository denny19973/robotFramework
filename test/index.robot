*** Settings ***
Library           SeleniumLibrary
Library    random
Resource          ../resources/variables.robot
Resource          ../resources/keywords.robot
Test Setup       Open Browser To Homepage
Test Teardown    Close Browser

*** Test Cases ***
#TC_01 註冊新帳號成功
Register New Account Successfully
    [Tags]    register
    Go To Login Page
    Wait Until Element Is Visible    xpath=//h2[text()='New User Signup!']
    Input Text    xpath=//*[@id="form"]/div/div/div[3]/div/form/input[2]       ${USER_NAME}
    Input Text    xpath=//*[@id="form"]/div/div/div[3]/div/form/input[3]      ${EMAIL}

    Click Button  xpath=//button[text()='Signup']
    Wait Until Element Is Visible    xpath=//b[text()='Enter Account Information']

    # 填寫帳號資訊
    Click Element      id=id_gender1
    Input Text         id=password      ${PASSWORD}
    Select From List By Value    id=days      10
    Select From List By Value    id=months    5
    Select From List By Value    id=years     1990
    Click Element      id=newsletter
    Click Element      id=optin

    Input Text    id=first_name    Test
    Input Text    id=last_name     User
    Input Text    id=address1      123 Test Street
    Select From List By Value    id=country    Canada
    Input Text    id=state         Ontario
    Input Text    id=city          Toronto
    Input Text    id=zipcode       12345
    Input Text    id=mobile_number    0912345678

    Click Button  xpath=//button[text()='Create Account']

    Wait Until Page Contains    Account Created!
#TC_02 登入成功並顯示使用者名稱
Login Successfully And Display Username
    [Tags]    login successful
    Go To Login Page
    Wait Until Element Is Visible    xpath=//h2[text()='Login to your account']
    Enter invalid login information    ${EMAIL}    ${PASSWORD}
    Click Login
    Wait Until Page Contains    Logged in as ${USER_NAME}

#TC_03 登入失敗顯示錯誤訊息
Login failed and error message is displayed
    [Tags]    login failed
    Go To Login Page
    Enter invalid login information    test123@gmail.com    test456
    Click Login
    Page Should Contain    Your email or password is incorrect!

#TC_04 將產品加入購物車並驗證
Add product to cart and verify
    [Tags]    add to the cart
    Hover And Click Add To Cart
    Wait Until Element Is Visible    xpath=//u[text()='View Cart']
    Click on the shopping cart
    Wait Until Page Contains Element    xpath=//tr[@id='product-1']

    ${product_name}=    Get Text    xpath=//*[@id="product-1"]/td[2]/h4/a
    ${product_price}=   Get Text    xpath=//*[@id="product-1"]/td[3]/p
    ${product_qty}=     Get Text    xpath=//*[@id="product-1"]/td[4]/button

    Should Be Equal    ${product_name}    Blue Top
    Should Be Equal    ${product_price}   Rs. 500
    Should Be Equal    ${product_qty}     1

#TC_05 搜尋功能正常
Search Product And Verify Results
    [Tags]    search
    Click Link    /products
    Input Text    xpath=//input[@id='search_product']    Jeans
    Click Button  xpath=//button[@id='submit_search']
    Wait Until Page Contains Element    xpath=//div[@class='features_items']

    ${product_names}=    Get WebElements    xpath=//div[@class='productinfo text-center']/p
    FOR    ${name}    IN    @{product_names}
        ${text}=    Get Text    ${name}
        Should Contain    ${text.lower()}    jeans
    END

#TC_06 從購物車中刪除產品
Delete Product From Cart
    [Tags]    Shopping cart delete
    Hover And Click Add To Cart    
    Wait Until Element Is Visible    xpath=//u[text()='View Cart']
    Click on the shopping cart
    Wait Until Page Contains Element    xpath=//tr[@id='product-1']
    Click Element    xpath=//*[@id="product-1"]/td[6]/a
    Wait Until Page Does Not Contain Element    xpath=//tr[@id='product-1']
    Page Should Contain    Cart is empty!

#TC_07 聯絡表單提交成功
Contact Form Submit Success
    [Tags]    contact
    Click Link    /contact_us
    Wait Until Element Is Visible    xpath=//h2[text()='Get In Touch']
    Input Text    name=name          Test User
    Input Text    name=email         test123@gmail.com
    Input Text    name=subject       123456789
    Input Text    id=message         This is a test message.
    Click Button  xpath=//input[@name='submit']
    Handle Alert    accept
    Wait Until Page Contains    Success! Your details have been submitted successfully.

#TC_08 商品詳情頁顯示正確資訊
Product Detail Page Display
    [Tags]    product
    Click Element    xpath=(//div[@class='choose'])[1]
    Wait Until Page Contains Element    xpath=//div[@class='product-information']
    
    Page Should Contain Element    xpath=//h2[contains(text(), '')]    # 商品名稱
    Page Should Contain Element    xpath=//span[contains(text(),'Rs.')]    # 價格
    Page Should Contain Element    xpath=//p[contains(text(),'Category')]    # 類別
    Page Should Contain Element    xpath=//b[contains(text(),'Availability:')]    # 庫存
    Page Should Contain Element    xpath=//b[contains(text(),'Condition')]    # 新舊狀態

#TC_09 成功完成結帳流程
Complete Checkout Successfully
    [Tags]    checkout
    Go To Login Page
    Enter invalid login information    ${EMAIL}    ${PASSWORD}
    Click Login
    #使用 JS 點擊，避免與畫面互動
    Execute JavaScript    document.querySelectorAll("a.btn.add-to-cart")[0].click()
    Wait Until Element Is Visible    xpath=//u[text()='View Cart']
    Click on the shopping cart

    # 點選 Checkout
    Wait Until Page Contains Element    xpath=//a[text()='Proceed To Checkout']
    Click Element    xpath=//a[text()='Proceed To Checkout']
    # 確認地址與留言
    Wait Until Page Contains    Review Your Order
    Input Text    name=message    Please deliver ASAP
    Click Element    xpath=//a[text()='Place Order']
    # 輸入付款資訊
    Input Text    name=name_on_card      Test User
    Input Text    name=card_number       4111111111111111
    Input Text    name=cvc               123
    Input Text    name=expiry_month      12
    Input Text    name=expiry_year       2026
    Click Button  xpath=//button[text()='Pay and Confirm Order']

    Wait Until Page Contains    Order Placed!

#TC_10 帳號刪除成功
Delete Account Successfully
    [Tags]    delete
    Go To Login Page
    Enter invalid login information    ${EMAIL}    ${PASSWORD}
    Click Login

    Click Element    xpath=//a[contains(text(),'Delete Account')]
    Wait Until Page Contains    Account Deleted!
    Click Element    xpath=//a[text()='Continue']

    Wait Until Page Contains    Account Deleted!