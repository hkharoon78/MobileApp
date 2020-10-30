
//
//  MICompletedEduEmpTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 09/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MICompletedEduEmpTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var optionClicked: ((UIView)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func optionButtonAction(_ sender: UIButton) {
        optionClicked?(sender)
    }

}

