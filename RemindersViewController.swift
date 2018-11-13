//
//  RemindersViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-10-25.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//
// Worked on by: Mihai Lapuste
// - Created view all created reminders in reminderstable
// - Ability to delete reminders in table, and ability to navigate to add new reminders page
// Team MindSafe

import UIKit
import CoreData
import UserNotifications



class RemindersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var RemindersTableView: UITableView!
    
    var reminders: [Reminders] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RemindersTableView.dataSource = self
        RemindersTableView.delegate = self
    }
    
    //Constructor arguments -> getting data from coredata and reloading table content
    override func viewWillAppear(_ animated: Bool) {
        getData() // get the data from core data
        RemindersTableView.reloadData() // reload table view
    }
    
    //Returning the number of rows needed for tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    //Returning each custom cell populated with its required data on table build/reload
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath) as! ReminderTableViewCell
        let isDaily = reminders[indexPath.row].value(forKey: "isDaily") as? Bool
        let enabled = reminders[indexPath.row].value(forKey: "enabled") as? Bool
        let note = reminders[indexPath.row].value(forKey: "note") as? String
        let title = reminders[indexPath.row].value(forKey: "title") as? String
        let date = reminders[indexPath.row].value(forKey: "date") as? Date
        
        //        let weekday = Calendar.current.component(.weekday, from: date!)
        let month = Calendar.current.component(.month, from: date!)
        let date1 = Calendar.current.component(.day, from: date!)
        let hour = Calendar.current.component(.hour, from: date!)
        let minute = Calendar.current.component(.minute, from: date!)
        
        
        cell.delegate = self as? CustomCellUpdater
        cell.titleView?.text = title
        cell.noteView?.text = note
        cell.isEnabled?.isOn = enabled!
        
        //Setting different display message for non daily reminders
        if (isDaily == true){
            cell.dateView?.text = "(Daily) \(hour)h:\(minute)m"
        }
        else{
            cell.dateView?.text = "\(Calendar.current.shortMonthSymbols[month-1]) \(date1) at \(hour)h:\(minute)m"
        }
        
        return cell
    }
    
    //Getting all the data needed from coredata (used in constructor)
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext;
        
        do
        {
            reminders = try context.fetch(Reminders.fetchRequest())
        }
        catch
        {
            print("fetch failed!")
        }
        
    }
    
    //Method for deleting list items along with associated notifications in coredata
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext;
        
        if editingStyle == .delete
        {
            let reminder = reminders[indexPath.row]
            let title = reminders[indexPath.row].value(forKey: "title") as? String
            
            context.delete(reminder);
            
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                var identifiers: [String] = []
                for notification:UNNotificationRequest in notificationRequests {
                    print(notification.identifier )
                    if notification.identifier == title! {
                        identifiers.append(notification.identifier)
                    }
                }
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            }
            
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do
            {
                reminders = try context.fetch(Reminders.fetchRequest())
            }
            catch
            {
                print("fetch failed!")
            }
        }
        
        RemindersTableView.reloadData()
    }
    
    // sundowningReminders will create new temp reminders that will trigger 3 times from 2pm to 8pm for all existing reminders once daily.
    func sundowningReminders() {
        
        UserDefaults.standard.set(Date(), forKey:"sundowningTime")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext;
        
        do{
            //fetch all reminders from coredata
            reminders = try context.fetch(Reminders.fetchRequest())
            var sundowningNotification = 1;
            for reminder:Reminders in reminders {
                
                let content = UNMutableNotificationContent()
                content.categoryIdentifier = "Reminders"
                content.title = reminder.title! + String(sundowningNotification)
                content.body = reminder.note!
                content.sound = UNNotificationSound.default()
                
                // Use date components to create a trigger time
                if reminder.isDaily == true
                {
                    var hour = 14; // starts at 2
                    var index = 0;
                    while index < 3 {
                        
                        let greg = Calendar(identifier: .gregorian)
                        let now = Date()
                        var components = greg.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
                        components.hour = hour
                        components.minute = 0
                        components.second = 0

                        let date = greg.date(from: components)!
                        
                        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                        
                        
                        // Instantiate the notification request
                        let request = UNNotificationRequest(identifier: reminder.title!, content: content, trigger: trigger)
                        
                        // Schedule the notification.
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                        
                        //incrementing index and hours
                        sundowningNotification = sundowningNotification + 1;
                        index = index + 1;
                        hour = hour + 2; // inc hour by 2
                        print(hour)
                    }
                }
            }
            
            
            
        }
        catch
        {
            print("fetch failed!")
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
