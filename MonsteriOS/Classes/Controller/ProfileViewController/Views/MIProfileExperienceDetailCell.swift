//
//  MIProfileExperienceDetailCell.swift
//  MonsteriOS
//
//  Created by Piyush on 21/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIProfileExperienceDetailCell: MIProfileTableCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblSpecialization: UILabel!
    @IBOutlet weak var lblSpecializationDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    @IBAction func seeAllClicked(_ sender: UIButton) {
    }
    
    func show(info:MIProfileInfo) {
        lblTitle.text    = info.title
        lblSubTitle.text = info.subTitle
        lblSpecialization.text = info.titleStatus
        lblSpecializationDetail.text = info.titleStatusDetail
    }
}
