//
//  RemindersViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-10-25.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
