//
//  MISuggestionCollectionCell.swift
//  MonsteriOS
//
//  Created by Monster on 17/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISuggestionCollectionCell: UICollectionViewCell {
    @IBOutlet weak private var topView: UIView!
    @IBOutlet weak private var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topView.layer.cornerRadius = 15
        topView.layer.borderWidth  = 1
        topView.layer.borderColor  = UIColor.colorWith(r: 103, g: 58, b: 183, a: 1.0).cgColor
    }

    func show(ttl:String) {
        titleLbl.text = ttl
        self.layoutIfNeeded()
        
        
    }
}
