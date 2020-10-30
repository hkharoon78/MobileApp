//
//  MIUpSkillViewcartBuyNowTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 02/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIUpSkillViewcartBuyNowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnBuyNow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.btnBuyNow.roundCorners([.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 4)
            self.btnBuyNow.layer.cornerRadius = 4.0
            self.btnBuyNow.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBaction
    @IBAction func btnBuyNowPressed(_ sender: UIButton) {
    }
}
