//
//  MIProfileDescTableViewCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 27/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIFloatingTextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var floatingTextView: FloatLabelTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
