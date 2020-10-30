//
//  MIProfileVisibilityTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 11/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProfileVisibilityTableViewCell: UITableViewCell {

    @IBOutlet weak var visiblitltyTitlelabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel! {
        didSet{
            self.mobileNumberLabel.textColor = AppTheme.defaltBlueColor
        }
    }
    @IBOutlet weak var hideShowLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bottomHeaderLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profileImageView.applyCircular()
        self.onOffSwitch.onTintColor=Color.colorDefault
       /// self.visiblitltyTitlelabel.text=ProfileVisibiltyConstant.titleText
        self.boldText()
        
        self.profileImageView.image=#imageLiteral(resourceName: "Spark-Hire-Reasons-To-Find-A-New-Recruiter-870x400")
        self.onOffSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
//        self.onOffSwitch.onImage = #imageLiteral(resourceName: "group-3")
//        self.onOffSwitch.offImage = #imageLiteral(resourceName: "group-6")
        
        self.hideShowLabel.isHidden = true
        self.onOffSwitch.onTintColor = AppTheme.defaltBlueColor
    

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK:Hide Show Switch Action
    @IBAction func switchOnOffAction(_ sender: UISwitch) {
        if sender.isOn{
            self.hideShowLabel.text=ProfileVisibiltyConstant.hide
        }else{
            self.hideShowLabel.text=ProfileVisibiltyConstant.show
        }
    }
    
    func boldText() {
        
         let attributed = NSMutableAttributedString(string: "This setting, while on, will allow recruiters to view your contact details. Turning if off will mark your profile as " , attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: "797979"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 14)])
        
         attributed.append(NSAttributedString(string: "confidential", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "797979"), NSAttributedString.Key.font: UIFont.customFont(type: .Bold, size: 14)]))
        
        attributed.append(NSAttributedString(string: " and hide your email and mobile information. \n\n" , attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "797979"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 14)]))
        
        attributed.append(NSAttributedString(string: "Note: ", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "797979"), NSAttributedString.Key.font: UIFont.customFont(type: .Bold, size: 14)]))
        
        attributed.append(NSAttributedString(string: "We do not Hide any contact details you have mentioned inside your resume document.", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "797979"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 14)]))
        
        self.visiblitltyTitlelabel.attributedText = attributed
        
        
    }
    
}
