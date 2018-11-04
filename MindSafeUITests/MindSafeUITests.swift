//
//  MindSafeUITests.swift
//  MindSafeUITests
//
//  Created by Mihai Lapuste on 2018-10-24.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//
// Worked on by: Oleg Strbac
// - Created test for version 1 requirements
// - Added additional tests
// Team MindSafe

import XCTest

class MindSafeUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Requirement 1.2
    func testHomePageButtonsTabbar() {
        // Use recording to get started writing UI tests.
        let tabBarsQuery = XCUIApplication().tabBars
        let homeButton = tabBarsQuery.buttons["Home"]
        let remindersButton = tabBarsQuery.buttons["Reminders"]
        let homeStaticText = XCUIApplication().navigationBars["Home"].staticTexts["Home"]
        homeButton.tap()
        XCTAssertTrue(homeStaticText.exists)
        remindersButton.tap()
        remindersButton.tap()
        XCTAssertFalse(homeStaticText.exists)
        homeButton.tap()
        homeButton.tap()
        XCTAssertTrue(homeStaticText.exists)
    }
    
    //Requirement 3.1
    func testNotificationCancelation() {
        let remindersButton = app.tabBars.buttons["Reminders"]
        let addReminderButton = app.navigationBars["MindSafe.RemindersView"].buttons["Add reminder"]
        let cancelButton = app.tables/*@START_MENU_TOKEN@*/.buttons["Cancel"]/*[[".cells.buttons[\"Cancel\"]",".buttons[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        remindersButton.tap()
        remindersButton.tap()
        XCTAssertTrue(addReminderButton.isHittable)
        addReminderButton.tap()
        XCTAssertTrue(cancelButton.isHittable)
        cancelButton.tap()
        XCTAssertTrue(addReminderButton.isHittable)
    }
    
    //Requirement 1.1
    func testSettings() {
        let settingsStaticText = app.staticTexts["settings"]
        let homeButton = app.navigationBars["UIView"].buttons["Home"]
        let settingsButton = app.navigationBars["Home"].buttons["Settings"]
        XCTAssertFalse(settingsStaticText.exists)
        settingsButton.tap()
        XCTAssertTrue(settingsStaticText.exists)
        homeButton.tap()
        XCTAssertFalse(settingsStaticText.exists)
    }
    
    //Requirement 1.1
    func testPanic() {
        let button = app.navigationBars["Home"].children(matching: .button).element(boundBy: 0)
        let alertStaticText = app.staticTexts["ALERT"]
        let homeButton = app.navigationBars["UIView"].buttons["Home"]
        XCTAssertFalse(alertStaticText.exists)
        button.tap()
        XCTAssertTrue(alertStaticText.exists)
        homeButton.tap()
        XCTAssertFalse(alertStaticText.exists)
    }
    
    //Requirement 3.3 and 3.4.1
    func testNotificationCreation() {
        let remindersButton = app.tabBars.buttons["Reminders"]
        remindersButton.tap()
        remindersButton.tap()
        app.navigationBars["MindSafe.RemindersView"].buttons["Add reminder"].tap()
        let titleDescriptionTextField = XCUIApplication().tables/*@START_MENU_TOKEN@*/.textFields["Title & description"]/*[[".cells.textFields[\"Title & description\"]",".textFields[\"Title & description\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        titleDescriptionTextField.tap()
        titleDescriptionTextField.tap()
        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        tKey.tap()
        let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        iKey.tap()
        let nKey = app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["g"]/*[[".keyboards.keys[\"g\"]",".keys[\"g\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".cells.buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let text = XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["testing"]/*[[".cells.staticTexts[\"testing\"]",".staticTexts[\"testing\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(text.exists)
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["testing"]/*[[".cells.staticTexts[\"testing\"]",".staticTexts[\"testing\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        XCTAssertFalse(text.exists)
    }
    
}
