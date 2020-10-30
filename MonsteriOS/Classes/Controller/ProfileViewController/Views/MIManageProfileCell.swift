//
//  MIManageProfileCell.swift
//  MonsteriOS
//
//  Created by Piyush on 07/03/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIManageProfileCell: UITableViewCell {

    @IBOutlet weak var lblManageProfile: UILabel! {
        didSet {
           self.lblManageProfile.font = UIFont.customFont(type: .Bold, size: 14)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    
}
