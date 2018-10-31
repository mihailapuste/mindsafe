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

    @IBOutlet weak var trackerSwitch: UISwitch!
    @IBOutlet weak var pendingReminders: UILabel!
    
    @IBAction func OnTrackerSwitched(_ sender: UISwitch) {
        if sender.isOn {
            //tracker switched ON
        }
        if !sender.isOn {
            //tracker switched OFF
        }
    }
    
    
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
        
        //get and display number of pending/upcoming reminders
        let numReminders = 78
        pendingReminders.text = "\(numReminders) pending"
        
        // This code below sets the mindsafe logo in the top navbar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "ms4-1.png")
        imageView.image = image
        self.navigationItem.titleView = imageView
        
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
