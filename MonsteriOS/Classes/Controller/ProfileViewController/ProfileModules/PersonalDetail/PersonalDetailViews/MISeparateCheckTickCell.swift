//
//  MISeparateCheckTickCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 30/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MISeparateCheckTickCell: UITableViewCell {
    @IBOutlet weak var checkboxButtn: UIButton!
    var checkBoxSelectionAction : ((Bool,MISeparateCheckTickCell)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkboxAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let action = checkBoxSelectionAction {
            action(sender.isSelected, self)
        }
    }
    func showTitleWithFont(title:String, font:UIFont,selectionState:Bool) {
        checkboxButtn.setTitle(title, for: .normal)
        checkboxButtn.titleLabel?.font = font
        self.checkboxButtn.isSelected = selectionState
    }

}
