//
//  MIHomeEmploymentIndexCollectionCell.swift
//  MonsteriOS
//
//  Created by Anushka on 21/09/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

class MIHomeEmploymentIndexCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnUrlLink: UIButton!
    
    var learnMoreCallBack: (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.roundCorner(0, borderColor: nil, rad: CornerRadius.viewCornerRadius)
        self.backView.roundCorner(0, borderColor: nil, rad: CornerRadius.viewCornerRadius)
        self.btnUrlLink.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
    }
    
    func show(info:MIHomeEmploymentIndex) {
        self.lblTitle.text = info.title
        self.lblDesc.text  = info.ttlDescription
        self.imgView.image = UIImage(named: info.imgName)
        self.btnUrlLink.setTitle(info.titleLink, for: .normal)
        //self.url = info.url
      //  self.controllerTitle = info.controllerTitle
        var strArray = info.title.components(separatedBy: " ")
        if strArray.count > 1 {
            strArray.removeFirst()
            let boldString = strArray.joined(separator: " ")
            self.lblTitle.showAttributedTxt(semibold: boldString)
        }
    }
    
    @IBAction func learnMorePressed(_ sender: UIButton){
        self.learnMoreCallBack?()
    }

}
