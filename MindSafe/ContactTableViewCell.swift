//
//  ContactTableViewCell.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-17.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var relationshipLabel: UILabel!
    
    var phoneNumber = ""
    
    @IBAction func messageAction(_ sender: Any) {
         let emergencyMessage = UserDefaults.standard.object(forKey: "emergencyMessage") as! String
        let sms: String = "sms:+1\(phoneNumber)&body=\(emergencyMessage)"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func callAction(_ sender: Any) {
        print("Panic mode")
        guard let url = URL(string: "telprompt://\(phoneNumber)") else { return }
        UIApplication.shared.open(url)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
