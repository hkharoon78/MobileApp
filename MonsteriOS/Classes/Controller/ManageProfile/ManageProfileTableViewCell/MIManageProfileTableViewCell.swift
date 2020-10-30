//
//  MIManageProfileTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 15/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIManageProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var lblManageProfileName: UILabel!
    @IBOutlet weak var btnDeleteProfile: UIButton!
    @IBOutlet weak var switchOnOffProfile: UISwitch!
    @IBOutlet weak var btnActiveProfile: UIButton!
    
    var switchOnOffAction:(()->Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.switchOnOffProfile.onTintColor=Color.colorDefault
        self.switchOnOffProfile.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
        self.lblManageProfileName.numberOfLines = 0
        self.switchOnOffProfile.addTarget(self, action: #selector(switchOnOff(_:)), for: .valueChanged)
        
        self.btnActiveProfile.isHidden = true
        self.btnActiveProfile.setImage(#imageLiteral(resourceName: "check-illustration"), for: .normal)
        self.btnActiveProfile.isUserInteractionEnabled = false
        
        self.btnDeleteProfile.setTitleColor(AppTheme.defaltBlueColor, for: .normal)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.switchOnOffAction=nil
    }
    
    @objc func switchOnOff(_ sender: UISwitch){
        if let action=self.switchOnOffAction{
            action()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
