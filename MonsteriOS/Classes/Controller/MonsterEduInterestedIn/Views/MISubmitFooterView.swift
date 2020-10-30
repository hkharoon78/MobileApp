//
//  MISubmitFooterView.swift
//  MonsteriOS
//
//  Created by Rakesh on 27/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISubmitFooterView: UIView {

    @IBOutlet weak var submit_btn : UIButton! {
        didSet {
            self.submit_btn.titleLabel?.font = UIFont.customFont(type: .Regular, size: 14)
            self.submit_btn.showPrimaryBtn()
        }
    }
    class var footerView : MISubmitFooterView {
        return UINib.init(nibName: "MISubmitFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MISubmitFooterView
    }
   
    func setTitle(title:String) {
        self.submit_btn.setTitle(title, for: .normal)
    }
    
    //MARK: - IBActions
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        
    }

}
