//
//  Reminder.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-02.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import Foundation
import UIKit

class Reminder{
    var title: String;
    var note: String;
//    var isDaily: Bool;
//    var date: Date;
    
    init(title: String, note: String
//        , isDaily: Bool, date: Date
        ) {
        self.title = title
        self.note = note
//        self.isDaily = isDaily
//        self.date = date
    }
}
