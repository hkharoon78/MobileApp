//
//  MIEmptyHeader.swift
//  MonsteriOS
//
//  Created by Monster on 30/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIEmptyHeader: UIView {
    
    class var header:MIEmptyHeader {
        let header = UINib(nibName: "MIEmptyHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIEmptyHeader
        return header
    }
}
