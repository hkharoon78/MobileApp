//
//  MIManageSubsNotificationTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 19/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIManageSubsNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var switchOnOff: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        self.lblNotification.numberOfLines = 0
        self.switchOnOff.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
