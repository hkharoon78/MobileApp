//
//  MIIconTitleHeaderView.swift
//  MonsteriOS
//
//  Created by Rakesh on 04/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIIconTitleHeaderView: UIView {

    @IBOutlet weak var icon_imgView : UIImageView!
    @IBOutlet weak var title_Lbl :UILabel!
    
    class var headerView : MIIconTitleHeaderView {
        return  UINib.init(nibName: "MIIconTitleHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIIconTitleHeaderView
    }
    
    func showDataWithImg(icon:UIImage,title:String) {
        self.icon_imgView.image = icon
        self.title_Lbl.text = title
    }
}
