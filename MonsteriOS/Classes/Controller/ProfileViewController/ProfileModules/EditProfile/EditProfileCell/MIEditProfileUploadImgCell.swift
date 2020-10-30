//
//  MIEditProfileUploadImgCell.swift
//  MonsteriOS
//
//  Created by Anushka on 01/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIEditProfileUploadImgCell: UITableViewCell {
    
    @IBOutlet weak var imgEditProfile: UIImageView!
    @IBOutlet weak var lblUploadEditProfile: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgEditProfile.applyCircular()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
