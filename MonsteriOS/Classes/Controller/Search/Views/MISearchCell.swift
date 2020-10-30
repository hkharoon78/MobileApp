//
//  MISearchCell.swift
//  MonsteriOS
//
//  Created by Piyush on 08/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISearchCell: UITableViewCell {
    
    @IBOutlet weak private var titleLbl:UILabel!
    
    @IBOutlet weak private var descLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    func show(info:MIAutoSuggestInfo) {
        self.titleLbl.text = info.name
        self.descLbl.text  = info.suggestedType
    }
}
