//
//  MIEducationCell.swift
//  MonsteriOS
//
//  Created by Monster on 30/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIEducationCell: MIBaseCell {

    @IBOutlet weak private var titleLbl: UILabel?
    @IBOutlet weak private var titleDetailLbl:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func showUI(info:MIEducationInfo) {
        self.titleLbl?.text       = info.title
        if info.title.isEmpty {
            self.titleDetailLbl?.textColor = Color.colorDarkBlack.withAlphaComponent(0.7)
            self.titleDetailLbl?.font      = UIFont.customFont(type: .Regular, size: 14)
        } else {
            self.titleDetailLbl?.textColor = Color.colorDarkBlack.withAlphaComponent(1.0)
            self.titleDetailLbl?.font      = UIFont.customFont(type: .Regular, size: 16)
        }
        
        self.titleDetailLbl?.text = info.titleDetail
        
    }
}
