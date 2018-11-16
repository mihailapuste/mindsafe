//
//  MindSafeUITests.swift
//  MindSafeUITests
//
//  Created by Mihai Lapuste on 2018-10-24.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//
// Worked on by: Oleg Strbac
// - Created tests for Application Home Page
// - Created tests for Application User Reminders
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
    
    //Requirement 3.1.1 and 3.1.3
    func testHomePageButtonsTabbar() {
        let homeElement = app.navigationBars["Home"].otherElements["Home"]
        let tabBarsQuery = app.tabBars
        let remindersButton = tabBarsQuery.buttons["Reminders"]
        let table = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
        let homeButton = tabBarsQuery.buttons["Home"]
        XCTAssertTrue(homeElement.exists)
        XCTAssertFalse(table.exists)
        remindersButton.tap()
        XCTAssertFalse(homeElement.exists)
        XCTAssertTrue(table.exists)
        homeButton.tap()
        XCTAssertTrue(homeElement.exists)
        XCTAssertFalse(table.exists)
    }
    
    //Requirement 3.3.1
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
    
    //Requirement 3.1.2
    func testSettings() {
        let settingsButton = app.navigationBars["Home"].buttons["Settings"]
        let sundowningStaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Sundowning "]/*[[".cells.staticTexts[\"Sundowning \"]",".staticTexts[\"Sundowning \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let homeButton = app.navigationBars["MindSafe.SettingsTableTableView"].buttons["Home"]
        XCTAssertFalse(sundowningStaticText.exists)
        settingsButton.tap()
        XCTAssertTrue(sundowningStaticText.exists)
        homeButton.tap()
        XCTAssertFalse(sundowningStaticText.exists)
    }
    
    //Requirement 3.3.4 and 3.3.3
    func testNotificationCreation() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["4 scheduled reminders "]/*[[".cells.staticTexts[\"4 scheduled reminders \"]",".staticTexts[\"4 scheduled reminders \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["MindSafe.RemindersView"].buttons["Add reminder"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Title & description"]/*[[".cells.textFields[\"Title & description\"]",".textFields[\"Title & description\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
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
        
        let gKey = app/*@START_MENU_TOKEN@*/.keys["g"]/*[[".keyboards.keys[\"g\"]",".keys[\"g\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        gKey.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".cells.buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let saveButton = tablesQuery/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".cells.buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        saveButton.tap()
        
        let testingStaticText = tablesQuery.staticTexts["testing"]
        XCTAssertTrue(testingStaticText.exists)
        testingStaticText.swipeLeft()
        let deleteButton = tablesQuery.buttons["Delete"]
        deleteButton.tap()
        XCTAssertFalse(testingStaticText.exists)
    }
    
    //Requirement 3.1.3 and 3.1.2
    func testHomeButtons (){
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let viewActivitiesStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["View activities"]/*[[".cells.staticTexts[\"View activities\"]",".staticTexts[\"View activities\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(viewActivitiesStaticText.isHittable)
        
        let staticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["4 scheduled reminders "]/*[[".cells.staticTexts[\"4 scheduled reminders \"]",".staticTexts[\"4 scheduled reminders \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(staticText.isHittable)
        staticText.tap()
        
        
        let table = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
        XCTAssertTrue(table.exists)
        
        let homeButton = app.tabBars.buttons["Home"]
        homeButton.tap()
        XCTAssertFalse(table.exists)
        
        let trackerStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Tracker"]/*[[".cells.staticTexts[\"Tracker\"]",".staticTexts[\"Tracker\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(trackerStaticText.isHittable)
        
        let progressViewerStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Progress viewer"]/*[[".cells.staticTexts[\"Progress viewer\"]",".staticTexts[\"Progress viewer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(progressViewerStaticText.isHittable)
        
        let emergencyContactsStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Emergency contacts"]/*[[".cells.staticTexts[\"Emergency contacts\"]",".staticTexts[\"Emergency contacts\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(emergencyContactsStaticText.isHittable)
    }
}
