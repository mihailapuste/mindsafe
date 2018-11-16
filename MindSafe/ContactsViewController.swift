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
        
        let john = Contact(name: "John Doe", phoneNum: "666-666-6666", relation: "Nephew", email: "abc@xyz.com", address: "445 Mount Eden Road, Mount Eden, Auckland")
        
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
        
        cell.textLabel?.text = contact.name + " - " + contact.relation
        cell.detailTextLabel?.text = contact.phoneNum
        
        return cell
    }
}
