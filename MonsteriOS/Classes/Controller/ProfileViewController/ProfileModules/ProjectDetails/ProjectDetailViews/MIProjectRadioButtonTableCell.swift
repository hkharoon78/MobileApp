//
//  MIProjectRadioButtonTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 21/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProjectRadioButtonTableCell: UITableViewCell {
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet var radioButtons: [UIButton]!
    
    var radioBtnSelection : ((String)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func radioButtonAction(_ sender: UIButton) {
        _=self.radioButtons.map({ $0.isSelected = false })
        
        sender.isSelected = true
        
        if let action = radioBtnSelection {
            action(sender.currentTitle!)
        }

    }
}
