//
//  MITextFieldTableViewCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 11/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MITextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textField2.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func showError(with message: String) {
        textField2.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        errorLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        errorLabel.text = message
    }
    
    func selectTF() {
        textField2.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        errorLabel.text = ""
    }
    
    func deselectTF() {
        textField2.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
    }
}

extension MITextFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectTF()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.deselectTF()
    }
}
