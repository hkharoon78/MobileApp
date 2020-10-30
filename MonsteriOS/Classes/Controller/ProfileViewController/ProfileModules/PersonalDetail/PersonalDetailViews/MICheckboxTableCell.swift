//
//  MICheckboxTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 23/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol SaveActionDelegate:class {
    
    func saveUserProfile()
}

class MICheckboxTableCell: UITableViewCell {

    @IBOutlet weak var checkboxButtn: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var checkBoxSelectionAction : ((Bool)->Void)?
    weak var delegate : SaveActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        saveButton.backgroundColor = AppTheme.btnCTAGreenColor
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func checkboxAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let action = checkBoxSelectionAction {
            action(sender.isSelected)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if delegate != nil {
            self.delegate?.saveUserProfile()
        }
    }
    
    func manageVisibiltyContent(personalData:MIPersonalDetail,type:String){
        checkboxButtn.isSelected = personalData.speciallAbled

    }
}
