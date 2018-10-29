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
    
    override func viewWillAppear(_ animated: Bool) {
        // get the data from core data
        getData()
    
        // reload table view
        RemindersTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = RemindersTableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath)
        
        let isDaily = reminders[indexPath.row].value(forKey: "isDaily") as? Bool
        let note = reminders[indexPath.row].value(forKey: "note") as? String
        
        let date = reminders[indexPath.row].value(forKey: "date") as? Date
//        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date!)
     
        if isDaily == true
        {
            if let title = reminders[indexPath.row].value(forKey: "title") as? String
            {
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = note
//              print(triggerDate)
            }
        }
        else
        {
            if let title = reminders[indexPath.row].value(forKey: "title") as? String
            {
                cell.textLabel?.text = title
                cell.detailTextLabel?.text =  note
            }
        }
        
        return (cell)
    }
    
    
    
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

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext;
        
        if editingStyle == .delete
        {
            let reminder = reminders[indexPath.row]
            let title = reminders[indexPath.row].value(forKey: "title") as? String
            
            context.delete(reminder);
            
//            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [title!])
            
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
