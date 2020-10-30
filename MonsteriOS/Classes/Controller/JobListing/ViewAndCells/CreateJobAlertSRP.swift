//
//  CreateJobAlertSRP.swift
//  MonsteriOS
//
//  Created by ishteyaque on 05/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class CreateJobAlertSRP: UIView {

    @IBOutlet weak var onOfSwitch: UISwitch!
    @IBOutlet weak var notificationlabel: UILabel!
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var createJobInnerBgView: UIView!

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
        self.createJobInnerBgView.backgroundColor = AppTheme.defaltBlueColor
        self.onOfSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        notificationlabel.text="Create Job Alert for this search."
    }

    var createAlertAction:((Bool)->Void)?
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if AppDelegate.instance.authInfo.accessToken.isEmpty{
            sender.isOn=false
            if let action=self.createAlertAction{
                action(sender.isOn)
            }
            self.parentViewController?.showLoginAlert(msg:"Please log in to continue.",navaction:.createAlert)
        }else{
            if let action=self.createAlertAction{
                action(sender.isOn)
            }
        }
    }
}
