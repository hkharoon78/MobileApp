//
//  MonsteriOSUITests.swift
//  MonsteriOSUITests
//
//  Created by Monster on 15/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import XCTest

class MonsteriOSUITests: XCTestCase {

    var app: XCUIApplication!
    
    var appTest : XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        
        appTest = XCUIApplication()
        appTest.launch()
        // XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogout() {
        
        app.tabBars.buttons["More"].twoFingerTap()
        
        let tablesQuery = app.tables
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Settings"]/*[[".cells.staticTexts[\"Settings\"]",".staticTexts[\"Settings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Signout"]/*[[".cells.staticTexts[\"Signout\"]",".staticTexts[\"Signout\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
        app.alerts["Logout"].buttons["OK"].twoFingerTap()
    }
    

    func testLogin() {
        
        let loginButton = app.buttons["Login"]
        loginButton.twoFingerTap()
        
        let tablesQuery = app.tables
        let emailPhoneNumberTextField = tablesQuery.textFields["Email / Phone Number"]
        emailPhoneNumberTextField.tap()
        emailPhoneNumberTextField.typeText("anupam.katiyar@monsterindia.com")

        let passwordTextField = tablesQuery.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        tablesQuery.buttons["Login"].twoFingerTap()
        
        sleep(10)

//        app.tabBars.buttons["More"].twoFingerTap()
//        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Settings"]/*[[".cells.staticTexts[\"Settings\"]",".staticTexts[\"Settings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
//        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Signout"]/*[[".cells.staticTexts[\"Signout\"]",".staticTexts[\"Signout\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
//        app.alerts["Logout"].buttons["OK"].twoFingerTap()
    }
    

    func testLoginViaMobile() {
    
        app.buttons["Login"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        
        let emailPhoneNumberTextField = tablesQuery.textFields["Email / Phone Number"]
        emailPhoneNumberTextField.tap()
        emailPhoneNumberTextField.typeText("7042804960")
        
        let countryCode = tablesQuery.textFields["code"]
        countryCode.tap()
        tablesQuery.staticTexts["India - IN"].tap()
        
        let passwordTextField = tablesQuery.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        tablesQuery.buttons["Login"].twoFingerTap()
        
        sleep(5)
    }
    
    func testLoginViaOTP() {

        app.buttons["Login"].tap()
        app.buttons["Login Via OTP"].tap()
        
        let tblQuery = app.tables
        let code = tblQuery.textFields["Email / Phone Number"]
        code.tap()
        code.typeText("7042804960")
        code.typeText("7042804960")
    }
    
    func testForgotPassword() {
        
        app.buttons["Login"].tap()

        app.tables.buttons["Forgot Password ?"].tap()
        sleep(2)

        let tf = app.textFields.element(matching: .textField, identifier: nil)
        tf.tap()
        tf.typeText("anupam.katiyar@monsterindia.com")
        app.buttons["Next"].tap()

        sleep(5)
    }

    func testVoiceSearch() {
        
        if app.buttons["Skip"].isVisible {
            app.buttons["Skip"].tap()
            waitForExpectations(timeout: 5, handler: nil)
        }
        if app.navigationBars["Home"].buttons["mic"].isVisible {
            app.navigationBars["Home"].buttons["mic"].tap()
        }
        if app.alerts["“Monster Jobs” Would Like to Access Speech Recognition"].isVisible {
            app.alerts["“Monster Jobs” Would Like to Access Speech Recognition"].buttons["OK"].tap()
        }
        sleep(10)
    }
   
    func testSignUp(){
        
    }
    
    func testFeedback() {
        app.tabBars.buttons["More"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Feedback"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Select"].tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["General Feedback"]/*[[".otherElements[\"drop_down\"].tables",".cells.staticTexts[\"General Feedback\"]",".staticTexts[\"General Feedback\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        
        let textView = elementsQuery.children(matching: .textView).element
        textView.tap()
        textView.typeText("Test Fedback")
        
        app.buttons["return"].tap()
        
        app.buttons["Submit"].tap()
    }
    
    func testSiteChange() {
        
        app.tabBars.buttons["More"].tap()
        
        let tablesQuery = app.tables
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Settings"]/*[[".cells.staticTexts[\"Settings\"]",".staticTexts[\"Settings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.staticTexts["Change Country"].tap()
        tablesQuery.staticTexts["India"].tap()
    }
    
    func testBasicRegistration() {
        XCTAssertTrue(app.buttons["Register"].exists)
        app.buttons["Register"].tap()
        self.testRegistrationFields()
        
    }

    func testRegistrationFields() {
        let tablesQuery = app.tables
       
        let fullName = tablesQuery.textFields["Full Name"]
        fullName.tap()
        fullName.typeText("Rakesh Bajeli")
        
        let email = tablesQuery.textFields["E-mail Id"]
        email.tap()
        email.typeText("mtest65@mailinator.com")
        
        let password = tablesQuery.secureTextFields["Password"]
        password.tap()
        password.typeText("qqqqqq")
        
        let mblNumber = tablesQuery.textFields["Mobile Number"]
        mblNumber.tap()
        mblNumber.typeText("873453535")

        //let registervcTableTable = app.tables["RegisterVC_Table"]
        tablesQuery.staticTexts["Current Location"].tap()

    }
    

}


extension XCUIElement {
    
    public var isVisible: Bool {
        return exists && !frame.isEmpty && XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
    
}

