//
//  MICreateProfileTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 12/03/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MICreateProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var btnProfileNext: UIButton!
    var accessoryButtonClicked:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnProfileNextClicked(_ sender:UIButton){
        if let action=self.accessoryButtonClicked{
            action()
        }
    }
    
}
