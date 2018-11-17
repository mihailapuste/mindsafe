//
//  ContactsViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-17.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var contactsTable: UITableView!
    var contacts: [Contacts] = [];
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for : indexPath) as! ContactTableViewCell
       
        let firstName = contacts[indexPath.row].value(forKey: "firstName") as? String
        let lastName = contacts[indexPath.row].value(forKey: "lastName") as? String
        let contactRelationship = contacts[indexPath.row].value(forKey: "contactRelationship") as? String
//        let phoneNumber = contacts[indexPath.row].value(forKey: "phoneNumber") as? String
//        let contactEmail = contacts[indexPath.row].value(forKey: "contactEmail") as? String
//        let contactAddress = contacts[indexPath.row].value(forKey: "contactAddress") as? String

        cell.name?.text =  String(firstName! + " " + lastName!)
        cell.relationship?.text = contactRelationship
        
        
        return cell
    }
    
    //Constructor arguments -> getting data from coredata and reloading table content
    override func viewWillAppear(_ animated: Bool) {
        getData() // get the data from core data
        contactsTable.reloadData() // reload table view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //Getting all the data needed from coredata (used in constructor)
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext;
        
        do
        {
            contacts = try context.fetch(Contacts.fetchRequest())
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
            let contact = contacts[indexPath.row]
            context.delete(contact);
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do
            {
                contacts = try context.fetch(Contacts.fetchRequest())
            }
            catch
            {
                print("fetch failed!")
            }
        }
        
        contactsTable.reloadData()
    }

}
