//
//  MIExpertSpeaksTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 02/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIExpertSpeaksTableCell: UITableViewCell {

    @IBOutlet weak var speakersImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
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
