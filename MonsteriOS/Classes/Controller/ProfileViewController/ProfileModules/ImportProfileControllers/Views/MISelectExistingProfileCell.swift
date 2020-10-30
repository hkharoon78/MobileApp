//
//  MISelectExistingProfileCell.swift
//  MonsteriOS
//
//  Created by Piyush on 22/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MISelectExistingProfileCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.countryLbl.textColor = AppTheme.defaltBlueColor
    }
    
    func show(info:MIExistingProfileInfo) {
        if !info.title.isEmpty {
            self.titleLbl.text = "\(info.title)"
        } else {
            self.titleLbl.text = "Profile title not available"
        }
        if !info.countryName.isEmpty {
            self.countryLbl.text =  info.countryName
        }
//        self.titleLbl.showAttributedTxtColor(str: countryName, with: Color.colorDefault)
    }
    
}
