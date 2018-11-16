//
//  ContactsViewController.swift
//  MindSafe
//
//  Created by Puru Chaudhary on 11/16/18.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
    
    var contacts : [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let john = Contact(name: "john doe", phoneNum: "66666666666", relation: "nephew", email: "jsgfuys", address: "kdufhsidhfu")
        contacts.append(john)
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNum
        
        return cell
    }
    
    @IBAction func unwindToContactList(segue: UIStoryboardSegue) {
        guard let viewController = segue.source as? AddContactViewController else {return}
        guard let name = viewController.nameTextField.text, let phone = viewController.phoneTextField.text, let email = viewController.emailTextField.text, let relation = viewController.relationTextField.text, let address = viewController.addressTextField.text else { return }
        
        let contact = Contact(name: name, phoneNum: phone, relation: relation, email: email, address: address)
        
        contacts.append(contact)
        tableView.reloadData()
    }
}
