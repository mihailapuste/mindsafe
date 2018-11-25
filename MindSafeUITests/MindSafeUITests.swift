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
// - Updated testSettings to incorporate new features
// - Created tests for Tracker/Go home, Contacts Page and Progress viewer
// Team MindSafe
import XCTest
import UIKit
import CoreData

// Run tests on iPhone 6s !

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
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        
        let settingsNavigationBar = app.navigationBars["Settings"]
        let settingsElement = settingsNavigationBar.otherElements["Settings"]
        XCTAssertTrue(settingsElement.exists)
        let tablesQuery = app.tables
        let sundowningSwitch = tablesQuery/*@START_MENU_TOKEN@*/.switches["Sundowning"]/*[[".cells.switches[\"Sundowning\"]",".switches[\"Sundowning\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sundowningSwitch.tap()
        sundowningSwitch.tap()
        
        let safeZoneSwitch = tablesQuery/*@START_MENU_TOKEN@*/.switches["Safe Zone"]/*[[".cells.switches[\"Safe Zone\"]",".switches[\"Safe Zone\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        safeZoneSwitch.tap()
        safeZoneSwitch.tap()
        
        let staticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["3"]/*[[".cells.staticTexts[\"3\"]",".staticTexts[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(staticText.exists)
        
        let incrementButton = app.tables/*@START_MENU_TOKEN@*/.buttons["Increment"]/*[[".cells.buttons[\"Increment\"]",".buttons[\"Increment\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        incrementButton.tap()
        incrementButton.tap()
        
        let staticText2 = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["5"]/*[[".cells.staticTexts[\"5\"]",".staticTexts[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(staticText2.exists)
        XCTAssertFalse(staticText.exists)
        
        let decrementButton = tablesQuery/*@START_MENU_TOKEN@*/.buttons["Decrement"]/*[[".cells.buttons[\"Decrement\"]",".buttons[\"Decrement\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        decrementButton.tap()
        decrementButton.tap()
        settingsNavigationBar.buttons["Home"].tap()
        XCTAssertFalse(settingsElement.exists)
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
//        XCTAssertFalse(table.exists)
        
        let trackerStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Tracker"]/*[[".cells.staticTexts[\"Tracker\"]",".staticTexts[\"Tracker\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(trackerStaticText.isHittable)
        
        let progressViewerStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Progress viewer"]/*[[".cells.staticTexts[\"Progress viewer\"]",".staticTexts[\"Progress viewer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(progressViewerStaticText.isHittable)
        
        let emergencyContactsStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Emergency contacts"]/*[[".cells.staticTexts[\"Emergency contacts\"]",".staticTexts[\"Emergency contacts\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(emergencyContactsStaticText.isHittable)
    }
    //Requirement 3.4.1
    func testTracking(){
        
        let app = XCUIApplication()
        let trackerButton = app.tabBars.buttons["Tracker"]
        trackerButton.tap()
        trackerButton.tap()
        app.navigationBars["Tracker"].buttons["Info"].tap()
        
        let howToSetSafeZoneStaticText = app.staticTexts["How to set Safe Zone"]
        
        
        let moreSafeZoneSettingsStaticText = app.staticTexts["More Safe Zone Settings"]
        XCTAssertTrue(howToSetSafeZoneStaticText.exists)
        XCTAssertTrue(moreSafeZoneSettingsStaticText.exists)
        app.buttons["Done"].tap()
       // XCTAssertFalse(howToSetSafeZoneStaticText.exists)
        //XCTAssertFalse(moreSafeZoneSettingsStaticText.exists)
        app.navigationBars["Tracker"].buttons["Search"].tap()
        
        let searchSearchField = app.searchFields["Search"]
        searchSearchField.typeText("Simon fraser")
        XCTAssertTrue(searchSearchField.exists)
        searchSearchField.tap()
        app/*@START_MENU_TOKEN@*/.menuItems["Select All"]/*[[".menus.menuItems[\"Select All\"]",".menuItems[\"Select All\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        searchSearchField.buttons["Clear text"].tap()
        searchSearchField.tap()
        app.buttons["Cancel"].tap()
        //XCTAssertFalse(searchSearchField.exists)
        let switch2 = app.switches["0"]
        switch2.tap()
    }
    
    //Requirement 3.4.2
    func testGoHome(){
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tracker"].tap()
        tabBarsQuery.buttons["Activities"].tap()
        tabBarsQuery.buttons["Reminders"].tap()
        
        let mindsafeRemindersviewNavigationBar = app.navigationBars["MindSafe.RemindersView"]
        mindsafeRemindersviewNavigationBar.buttons["Add reminder"].tap()
        app.tables/*@START_MENU_TOKEN@*/.buttons["Cancel"]/*[[".cells.buttons[\"Cancel\"]",".buttons[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let button = mindsafeRemindersviewNavigationBar.children(matching: .button).element(boundBy: 0)
        button.tap()
        
        let exitButton = app.navigationBars["Panic mode"].buttons["Exit"]
        exitButton.tap()
        button.tap()
        app.buttons["Get Directions Home"].tap()
    }
    
    //Requirement 3.4.2 and #.#.#
    func testContactCreation () {
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Emergency contacts"]/*[[".cells.staticTexts[\"Emergency contacts\"]",".staticTexts[\"Emergency contacts\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let emptyListTable = app.tables["Empty list"]
        XCTAssertTrue(emptyListTable.exists)
        app.navigationBars["Contacts"].buttons["Add"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["First name"]/*[[".cells.textFields[\"First name\"]",".textFields[\"First name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let textField = tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element
        textField.typeText("st")
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        
        let shiftButton = app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        shiftButton.tap()
        textField.typeText("Steve")
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Last name"]/*[[".cells.textFields[\"Last name\"]",".textFields[\"Last name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        shiftButton.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.typeText("Johnson")
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Relationship"]/*[[".cells.textFields[\"Relationship\"]",".textFields[\"Relationship\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        shiftButton.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 2).children(matching: .textField).element.typeText("Carets")
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        
        tablesQuery.children(matching: .cell).element(boundBy: 2).children(matching: .textField).element.typeText("Caretaker")
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Phone number"]/*[[".cells.textFields[\"Phone number\"]",".textFields[\"Phone number\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let textField2 = tablesQuery.children(matching: .cell).element(boundBy: 3).children(matching: .textField).element
        textField2.typeText("1234567890")
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".cells.textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 4).children(matching: .textField).element.typeText("test@gmail.com")
        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Address"]/*[[".cells.textFields[\"Address\"]",".textFields[\"Address\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let moreKey = app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"more, numbers\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        moreKey.tap()
        
        let textField3 = tablesQuery.children(matching: .cell).element(boundBy: 5).children(matching: .textField).element
        textField3.typeText("4")
        textField3.typeText("05")
        deleteKey.tap()
        textField3.typeText("4")
        textField3.typeText(" test street")
        tablesQuery.buttons["Save"].tap()
        
        let steveJohnsonStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Steve Johnson"]/*[[".cells.staticTexts[\"Steve Johnson\"]",".staticTexts[\"Steve Johnson\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let caretakerStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Caretaker"]/*[[".cells.staticTexts[\"Caretaker\"]",".staticTexts[\"Caretaker\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(steveJohnsonStaticText.exists)
        XCTAssertTrue(caretakerStaticText.exists)
        XCTAssertFalse(emptyListTable.exists)
        
        
        app.navigationBars["Contacts"].buttons["Done"].tap()
        app.navigationBars["Home"].buttons["Item"].tap()
        
        app.tables/*@START_MENU_TOKEN@*/.buttons["icons8 speech bubble filled 50"]/*[[".cells.buttons[\"icons8 speech bubble filled 50\"]",".buttons[\"icons8 speech bubble filled 50\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    //Requirement #.#.#
    func testContactCancellationAndDeletion () {
        
        let trackerButton = XCUIApplication().tabBars.buttons["Tracker"]
        trackerButton.tap()
        
        
        app.tabBars.buttons["Home"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Emergency contacts"]/*[[".cells.staticTexts[\"Emergency contacts\"]",".staticTexts[\"Emergency contacts\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let contactsElement = XCUIApplication().navigationBars["Contacts"].otherElements["Contacts"]
        XCTAssertTrue(contactsElement.exists)
        
        app.navigationBars["Contacts"].buttons["Add"].tap()
        //XCTAssertFalse(contactsElement.exists)
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["First name"]/*[[".cells.textFields[\"First name\"]",".textFields[\"First name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let textField = tablesQuery2.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element
        textField.typeText("testing")
        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery2.buttons["Cancel"].tap()
        XCTAssertTrue(contactsElement.exists)
        
        let emptyListTable = XCUIApplication().tables["Empty list"]
        //XCTAssertTrue(emptyListTable.exists)
        
        
        
        app.navigationBars["Contacts"].buttons["Add"].tap()
        
        app.tables/*@START_MENU_TOKEN@*/.textFields["First name"]/*[[".cells.textFields[\"First name\"]",".textFields[\"First name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        textField.typeText("test")
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Last name"]/*[[".cells.textFields[\"Last name\"]",".textFields[\"Last name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.typeText("test")
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Relationship"]/*[[".cells.textFields[\"Relationship\"]",".textFields[\"Relationship\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 2).children(matching: .textField).element.typeText("test")
        
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Phone number"]/*[[".cells.textFields[\"Phone number\"]",".textFields[\"Phone number\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 3).children(matching: .textField).element.typeText("123")
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".cells.textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 4).children(matching: .textField).element.typeText("@")
        
        let doneButton = app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Address"]/*[[".cells.textFields[\"Address\"]",".textFields[\"Address\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let textField3 = tablesQuery.children(matching: .cell).element(boundBy: 5).children(matching: .textField).element
        textField3.typeText("4")
        textField3.typeText("05")
        doneButton.tap()
        tablesQuery.buttons["Save"].tap()
        
        let testTestStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["test test"]/*[[".cells.staticTexts[\"test test\"]",".staticTexts[\"test test\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        testTestStaticText.tap()
        testTestStaticText.tap()
        testTestStaticText.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        
        //XCTAssertTrue(emptyListTable.exists)
    }
}
