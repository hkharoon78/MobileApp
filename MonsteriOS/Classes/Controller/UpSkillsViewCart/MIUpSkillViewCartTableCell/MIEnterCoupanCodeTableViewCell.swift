//
//  MIEnterCoupanCodeTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 02/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIEnterCoupanCodeTableViewCell: UITableViewCell{
    
    @IBOutlet weak var txtfCouponCode: UITextField!
    @IBOutlet weak var btnApply: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBAction
    @IBAction func btnApplyPressed(_ sender: UIButton) {
    }
    
    
    
}
