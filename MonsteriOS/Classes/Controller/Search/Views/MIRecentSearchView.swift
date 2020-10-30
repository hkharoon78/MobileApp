//
//  MIRecentSearchView.swift
//  MonsteriOS
//
//  Created by Piyush on 06/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIRecentSearchView: UIView {
    @IBOutlet weak var clearAll_Btn : UIButton?
    @IBOutlet weak var recentsearch_Btn : UIButton?

    class var header:MIRecentSearchView {
        get {
            return UINib(nibName: "MIRecentSearchView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! MIRecentSearchView
        }
    }
}
