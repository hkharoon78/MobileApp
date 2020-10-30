//
//  popOverCell.swift
//  DemoPopover
//
//  Created by Piyush on 07/02/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

class popOverCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func show(ttl:String) {
        self.titleLbl.text =  ttl
    }
    
}
