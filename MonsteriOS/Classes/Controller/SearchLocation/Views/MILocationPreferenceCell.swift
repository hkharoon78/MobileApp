//
//  MILocationPreferenceCell.swift
//  MonsteriOS
//
//  Created by Piyush on 12/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MILocationPreferenceCell: UITableViewCell {

    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.titleLbl.textColor = AppTheme.defaltBlueColor
    }
    
    func show(info:MILocationPreferenceInfo) {
        self.titleLbl.text = info.title
        self.imgView.image = UIImage(named: info.imgName)
    }
}
