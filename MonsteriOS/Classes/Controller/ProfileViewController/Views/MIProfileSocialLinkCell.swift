//
//  MIProfileSocialLinkCell.swift
//  MonsteriOS
//
//  Created by Piyush on 14/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MIProfileSocialLinkCellDelegate:class {
    func socialLinkClicked(link: String)
}

class MIProfileSocialLinkCell: MIProfileTableCell {
    
    @IBOutlet weak var viewLineTop : UIView!
    @IBOutlet weak var viewCircular: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblTtl: UILabel!
    @IBOutlet weak var linkBtn: UIButton!
    @IBOutlet weak var lblTtlStatus: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var type = MIProfileEnums.project
    var modelsInfo = [Any]()
    weak var delegate:MIProfileConnectedCellDelegate?
    weak var socialDelegate:MIProfileSocialLinkCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCircular.circular(2, borderColor: AppTheme.defaltBlueColor)
        linkBtn.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
    }
    
    func show(info:MIProfileOnlinePresence) {
        lblTtl.text    = info.title
        linkBtn.setTitle(info.url, for: .normal)
        lblTtlStatus.text = info.ttlDescription
        self.viewLine.backgroundColor = AppTheme.defaltBlueColor//UIColor(hex: "5C4AAE")
        self.viewLineTop.backgroundColor = AppTheme.defaltBlueColor//UIColor(hex: "5C4AAE")
        
        type = MIProfileEnums.onlinePresence
        modelsInfo = [info]
    }
    
    func hideLine() {
        self.viewLine.backgroundColor = UIColor.clear
    }
    
    func hideTopLine() {
        self.viewLineTop.backgroundColor = UIColor.clear
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.delegate?.connectedCellEditClicked(type: type, modelInfo: modelsInfo, sender: sender as! UIView)
    }
    
    @IBAction func linkClicked(_ sender: UIButton) {
        if let linkTxt = self.linkBtn.titleLabel?.text {
            self.socialDelegate?.socialLinkClicked(link: linkTxt)
        }
    }
}
