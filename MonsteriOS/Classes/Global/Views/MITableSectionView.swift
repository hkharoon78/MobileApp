//
//  MITableSectionView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 15/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MITableSectionView: UIView {

    @IBOutlet weak var sectionTitlelabel: UILabel!
    
    @IBOutlet weak var viewAllButton: UIButton!
    var viewAllAction:(()->Void)?
    
    @IBAction func viewAllButtonAction(_ sender: UIButton) {
        if let action=viewAllAction{
            action()
        }
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
        sectionTitlelabel.font=UIFont.customFont(type:.Semibold, size: 16)
        sectionTitlelabel.textColor = AppTheme.textColor
        viewAllButton.titleLabel?.font=UIFont.customFont(type: .Semibold, size: 14)
        viewAllButton.setTitle("VIEW ALL", for: .normal)
        viewAllButton.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
    }

}
