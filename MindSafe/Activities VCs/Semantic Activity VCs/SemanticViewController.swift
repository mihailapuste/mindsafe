//
//  SemanticViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-21.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

class SemanticViewController: UIViewController {

    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func startActivity(_ sender: Any) {
       performSegue(withIdentifier: "semanticActivity", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelGame(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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
