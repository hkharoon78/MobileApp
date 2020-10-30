//
//  MIProfileJobPreferenceCell.swift
//  MonsteriOS
//
//  Created by Piyush on 11/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProfileJobPreferenceCell: MIProfileTableCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func show(info:MIProfileInfo) {
        self.titleLbl.text = info.title
        self.descLbl.text = info.subTitle
    }
    
    func showPersonalDetail(info:MIProfilePersonalCellInfo) {
        self.titleLbl.text = info.cellTitle
        self.descLbl.text = info.cellDesc
    }
    
    func showJobPreference(info:MIProfileJobPreferenceCellInfo) {
        self.titleLbl.text = info.cellTitle
        self.descLbl.text = info.cellDesc
    }
}

