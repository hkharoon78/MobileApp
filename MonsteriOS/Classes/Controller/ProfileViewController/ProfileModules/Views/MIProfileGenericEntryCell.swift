//
//  MIProfileGenericEntryCell.swift
//  MonsteriOS
//
//  Created by Piyush on 18/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField//.JVFloatLabeledTextView

class MIProfileGenericEntryCell: UITableViewCell {

    @IBOutlet weak var txtFieldGeneric: JVFloatLabeledTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func show(info:MIProfileGenericInfo) {
        self.txtFieldGeneric.placeholder = info.placeHolder
    }
    
}
