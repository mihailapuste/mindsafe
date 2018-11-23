//
//  ReminderTableViewCell.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-02.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//
// Worked on by: Mihai Lapuste
// - Created custom cells that interact with the reminderstable
// - Created enabling and disabling support for reminders using the UISwitch
// Team MindSafe
//
import UIKit
import CoreData
import UserNotifications

protocol CustomCellUpdater: class { // the name of the protocol you can put any
    func updateTableView()
}

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateView: UILabel! // label for date
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var noteView: UILabel!
    @IBOutlet weak var isEnabled: UISwitch!
    
    weak var delegate: CustomCellUpdater?
    var reminders: [Reminders] = [];
    
    // method for enabling/disabling notifcations for reminders
    @IBAction func enableSwitch(_ sender: Any) {
        
        let title = self.titleView.text
        
        // Return all reminders, find the one being disabled and delete its notifcation request
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                print(notification.identifier)
                if notification.identifier == title {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            
            modifydata() // modifying coredata related to enabled/disabled notification
            
        }
        
        // function used to modify data from enable/disable request
        func modifydata(){
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext;
            
            do{
                //fetch all reminders from coredata
                self.reminders = try context.fetch(Reminders.fetchRequest())
                
                for reminder:Reminders in self.reminders {
                    
                    if reminder.title == title { // find the one being requested to modify
                        
                        reminder.setValue(self.isEnabled.isOn, forKey: "enabled")
                        
                        if(self.isEnabled.isOn == true){ // if user is enabling notification
                            
                            let content = UNMutableNotificationContent()
                            content.categoryIdentifier = "Reminders"
                            content.title = reminder.title!
                            content.body = reminder.note!
                            content.sound = UNNotificationSound.default()
                            var triggerDate = Calendar.current.dateComponents([.day,.hour,.minute,.second,], from: reminder.date! as Date)
                            
                            // Use date components to create a trigger time
                            if reminder.isDaily
                            {
                                triggerDate = Calendar.current.dateComponents([.hour,.minute,.second,], from: reminder.date! as Date)
                                print("Register: \(triggerDate)")
                            }
                            else
                            {
                                triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: reminder.date! as Date)
                            }
                            
                            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: reminder.isDaily)
                            
                            // Instantiate the notification request
                            let request = UNNotificationRequest(identifier: reminder.title!, content: content, trigger: trigger)
                            
                            // Schedule the notification.
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                        }
                    }
                }
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext() // save changes made to coredata
                self.delegate?.updateTableView() // update table via reference
                
            }
            catch
            {
                print("fetch failed!")
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
