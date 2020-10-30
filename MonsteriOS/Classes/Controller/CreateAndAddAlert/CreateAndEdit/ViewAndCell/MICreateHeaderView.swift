//
//  MICreateHeaderView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 26/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MICreateHeaderView: UIView {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.numberOfLines = 0
            titleLabel.font=UIFont.customFont(type: .Regular, size: 14)
            titleLabel.textColor=AppTheme.textColor
        }
    }
    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var imgWidthConstriant: NSLayoutConstraint!
    @IBOutlet weak var lblLeadingConstraint: NSLayoutConstraint!
    
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
    }

}
