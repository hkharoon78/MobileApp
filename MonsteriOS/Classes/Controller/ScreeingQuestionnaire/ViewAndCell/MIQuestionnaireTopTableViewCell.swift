//
//  MIQuestionnaireTopTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 23/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIQuestionnaireTopTableViewCell: UITableViewCell {

    //MARK:Variables and Outlets
    @IBOutlet weak var screeningTitle: UILabel!
    @IBOutlet weak var screeningDesc: UILabel!
    
    //MARK:Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.screeningDesc.text=nil
        self.screeningTitle.text=nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
