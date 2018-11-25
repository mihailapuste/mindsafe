//
//  SettingsTableTableViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-04.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//
// Worked on by: Mihai Lapuste
// - Ability to toggle sundowning feature
// Team MindSafe

import UIKit

class SettingsTableTableViewController: UITableViewController {
    
    @IBOutlet weak var radiusLabel: UILabel!
    
    @IBOutlet weak var radiusOutlet: UIStepper!
    
    // action to set safe zone radius
    @IBAction func safeZoneRadius(_ sender: UIStepper) {
        radiusLabel.text = String(Int(sender.value))
        
        let radius = Int(sender.value*100)
        
        UserDefaults.standard.set(radius, forKey:"safeZoneRadius")
    }
    
    @IBOutlet weak var sunSwitch: UISwitch!
    
    //Toggling sundowning
    @IBAction func sundowningToggle(_ sender: Any) {
        UserDefaults.standard.set(self.sunSwitch.isOn, forKey:"sundowning")
    }
    
    @IBOutlet weak var safeZoneSwitch: UISwitch!
    
    // action to toggle safezone reminders settings
    @IBAction func safeZoneToggled(_ sender: Any) {
       UserDefaults.standard.set(self.safeZoneSwitch.isOn, forKey:"safeZoneNotifications")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sunSwitch.isOn = UserDefaults.standard.object(forKey: "sundowning") as! Bool
        
        self.safeZoneSwitch.isOn = UserDefaults.standard.object(forKey: "safeZoneNotifications") as! Bool
        
        var safeZoneRadius = UserDefaults.standard.object(forKey: "safeZoneRadius") as! Int
        safeZoneRadius = (safeZoneRadius/100)
        print(String(safeZoneRadius))
        self.radiusLabel.text = String(safeZoneRadius)
        self.radiusOutlet.value = Double(Int(safeZoneRadius))

    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
