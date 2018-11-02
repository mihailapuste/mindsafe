//
//  ViewController.swift
//  DatabaseTest
//
//  Created by Bob on 2018-11-01.
//  Copyright © 2018 Mindsafe. All rights reserved.
//

import UIKit
import FirebaseDatabase
//importing the database of firebase
class SemanticEx: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var List:[String]=[]//String array variable
    var hand: DatabaseHandle?
    var ref: DatabaseReference?
    
    @IBOutlet weak var TextInsert: UITextField!//linked to the Textfield for input
    
    
    @IBOutlet weak var viewTable: UITableView!//linked to the Table View
    

    
    @IBAction func saveWord(_ sender: Any)  {//linked to the button named Save Word
        
        
        //saving data to database
        if TextInsert.text != ""//check user input if there is anything
        {
            ref?.child("list").childByAutoId().setValue(TextInsert.text)//In the child tree save list as the attribute and the input string as value
            TextInsert.text=""//Delete the input text after each input
        }
    }
    
    //Display saved data from the database onto Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UITableViewCell(style: .default,reuseIdentifier:"cell")
        cell.textLabel?.text=List[indexPath.row]
        return cell
    }
    func delete(element: String){
        List=List.filter({$0 != element})
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()//reference the database from firebase
        hand=ref?.child("list").observe(.childAdded,with:{(snapshot)in
            if let data = snapshot.value as? String
            {
                self.List.append(data)//Add item from the database into the array list
                self.viewTable.reloadData()//reload Table View when new data arrives
            }
        })
        
        
        
        hand=ref?.child("list").observe(.childRemoved,with:{(snapshot)in
            if let data = snapshot.value as? String
            {
                if let index=self.List.index(of: data){
                    self.List.remove(at: index)
                }
                self.viewTable.reloadData()//reload Table View when new data arrives
            }
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
