//
//  MIDeleteAccountTellUsTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 04/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIDeleteAccountTellUsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnTellUs: UIButton!
    @IBOutlet weak var lblTellUs: UILabel!
    @IBOutlet weak var txtViewOther: FLTextView!
    @IBOutlet weak var viewtxtViewUnderLine: UIView!
    @IBOutlet weak var txtViewHeightConstraint: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnTellUs.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        self.btnTellUs.setImage(#imageLiteral(resourceName: "off-1"), for: .selected)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
