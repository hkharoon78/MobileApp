//
//  MIJobAppliedSuccessCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 07/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIJobAppliedSuccessCell: UITableViewCell {

    @IBOutlet weak var successTitleLabel: UILabel!{
        didSet{
            successTitleLabel.textColor = .black
            successTitleLabel.font = UIFont.customFont(type: .Regular, size: 16)
        }
    }
    @IBOutlet weak var jobTitleLabel: UILabel!{
        didSet{
            jobTitleLabel.textColor = AppTheme.textColor
            jobTitleLabel.font = UIFont.customFont(type: .Regular, size: 14)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
