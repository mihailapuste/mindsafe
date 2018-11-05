//
//  NewReminderTableViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-10-27.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


class NewReminderTableViewController: UITableViewController {

    // cell label outlets
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextView!
    @IBOutlet weak var isDaily: UISwitch!
    @IBOutlet weak var reminderDate: UIDatePicker!
    
    // function popping view in case of cancel
    @IBAction func CancelNewReminder(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveNewReminderButton(_ sender: AnyObject) {
       
        if titleField.text != "" { // checking for no empty notification names
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext;
            
            let reminder = NSEntityDescription.insertNewObject(forEntityName: "Reminders", into: context)
            
            reminder.setValue(titleField.text!, forKey: "title")
            reminder.setValue(noteField.text!, forKey: "note")
            reminder.setValue(isDaily.isOn, forKey: "isDaily")
            reminder.setValue(reminderDate.date, forKey: "date")
            reminder.setValue(true, forKey: "enabled")
            // Save the data to core data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            let content = UNMutableNotificationContent()
            
            content.categoryIdentifier = "Reminders"
            content.title = titleField.text!
            content.body = noteField.text!
            content.sound = UNNotificationSound.default()
            
            var triggerDate = Calendar.current.dateComponents([.day,.hour,.minute,.second,], from: reminderDate.date)
            
            // Use date components to create a trigger time
            if isDaily.isOn
            {
                triggerDate = Calendar.current.dateComponents([.hour,.minute,.second,], from: reminderDate.date)
                print("Register: \(triggerDate)")
            }
            else
            {
                triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: reminderDate.date)
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: isDaily.isOn)
            
            // Instantiate the notification request
            let request = UNNotificationRequest(identifier: titleField.text!, content: content, trigger: trigger)
            
            // Schedule the notification.
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            // dismiss view once notifcation is scheduled
            dismiss(animated: true, completion: nil) // use if using modal transition
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   

}
