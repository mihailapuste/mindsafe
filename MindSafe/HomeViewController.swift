//
//  HomeViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-10-27.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBAction func action(_ sender: AnyObject) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        // track notification status in reference to user
        })
        
        let answer1 = UNNotificationAction(identifier: "answer1", title: "60", options: UNNotificationActionOptions.foreground)
        let answer2 = UNNotificationAction(identifier: "answer2", title: "90", options: UNNotificationActionOptions.foreground)
        
        let category = UNNotificationCategory(identifier: "myCategory", actions: [answer1, answer2], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.title = "How many minutes are in an hour?"
        content.subtitle = "Do you know?"
        content.body = "Please answer!"
        content.categoryIdentifier = "myCategory"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timer done", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "answer1"
        {
            print("correct")
        }
        else{
            print("false")
        }
        completionHandler()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
