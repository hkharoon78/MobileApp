//
//  MICreateAlertSuccessTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 21/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MICreateAlertSuccessTableViewCell: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var createdAlertTitle: UILabel!
    @IBOutlet weak var createdAlertSubtitle: UILabel!
    @IBOutlet weak var manageButton: UIButton!
    
    var sucessData:CreatedAlertSuccessModel!{
        didSet{
            self.createdAlertTitle.text = sucessData.title
            self.createdAlertSubtitle.text = sucessData.subTitle
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpUI()
    }
    
    func setUpUI(){
        checkIcon.image=#imageLiteral(resourceName: "check-illustration")
        checkIcon.contentMode = .center
       // createdAlertTitle.font=UIFont.customFont(type: .Medium, size: 16)
       // createdAlertTitle.textColor=UIColor.init(hex: "212B36")
       // createdAlertSubtitle.font=UIFont.customFont(type: .Regular, size: 14)
       // createdAlertSubtitle.textColor=UIColor.init(hex: "212B36")
        manageButton.showPrimaryBtn()
        manageButton.setTitle("Manage Alert", for: .normal)
        topView.addShadow(opacity: 0.1)
        self.contentView.backgroundColor = UIColor.init(hex: "f4f6f8")
    }
    
    var manageAction:(()->Void)?
    
    @IBAction func manageButtonAction(_ sender: UIButton) {
        if let action=self.manageAction{
            action()
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class CreatedAlertSuccessModel{
    var title:String?
    var subTitle:String
    init(title:String, subTitle:String) {
        self.title = title
        self.subTitle = subTitle
    }
}
