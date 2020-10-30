//
//  MI3RadioButtonTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 23/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MI3RadioButtonTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var radioButtons: [UIButton]!
    var radioBtnSelection : ((Int, String)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        _=self.radioButtons.map({ $0.isSelected = false })
    }
    
    @IBAction func radioButtonAction(_ sender: UIButton) {
        _=self.radioButtons.map({ $0.isSelected = false })
        sender.isSelected = true
        if let action = radioBtnSelection {
            let buttonTitle = sender.currentTitle?.withoutWhiteSpace() ?? ""
            action(sender.tag, buttonTitle)
        }
    }
    
    func setButtons(_ button1: String, button2: String, button3: String) {
        radioButtons[0].setTitle(button1, for: .normal)
        radioButtons[1].setTitle(button2, for: .normal)
        radioButtons[2].setTitle(button3, for: .normal)
    }
    
    func selectRadioButton(at index: Int) {
        _=self.radioButtons.map({ $0.isSelected = false })

        self.radioButtons[index].isSelected = true
    }
    
}
