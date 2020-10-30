//
//  MIJobAppliedSuccesHeader.swift
//  MonsteriOS
//
//  Created by ishteyaque on 07/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIJobAppliedSuccesHeader: UIView {

    @IBOutlet weak var mobileOrEmaiLabel: UILabel!{
        didSet{
            mobileOrEmaiLabel.font=UIFont.customFont(type: .Regular, size: 12)
            mobileOrEmaiLabel.textColor=AppTheme.textColor
        }
    }
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
    }
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
        self.backgroundColor=AppTheme.viewBackgroundColor
        updateButton.setTitle("Update", for: .normal)
        updateButton.showPrimaryBtn(fontSize: 13)
        updateButton.isHidden=true
        
    }
}
