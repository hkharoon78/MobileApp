//
//  MIJobHomeHeaderView.swift
//  MonsteriOS
//
//  Created by Monster on 22/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIJobHomeHeaderView: UIView {
    
    class var header:MIJobHomeHeaderView {
        get {
            return UINib(nibName: "MIJobHomeHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIJobHomeHeaderView
        }
    }
    
}
