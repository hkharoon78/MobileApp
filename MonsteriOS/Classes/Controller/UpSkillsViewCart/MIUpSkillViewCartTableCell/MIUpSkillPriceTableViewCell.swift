//
//  MIUpSkillPriceTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 02/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIUpSkillPriceTableViewCell: UITableViewCell {
   
    @IBOutlet weak var lblGrossPrice: UILabel!
    @IBOutlet weak var lblGrossPriceValue: UILabel!
    @IBOutlet weak var lblIGST: UILabel!
    @IBOutlet weak var lblIGSTValue: UILabel!
    @IBOutlet weak var btnIGSTInfo: UIButton!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalPriceValue: UILabel!
    @IBOutlet weak var lblSelectedREsumeCombo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBAction
    @IBAction func btnIGSTInfoPressed(_ sender: UIButton) {
        
    }
    
}
