//
//  MIProfileOtherDetailCell.swift
//  MonsteriOS
//
//  Created by Piyush on 22/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIProfileOtherDetailCell: MIProfileTableCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func show(info:MIProfileInfo) {
        lblTitle.text    = info.title
        lblSubTitle.text = info.subTitle
    }
}
