//
//  MIBlockCompaniesCell.swift
//  MonsteriOS
//
//  Created by Anushka on 24/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIBlockCompaniesCell: UITableViewCell {

    @IBOutlet weak var blockButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.blockButton.layer.cornerRadius = 4.0
//        self.blockButton.layer.masksToBounds = true
        
        self.configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(){
        
        blockButton.showPrimaryBtn()
        self.blockButton.setTitle(BlockCompanyContant.blockButtonTitle, for: .normal)
        
    }
    
}
