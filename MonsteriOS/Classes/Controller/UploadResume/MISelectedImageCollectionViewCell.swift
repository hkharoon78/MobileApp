//
//  MISelectedImageCollectionViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 13/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISelectedImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var deleteAction:(()->Void)?
    @IBAction func deleteAction(_ sender: UIButton) {
        if let action=deleteAction{
            action()
        }
    }
}
