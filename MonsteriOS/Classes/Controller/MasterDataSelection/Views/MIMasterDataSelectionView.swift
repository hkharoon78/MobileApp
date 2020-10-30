//
//  MIMasterDataSelectionView.swift
//  MonsteriOS
//
//  Created by Piyush on 02/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MIMasterDataSelectionViewDelegate:class {
    func removeListItem(item:String)
}

class MIMasterDataSelectionView: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    weak var delegate:MIMasterDataSelectionViewDelegate?
    class var selectedView:MIMasterDataSelectionView {
        get {
            return UINib(nibName: "MIMasterDataSelectionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIMasterDataSelectionView
        }
    }
    func show(ttl:String) {
        titleLbl.text = ttl
        titleLbl.setNeedsLayout()
        self.backgroundColor = AppTheme.defaltBlueColor
        self.layer.cornerRadius = 4
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @IBAction func closeClicked(_ sender: UIButton) {
        self.delegate?.removeListItem(item: self.titleLbl.text ?? "")
    }
}
