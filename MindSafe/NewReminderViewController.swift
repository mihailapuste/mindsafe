//
//  NewReminderViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-10-25.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

class NewReminderViewController: UIViewController {
    
    @IBOutlet weak var ReminderName: UITextField!
    
    @IBAction func AddReminder(_ sender: AnyObject) {
        
        if ReminderName.text != ""
        {
            list.append(ReminderName.text!)
            ReminderName.text = ""
        }
        
    }
    
    func addReminder() {
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
