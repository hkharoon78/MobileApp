//
//  MIProjectDetailTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 21/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProjectDetailTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
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
