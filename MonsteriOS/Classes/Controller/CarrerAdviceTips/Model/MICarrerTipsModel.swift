//
//  MICarrerTipsModel.swift
//  MonsteriOS
//
//  Created by Rakesh on 24/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MICarrerTipsModel: NSObject {

    var carrerTipTitle = ""
    var flag  = false
    var carrerTipDescription = ""
    var contentSizeWidth : CGFloat = 0.0
    
    init(title:String,descriptionContent:String = "",isSelected:Bool) {
        self.carrerTipTitle = title
        self.carrerTipDescription = descriptionContent
        self.flag = isSelected
        self.contentSizeWidth = self.carrerTipTitle.width(withConstrainedHeight: 40, font: UIFont.customFont(type: .Regular, size: 12))
    }
}
