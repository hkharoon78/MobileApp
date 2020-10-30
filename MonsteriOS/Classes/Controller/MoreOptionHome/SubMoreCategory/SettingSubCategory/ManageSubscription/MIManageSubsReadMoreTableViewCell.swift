//
//  MIManageSubsReadMoreTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 08/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIManageSubsReadMoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDeactivationMsg: UILabel!
    @IBOutlet weak var btnDeactivate: UIButton!
    @IBOutlet weak var lblDeactivateText: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblDeleteText: UILabel!
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var btnLess: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnProceed.layer.cornerRadius = 4.0
        self.btnProceed.layer.masksToBounds = false
        
        self.btnProceed.backgroundColor = AppTheme.btnCTAGreenColor
        self.btnLess.setTitleColor(AppTheme.defaltBlueColor, for: .normal)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
