//
//  MIDeleteAccountTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 04/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIDeleteAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDeleteAccount: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnDeleteAccount.layer.cornerRadius = 4.0
        self.btnDeleteAccount.layer.masksToBounds = false
        self.btnDeleteAccount.backgroundColor = AppTheme.defaultGreenColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
