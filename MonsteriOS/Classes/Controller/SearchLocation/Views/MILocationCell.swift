//
//  MILocationCell.swift
//  MonsteriOS
//
//  Created by Piyush on 05/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MILocationInfo:NSObject {
    
    var id = ""
    var name = ""
    var aliases = ""
    var suggestType = ""
    var createdAt = ""
    var imgNm = ""
    var isSelected = false
    init(dic: [String:Any]) {
        id    = dic.stringFor(key: "id")
        name = dic.stringFor(key: "name")
        aliases = dic.stringFor(key: "aliases")
        suggestType = dic.stringFor(key: "type")
        createdAt   = dic.stringFor(key: "createdAt")
    }
    
    init(with ttl:String,imgName:String = "") {
        self.name  = ttl
        self.imgNm = imgName
    }
}

class MILocationCell: UITableViewCell {

    @IBOutlet weak private var titleLbl:UILabel!
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var titleLblLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func show(info:MILocationInfo) {
        if info.imgNm.isEmpty {
            titleLblLeadingConstraint.constant = 15
        }
        titleLbl.text = info.name
        imgView.image = UIImage(named: info.imgNm)
    }
}
