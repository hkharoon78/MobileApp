//
//  MIManageSubsNotificationSaveTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 19/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIManageSubsNotificationSaveTableViewCell: UITableViewCell {

    @IBOutlet weak var btnSave: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.btnSave.layer.cornerRadius = 4.0
        self.btnSave.layer.masksToBounds = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
