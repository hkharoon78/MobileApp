//
//  MILoginRememberMeCell.swift
//  MonsteriOS
//
//  Created by Monster on 16/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MILoginRememberMeCell: UITableViewCell {

    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var titleLblLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var btnForgotPassword: UIButton!
    
    var forPasswordClicked: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.btnForgotPassword.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
    }
    
    func show(info:MILoginModel, shouldHideForgotBtn:Bool = false) {
        self.titleLbl.text      = info.title
        self.titleLbl.textColor = Color.colorTextLight
        self.imgView.image = UIImage(named: info.leftImgNm)
        if info.leftImgNm.isEmpty {
            titleLblLeadingConstraint.constant = 15
        }
        
        btnForgotPassword.isHidden = shouldHideForgotBtn
    }
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        self.forPasswordClicked?()
    }
    
}
