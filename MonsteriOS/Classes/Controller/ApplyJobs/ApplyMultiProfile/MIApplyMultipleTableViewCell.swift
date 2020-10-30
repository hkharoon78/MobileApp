//
//  MIApplyMultipleTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 19/03/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIApplyMultipleTableViewCell: UITableViewCell {

    @IBOutlet weak var profileTitleLabel: UILabel!{
        didSet{
            profileTitleLabel.numberOfLines = 0
            profileTitleLabel.font=UIFont.customFont(type: .Regular, size: 14)
            profileTitleLabel.textColor=AppTheme.textColor
        }
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
