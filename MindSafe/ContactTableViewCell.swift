//
//  ContactTableViewCell.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-17.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

var rowId = 0;

class ContactTableViewCell: UITableViewCell {
   
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var relationship: UILabel!
   
    var cellID: Int = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//
//    @IBAction func viewContact(_ sender: Any) {
//        rowId = cellID;
//        self.navigationController.pushViewController(ViewContactTableViewController, animated: true)
//    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
