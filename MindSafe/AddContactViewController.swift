//
//  AddContactViewController.swift
//  MindSafe
//
//  Created by pchaudha on 11/16/18.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var relationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    
    @IBAction func saveAndClose(_ sender: Any) {
        performSegue(withIdentifier: "unwindToContactList", sender: self )
    }
    
    @IBAction func close(_ sender: Any) {
        performSegue(withIdentifier: "unwindToContactList", sender: self )
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
