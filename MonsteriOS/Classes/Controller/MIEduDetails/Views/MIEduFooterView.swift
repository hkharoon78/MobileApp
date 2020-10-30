//
//  MIEduFooterView.swift
//  MonsteriOS
//
//  Created by Rakesh on 21/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
protocol CertifiedCourseTechnologyDelegate {
    func requestInfoOnCourse()
    func buyNowCourse()
}

class MIEduFooterView: UIView {
    
    var delegate : CertifiedCourseTechnologyDelegate? = nil
    
    @IBOutlet weak var backgroundView : UIView! {
        didSet {
         //   self.backgroundView.addShadow(opacity: 0.5)
        }
    }
    
    @IBOutlet weak var requestInfo_Btn : UIButton! {
        didSet {
            self.requestInfo_Btn.setTitleColor(AppTheme.defaltTheme, for: .normal)
            self.requestInfo_Btn.titleLabel?.font = UIFont.customFont(type: .Medium, size: 16)
        }
    }
    @IBOutlet weak var buyNow_Btn : UIButton! {
        didSet {
            self.buyNow_Btn.showPrimaryBtn()
        }
    }
    class var footerView:MIEduFooterView {
        return  UINib.init(nibName: "MIEduFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIEduFooterView
    }

    //MARK: - IBAction Methods
    @IBAction func requestInfoClicked(_ sender : UIButton) {
        if self.delegate != nil {
            self.delegate?.requestInfoOnCourse()
        }
    }
    @IBAction func buyNowClicked(_ sender : UIButton) {
        if self.delegate != nil {
            self.delegate?.buyNowCourse()
        }
    }
}
