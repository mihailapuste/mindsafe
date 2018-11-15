//
//  PanicViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-14.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

class PanicViewController: UIViewController {
    
    @IBAction func sosEmergencyCall(_ sender: Any) {
//        let number = "911"
        let url = URL(string: "tel://6047655427")
        UIApplication.shared.canOpenURL(url!)
        UIApplication.shared.open(url!)
    }
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
