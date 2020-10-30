//
//  MISelectionTitleHeaderView.swift
//  MonsteriOS
//
//  Created by Rakesh on 18/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISelectionTitleHeaderView: UIView {

    @IBOutlet  weak var title_lbl:UILabel! {
        didSet{
            self.title_lbl.textColor = AppTheme.lightGrayColor
            self.title_lbl.font = UIFont.customFont(type: .Regular, size: 16)
        }
    }
    
    @IBOutlet  weak var subTitle_lbl:UILabel! {
        didSet{
            self.subTitle_lbl.textColor = AppTheme.lightGrayColor
            self.subTitle_lbl.font = UIFont.customFont(type: .Regular, size: 16)
        }
    }
    class var headerSectionView :UIView {
        return UINib.init(nibName: "MISelectionTitleHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MISelectionTitleHeaderView
    }
    
    func setHeadingTitleSubTitle(title:String,subTitle:String){
        self.title_lbl.text = title
        self.subTitle_lbl.text = subTitle
    }
    
}
