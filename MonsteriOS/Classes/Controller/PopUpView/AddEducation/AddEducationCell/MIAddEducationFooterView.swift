//
//  MIAddEducationFooterView.swift
//  MonsteriOS
//
//  Created by Anushka on 10/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIAddEducationFooterView: UIView {
    
    @IBOutlet weak var btnUpdate: UIButton!
    
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
        self.btnUpdate.layer.cornerRadius = 4.0
        self.btnUpdate.layer.masksToBounds = false
    }


}
