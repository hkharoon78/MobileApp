//
//  MIProfileImprovementHeader.swift
//  MonsteriOS
//
//  Created by Rakesh on 18/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProfileImprovementHeader: UIView {

    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var lbl_description:UILabel!
    @IBOutlet weak var img_logo:UIImageView!

    class var header : MIProfileImprovementHeader {
        return  UINib(nibName: "MIProfileImprovementHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIProfileImprovementHeader
        
    }
    
    func setHeaderViewWithTitle(title:String,imgName:String) {
        self.lbl_title.text = title
       // self.lbl_title.textColor = UIColor()
        // headerView.lbl_description.text = "Surveys indicate that 68% of recruiters search candidates based on role/designation"
        self.img_logo.roundCorner(0, borderColor: .clear, rad: self.img_logo.frame.size.height/2)
        self.img_logo.backgroundColor = UIColor(hex: "f1f1f1")
        self.img_logo.image = UIImage(named: imgName)

    }
    
}
