//
//  MIJobHomeCell.swift
//  MonsteriOS
//
//  Created by Monster on 22/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIJobHomeCell: UITableViewCell {

    @IBOutlet weak private var topView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.backgroundColor = UIColor.white
        self.selectionStyle = .none
        self.topView.layer.borderColor = UIColor.colorWith(r: 0, g: 0, b: 0, a: 0.12).cgColor
        self.topView.layer.borderWidth = 0.5
//        self.topView.addShadow()
        
//        self.topView.layer.shouldRasterize = true
//        self.topView.layer.masksToBounds = false
//        self.topView.layer.shadowOpacity = 1
//        self.topView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
//
//        self.topView.layer.shadowRadius = 1
//        topView.layer.shadowOffset = CGSize.zero
//        self.topView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        
//        topView.layer.masksToBounds = false
//        topView.layer.shadowRadius = 4
//        topView.layer.shadowOpacity = 1
//        topView.layer.shadowColor = UIColor.gray.cgColor
//        topView.layer.shadowOffset = CGSize(width: 0 , height:2)
        
            self.topView.addShadow()
    }
    
    
}
