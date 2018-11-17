//
//  NewContactTableViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-17.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import CoreData

class NewContactTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var contactRelationship: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var contactAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        contactRelationship.delegate = self
        phoneNumber.delegate = self
        contactEmail.delegate = self
        contactAddress.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancelNewContact(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNewContact(_ sender: Any) {
        
         if firstName.text != "" && contactAddress.text != "" && contactEmail.text != "" && phoneNumber.text != "" && lastName.text != ""{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext;
            let contact = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: context)
            
            contact.setValue(firstName.text!, forKey: "firstName")
            contact.setValue(lastName.text!, forKey: "lastName")
            contact.setValue(contactRelationship.text!, forKey: "contactRelationship")
            contact.setValue(phoneNumber.text!, forKey: "phoneNumber")
            contact.setValue(contactEmail.text!, forKey: "contactEmail")
            contact.setValue(contactAddress.text!, forKey: "contactAddress")
            
            // Save the data to core data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            dismiss(animated: true, completion: nil)
            
        }
         else{
            showAlert(title: "Information missing", message: "Please fill out every field!")
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
