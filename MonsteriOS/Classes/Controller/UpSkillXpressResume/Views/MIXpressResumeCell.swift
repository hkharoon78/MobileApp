//
//  MIXpressResumeCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 20/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIXpressResumeCell: UITableViewCell {

    @IBOutlet weak var countryRegion_lbl:UILabel! {
        didSet {
            self.countryRegion_lbl.textColor = AppTheme.textColor
            self.countryRegion_lbl.font = UIFont.customFont(type: .Semibold, size: 16)
        }
    }
    @IBOutlet weak var descriptionContent_lbl:UILabel! {
        didSet {
            self.descriptionContent_lbl.textColor = UIColor.init(hex: "637381")
            self.descriptionContent_lbl.font = UIFont.customFont(type: .Medium, size: 14)
        }
    }
    @IBOutlet weak var amount_Lbl:UILabel! {
        didSet {
            self.amount_Lbl.textColor = AppTheme.defaltTheme
            self.amount_Lbl.font = UIFont.customFont(type: .Semibold, size: 18)
        }
    }

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = AppTheme.viewBackgroundColor
        self.contentView.backgroundColor = AppTheme.viewBackgroundColor
    }

    // MARK: - Helper Methods
    func showData(info:MIXpressResumeInfo) {
        
        self.countryRegion_lbl.text = info.regionName
        self.descriptionContent_lbl.text = info.descriptionContent
        self.amount_Lbl.text = info.amount
    }
}
