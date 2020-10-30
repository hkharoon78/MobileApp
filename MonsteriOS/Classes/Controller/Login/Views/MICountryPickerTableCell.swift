//
//  MICountryPickerTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 10/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MICountryPickerTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
