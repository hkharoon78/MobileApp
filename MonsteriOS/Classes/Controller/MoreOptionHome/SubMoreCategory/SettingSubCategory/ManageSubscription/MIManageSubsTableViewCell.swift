//
//  MIManageSubsTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import DropDown

class MIManageSubsTableViewCell: UITableViewCell {

    //MARK:Outlets And Variables
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            self.emailLabel.font=UIFont.customFont(type: .Medium, size: 14)
        }
    }
    @IBOutlet weak var smsLabel: UILabel!{
        didSet{
            self.smsLabel.font=UIFont.customFont(type: .Medium, size: 14)
        }
    }
    @IBOutlet weak var pushNotiLabel: UILabel!{
        didSet{
            self.pushNotiLabel.font=UIFont.customFont(type: .Medium, size: 14)
        }
    }
    @IBOutlet weak var smsSwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var dropDownTextField: UITextField!
    let dropDown = DropDown()
    
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configure()
        self.setUpDropDown()
    }
    func configure(){
        emailLabel.text=ManageSubsCellConstant.email
        smsLabel.text=ManageSubsCellConstant.sms
        pushNotiLabel.text=ManageSubsCellConstant.pushNoti
        smsSwitch.onTintColor=Color.colorDefault
        notificationSwitch.onTintColor=Color.colorDefault
        dropDownTextField.font=UIFont.customFont(type: .Regular, size: 14)
        dropDownTextField.textColor=AppTheme.textColor//UIColor.init(hex: "212b36")
        dropDownTextField.text="Weekly"
        let imageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image=#imageLiteral(resourceName: "bottom_direction_arrow")
        imageView.contentMode = .center
        dropDownTextField.rightViewMode = .always
        dropDownTextField.rightView=imageView
        dropDownTextField.delegate=self
        self.dropDown.anchorView=dropDownTextField
        self.dropDown.bottomOffset = CGPoint(x: 0, y:((self.dropDown.anchorView?.plainView.bounds.height)!))
        self.dropDown.topOffset = CGPoint(x: 0, y:-((self.dropDown.anchorView?.plainView.bounds.height)!))
        
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(MIManageSubsTableViewCell.textFieldTapAction(_:)))
        tapGest.numberOfTapsRequired=1
        dropDownTextField.addGestureRecognizer(tapGest)
    }
    
    //MARK:Drop Down Show Gesture
   @objc func textFieldTapAction(_ sender:UITapGestureRecognizer){
        self.dropDown.show()
    }

    func setUpDropDown(){
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.cellHeight = 40
        dropDown.selectionBackgroundColor = .white
        dropDown.separatorColor = .lightGray
        dropDown.textFont=UIFont.customFont(type: .Regular, size: 14)
        dropDown.backgroundColor = .white
        dropDown.textColor=AppTheme.textColor
        var dataSource=[String]()
        for item in ManageSubscriptionDropDownData.allCases{
            dataSource.append(item.rawValue)
        }
        dropDown.dataSource=dataSource
        dropDown.selectionAction = {  (index: Int, item: String) in
            self.dropDownTextField.text=item
        }
        dropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
    }
    
    
}

//MARK:UITextField Delegate Method
extension MIManageSubsTableViewCell:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
