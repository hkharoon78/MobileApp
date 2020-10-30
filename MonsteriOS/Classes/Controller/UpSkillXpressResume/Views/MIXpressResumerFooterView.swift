//
//  MIXpressResumerFooterView.swift
//  MonsteriOS
//
//  Created by Rakesh on 20/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIXpressResumerFooterView: UIView {

    @IBOutlet weak var title_lbl: UILabel! {
        didSet {
            self.title_lbl.textColor = AppTheme.defaltTheme
            self.title_lbl.font = UIFont.customFont(type: .Medium, size: 13)
        }
    }
    @IBOutlet weak var body_lbl : UILabel! {
        didSet {
            self.body_lbl.textColor = UIColor.init(hex: "637381")
            self.body_lbl.font = UIFont.customFont(type: .Regular, size: 13)

        }
    }

    class var footerView:MIXpressResumerFooterView {
        return UINib.init(nibName: "MIXpressResumerFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIXpressResumerFooterView
        
    }
    func setTitleBodyContent(title:String,bodyContent:String) {
      //  self.backgroundColor = .clear
        self.title_lbl.text = title
        self.body_lbl.text = bodyContent
    }
    

}
