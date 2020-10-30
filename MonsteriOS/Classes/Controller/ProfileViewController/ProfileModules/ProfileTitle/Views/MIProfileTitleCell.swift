//
//  MIProfileTitleCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 24/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField.JVFloatLabeledTextView

class MIProfileTitleCell: UITableViewCell {

    @IBOutlet weak var profileTitle_TxtView : JVFloatLabeledTextView!{
        didSet{
            profileTitle_TxtView.font=UIFont.customFont(type: .Regular, size: 15)
            profileTitle_TxtView.placeholderTextColor = UIColor.lightGray
            profileTitle_TxtView.floatingLabelTextColor = AppTheme.defaltTheme
            profileTitle_TxtView.floatingLabelActiveTextColor = AppTheme.defaltTheme
            profileTitle_TxtView.textColor=AppTheme.textColor
            profileTitle_TxtView.floatingLabelFont=UIFont.customFont(type: .Regular, size: 15)
            profileTitle_TxtView.isScrollEnabled=false
        }
    }
    @IBOutlet weak var charaterCount_Lbl : UILabel!
    @IBOutlet weak var qutnMark_Btn : UIButton!
    @IBOutlet weak var txtf_trailingConstraint : NSLayoutConstraint!
    @IBOutlet weak var info_lbl : UILabel!
    var infoMsgCallBack :(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showInfoPopup(message:String) {
        let controller = MIInfoPopOverController()
        controller.message = message
        controller.preferredContentSize = CGSize(width: self.bounds.size.width, height: 110)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = qutnMark_Btn
        presentationController.sourceRect = qutnMark_Btn.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.superview?.parentViewController?.present(controller, animated: true)
    }
    
    @IBAction func questionMarkAction(_ sender : UIButton) {
        self.infoMsgCallBack?()
//        let controller = MIInfoPopOverController()
//        controller.preferredContentSize = CGSize(width: self.bounds.size.width, height: 110)
//        showPopup(controller, sourceView: self.qutnMark_Btn)
    }
}
