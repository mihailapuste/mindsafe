//
//  PersonalProfileTableViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-18.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

class PersonalProfileTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var provstate: UITextField!
    @IBOutlet weak var country: UITextField!
    
    @IBOutlet weak var zip: UITextField!
//    firstName
//    lastName
//    
//    phoneNumber
//    email
//    
//    street
//    city
//    provstate
//    zip
//    country
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if firstName.text != "" && lastName.text != "" && phoneNumber.text != "" && email.text != "" && street.text != "" && city.text != "" && provstate.text != "" && zip.text != "" && country.text != ""{
            
            UserDefaults.standard.set(firstName.text, forKey:"firstName")
            UserDefaults.standard.set(lastName.text, forKey:"lastName")
            UserDefaults.standard.set(phoneNumber.text, forKey:"phoneNumber")
            UserDefaults.standard.set(email.text, forKey:"email")
            
            UserDefaults.standard.set(street.text, forKey:"street")
            UserDefaults.standard.set(city.text, forKey:"city")
            UserDefaults.standard.set(provstate.text, forKey:"provstate")
            UserDefaults.standard.set(zip.text, forKey:"zip")
            UserDefaults.standard.set(country.text, forKey:"country")
            
//            print("\(street.text!), \(city.text!), \(zip.text!), \(country.text!)")
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstName.text = UserDefaults.standard.object(forKey: "firstName") as? String
        lastName.text = UserDefaults.standard.object(forKey: "lastName") as? String

        phoneNumber.text = UserDefaults.standard.object(forKey: "phoneNumber") as? String
        email.text = UserDefaults.standard.object(forKey: "email") as? String

        street.text = UserDefaults.standard.object(forKey: "street") as? String
        city.text = UserDefaults.standard.object(forKey: "city") as? String
        provstate.text = UserDefaults.standard.object(forKey: "provstate") as? String
        zip.text = UserDefaults.standard.object(forKey: "zip") as? String
        country.text = UserDefaults.standard.object(forKey: "country") as? String
        
        self.firstName.delegate = self
        self.lastName.delegate = self
    
        self.phoneNumber.delegate = self
        self.email.delegate = self
    
        self.street.delegate = self
        self.city.delegate = self
        self.provstate.delegate = self
        self.zip.delegate = self
        self.country.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
