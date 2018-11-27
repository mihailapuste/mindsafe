//
//  SemanitcAnswerTableViewCell.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-26.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

class SemanitcAnswerTableViewCell: UITableViewCell {

    @IBOutlet var checkErroView: UIImageView!
    @IBOutlet weak var answerView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
