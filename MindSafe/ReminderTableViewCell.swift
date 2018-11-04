//
//  ReminderTableViewCell.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-02.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

protocol CustomCellUpdater: class { // the name of the protocol you can put any
    func updateTableView()
}

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var noteView: UILabel!
    @IBOutlet weak var isEnabled: UISwitch!
    
    weak var delegate: CustomCellUpdater?
    var reminders: [Reminders] = [];
    
    @IBAction func enableSwitch(_ sender: Any) {
        
        let title = self.titleView.text
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext;
        
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                var identifiers: [String] = []
                for notification:UNNotificationRequest in notificationRequests {
                    print(notification.identifier)
                    if notification.identifier == title {
                        identifiers.append(notification.identifier)
                    }
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
               
                modifydata()
            
    }
    
    func modifydata(){
        do{
            self.reminders = try context.fetch(Reminders.fetchRequest())
            for reminder:Reminders in self.reminders {
                if reminder.title == title {
                    reminder.setValue(self.isEnabled.isOn, forKey: "enabled")
                    
                    if(self.isEnabled.isOn == true){
                        
                        let content = UNMutableNotificationContent()
                        
                        content.categoryIdentifier = "Reminders"
                        content.title = reminder.title!
                        content.body = reminder.note!
                        content.sound = UNNotificationSound.default()
                        
                        var triggerDate = Calendar.current.dateComponents([.day,.hour,.minute,.second,], from: reminder.date! as Date)
                        
                        // Use date components to create a trigger time
                        if reminder.isDaily
                        {
                            triggerDate = Calendar.current.dateComponents([.second,], from: reminder.date! as Date)
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
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.delegate?.updateTableView()
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
