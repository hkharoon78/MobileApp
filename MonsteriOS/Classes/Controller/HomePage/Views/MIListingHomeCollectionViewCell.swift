//
//  MIListingHomeCollectionViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 14/09/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit


class MIListingHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnCompany: UIButton!

   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backView.roundCorner(1, borderColor: UIColor.colorWith(r: 178, g: 178, b: 178, a: 0.2), rad: CornerRadius.viewCornerRadius)
        self.backgroundColor = UIColor(hex: "f4f6f8")
        
        self.btnCompany.isUserInteractionEnabled = false
        

    }
    
 
    func showTopCompanies(compInfo: MIHomeJobTopCompanyModel) {
        self.btnCompany.sd_setImage(with: URL(string: compInfo.logo ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "ic-companyPlaceHolder"), completed: nil)
    }
    

}


