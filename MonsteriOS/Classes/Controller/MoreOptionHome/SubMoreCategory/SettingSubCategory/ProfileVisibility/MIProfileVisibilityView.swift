//
//  MIProfileVisibilityView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit


class MIProfileVisibilityView: UIView {

    //MARK:Outlets and Variable
    @IBOutlet weak var visiblitltyTitlelabel: UILabel!{
        didSet{
            self.visiblitltyTitlelabel.font=UIFont.customFont(type: .Regular, size: 14)
            self.visiblitltyTitlelabel.textColor=AppTheme.textColor
        }
    }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            self.nameLabel.font = UIFont.customFont(type: .Medium, size: 16)
            self.nameLabel.textColor = AppTheme.textColor
        }
    }
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            self.emailLabel.font = UIFont.customFont(type: .Regular, size: 14)
            self.emailLabel.textColor = AppTheme.textColor
        }
    }
    @IBOutlet weak var mobileNumberLabel: UILabel!{
        didSet{
            self.mobileNumberLabel.font = UIFont.customFont(type: .Regular, size: 14)
            self.mobileNumberLabel.textColor = AppTheme.defaltBlueColor //Color.colorDefault
        }
    }
    
    @IBOutlet weak var hideShowLabel: UILabel!{
        didSet{
            self.hideShowLabel.font=UIFont.customFont(type: .Semibold, size: 16)
            self.hideShowLabel.textColor=AppTheme.defaltBlueColor
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bottomHeaderLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    //MARK:Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configure()
    }
 
    
    func configure(){
        self.profileImageView.applyCircular()
        self.onOffSwitch.onTintColor=Color.colorDefault
        self.visiblitltyTitlelabel.text=ProfileVisibiltyConstant.titleText
        let note = NSMutableAttributedString(string:ProfileVisibiltyConstant.noteText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "7f8e94"),NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 14)])
        let bottomAttString = NSAttributedString(string:ProfileVisibiltyConstant.bottomTitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "7f8e94"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
        note.append(bottomAttString)
        self.bottomHeaderLabel.attributedText=note
        self.hideShowLabel.text=ProfileVisibiltyConstant.hide
        
        //These data will come from preferences
        self.profileImageView.image=#imageLiteral(resourceName: "Spark-Hire-Reasons-To-Find-A-New-Recruiter-870x400")
        self.nameLabel.text = "Nikhil bhatia"
        self.emailLabel.text = "Nikhilbhatia@monsterindia.com"
        self.mobileNumberLabel.text = " +91 9871603334"
    }

    //MARK:Hide Show Switch Action
    @IBAction func switchOnOffAction(_ sender: UISwitch) {
        sender.isOn = !sender.isOn
        if sender.isOn{
            self.hideShowLabel.text=ProfileVisibiltyConstant.hide
        }else{
            self.hideShowLabel.text=ProfileVisibiltyConstant.show
        }
    }
    
}
