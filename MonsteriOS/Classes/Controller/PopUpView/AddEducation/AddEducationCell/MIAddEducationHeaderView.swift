//
//  MIAddEducationHeaderView.swift
//  MonsteriOS
//
//  Created by Anushka on 10/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIAddEducationHeaderView: UIView {
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var switchONOffLocation: UISwitch!
    @IBOutlet weak var switchImg: UIImageView!

    @IBOutlet weak var topConstraintSwitch: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintSwitch: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintSwitch: NSLayoutConstraint!
    
    var switchAction:((Bool)->Void)?

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
    
    func configure() {
         self.imgLocation.applyCircular()
         self.imgLocation.backgroundColor = UIColor.init(hexString: "f1f1f1", alpha: 1.0)
         self.imgLocation.contentMode = .center
        
        self.switchONOffLocation.tintColor = .clear
        self.switchONOffLocation.backgroundColor = .clear
       
//         self.switchONOffLocation.onImage = #imageLiteral(resourceName: "group-3")
//         self.switchONOffLocation.offImage = #imageLiteral(resourceName: "group-6")
//        self.switchONOffLocation.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
//        self.switchImg.image = #imageLiteral(resourceName: "group-3")
        self.switchImg.isUserInteractionEnabled = false
        self.switchONOffLocation.setOn(false, animated: false)
        self.switchONOffLocation.isOn = false
        self.imgLocation.image = UIImage(named:"group-6")

    }
    
    @IBAction func switchButtonAction(_ sender: UISwitch) {
        if let action = self.switchAction{
            action(sender.isOn)
        }
    }
}
