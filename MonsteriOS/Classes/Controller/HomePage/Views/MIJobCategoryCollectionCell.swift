//
//  MIJobCategoryCollectionCell.swift
//  MonsteriOS
//
//  Created by Anushka on 15/09/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

class MIJobCategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgTopView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backView.roundCorner(1, borderColor: UIColor.colorWith(r: 178, g: 178, b: 178, a: 0.2), rad: CornerRadius.viewCornerRadius)
        self.backgroundColor = UIColor(hex: "f4f6f8")
        
        self.imgTopView.circular(0, borderColor: nil)
        self.imgTopView.backgroundColor = AppTheme.defaltBlueColor
        
    }
    
    
    func showJobCategory(info: MIHomeJobCategory) {
        lblTitle.text = info.name
        imgView.image = UIImage(named: info.imgName)
    }


}
