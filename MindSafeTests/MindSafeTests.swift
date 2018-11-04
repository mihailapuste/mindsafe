//
//  MindSafeTests.swift
//  MindSafeTests
//
//  Created by Mihai Lapuste on 2018-10-24.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//
// Team Mindsafe
//Worked on by: Oleg
//Added unit test regarding Application User reminders.

import XCTest
@testable import MindSafe

class MindSafeTests: XCTestCase {
    var unittest: RemindersViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        unittest = RemindersViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        unittest = nil
        super.tearDown()
    }
    
    //Requirement 3.3
    func testReminderEmpty() {
        let reminders: [Reminders] = [];
        XCTAssert(reminders.count == 0)
    }
}
