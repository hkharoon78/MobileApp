//
//  MIManageSubsNotificationDesTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 19/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIManageSubsNotificationDesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNotificationDes: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.lblNotificationDes.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
