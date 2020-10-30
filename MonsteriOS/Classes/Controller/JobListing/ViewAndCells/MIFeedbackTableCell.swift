//
//  MIFeedbackTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 18/03/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIFeedbackTableCell: UITableViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
        
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
