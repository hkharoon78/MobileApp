//
//  MITextFieldLineView.swift
//  MonsteriOS
//
//  Created by Monster on 15/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MITextFieldLineView: UIView {
    override func awakeFromNib() {
        self.backgroundColor = UIColor.colorWith(r: 140, g: 139, b: 141, a: 0.4)
    }
    
    func selectedColor() {
        self.backgroundColor = UIColor.colorWith(r: 140, g: 139, b: 141, a: 0.4)
    }

}
