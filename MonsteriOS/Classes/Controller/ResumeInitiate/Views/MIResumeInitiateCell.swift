//
//  MIResumeInitiateCell.swift
//  MonsteriOS
//
//  Created by Monster on 26/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIResumeInitiateInfo:NSObject {
    var imgNm       = ""
    var title       = ""
    var titleInfo   = ""
    var titleDetail = ""
    init(with imgName:String,ttl:String,ttlInfo:String,titleDt:String) {
        self.imgNm       = imgName
        self.title       = ttl
        self.titleInfo   = ttlInfo
        self.titleDetail = titleDt
    }
}

class MIResumeInitiateCell: UITableViewCell {

    @IBOutlet weak private var topView: UIView!
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak private var titleInfoLbl: UILabel!
    @IBOutlet weak private var detailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.topView.layer.cornerRadius = CornerRadius.viewCornerRadius
        self.topView.addShadow(opacity: 0.2)
    }
    
    func showUI(info:MIResumeInitiateInfo) {
        self.imgView.image = UIImage(named: info.imgNm)
        self.titleBtn.showSecondaryBtn(ttl: info.title)
        self.titleInfoLbl.text = info.titleInfo
        self.detailLbl.text    = info.titleDetail
    }
    
}
