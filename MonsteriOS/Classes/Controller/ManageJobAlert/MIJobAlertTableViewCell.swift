//
//  MIJobAlertTableViewCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 19/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import DropDown
class MIJobAlertTableViewCell: UITableViewCell {

//    @IBOutlet weak var salaryView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editBtnHt_Constraint: NSLayoutConstraint!
    
//    @IBOutlet weak var locationTitleLbl: UILabel!
    
    @IBOutlet weak var postLabel: UILabel!{
        didSet{
            postLabel.font=UIFont.customFont(type: .Semibold, size: 16)
            //postLabel.textColor = AppTheme.textColor
        }
    }
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var keywordLabel: UILabel!{
        didSet{
            keywordLabel.font=UIFont.customFont(type: .Medium, size: 14)
        }
    }
    @IBOutlet weak var locationLabel: UILabel!{
        didSet{
            locationLabel.font=UIFont.customFont(type: .Medium, size: 14)
        }
    }
//    @IBOutlet weak var experienceLabel: UILabel!{
//        didSet{
//            experienceLabel.font=UIFont.customFont(type: .Regular, size: 14)
//        }
//    }
//    @IBOutlet weak var salaryLabel: UILabel!{
//        didSet{
//            salaryLabel.font=UIFont.customFont(type: .Regular, size: 14)
//        }
//    }
//    @IBOutlet weak var funcAreaLabel: UILabel!{
//        didSet{
//            funcAreaLabel.font=UIFont.customFont(type: .Regular, size: 14)
//        }
//    }
//    @IBOutlet weak var roleLabel: UILabel!{
//        didSet{
//            roleLabel.font=UIFont.customFont(type: .Regular, size: 14)
//        }
//    }
//    @IBOutlet weak var industryLabel: UILabel!{
//        didSet{
//            industryLabel.font=UIFont.customFont(type: .Regular, size: 14)
//        }
//    }
    
    let dropDown=DropDown()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.addShadow(opacity: 0.4)
        self.selectionStyle = .none
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.cellHeight = 40
        dropDown.selectionBackgroundColor = .white
        dropDown.separatorColor = .lightGray
        dropDown.textFont=UIFont.customFont(type: .Regular, size: 14)
        dropDown.backgroundColor = .white
        dropDown.textColor=AppTheme.textColor
        dropDown.dataSource = ["View Jobs","Edit","Delete"]
        self.setUpDropDown()

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.dropDown.anchorView=editButton
        self.dropDown.width=400
        self.dropDown.bottomOffset = CGPoint(x: -80, y:(self.dropDown.anchorView?.plainView.bounds.height)!)
        self.dropDown.topOffset = CGPoint(x:-80, y:-(self.dropDown.anchorView?.plainView.bounds.height)!)
    }
    var editOrDeleteAction:((Int)->Void)?
    func setUpDropDown(){
        dropDown.selectionAction = {  (index: Int, item: String) in
            
            if let action=self.editOrDeleteAction{
                action(index)
            }
            
        }
        dropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Helper methods
    func showDataWithModel(obj:JobAlertModel) {
        self.postLabel.text = obj.alertName
        self.keywordLabel.text = obj.keywords
        self.locationLabel.text = (obj.desiredLocation?.isEmpty ?? true) ? " " : obj.desiredLocation
//        self.experienceLabel.text = obj.experienceTitle
//        self.salaryLabel.text = obj.salaryTitle
//        self.funcAreaLabel.text = obj.functionalArea
//        self.roleLabel.text = obj.role
//        self.industryLabel.text = obj.industry
        
//        self.locationTitleLbl.isHidden = (obj.desiredLocation ?? "").isEmpty
//        self.locationLabel.isHidden = (obj.desiredLocation ?? "").isEmpty
        //let predicate = NSPredicate(format: "selected == %@", NSNumber(value: true))
       // let site = AppDelegate.instance.site

//        if site?.defaultCountryDetails.isoCode == "IN" {
//            self.salaryView.isHidden=false
//            //self.salaryLabel.isHidden=false
//        }else{
//            self.salaryView.isHidden=true
//           // self.salaryLabel.isHidden=true
//        }
    }
    func showEditReplaceOption(flowVia:ManageAlertFlowVia) {
        if flowVia == .ManageAlert {
            editButton.backgroundColor = .white
            editButton.layer.borderColor = UIColor.white.cgColor
            editButton.layer.borderWidth = 0
            editButton.layer.masksToBounds = false
            editButton.setTitle(nil, for: .normal)
            editButton.setImage(#imageLiteral(resourceName: "more-menufill-ico"), for: .normal)
        }else{
            editButton.showPrimaryBtn()
            editButton.setImage(nil, for: .normal)
            editButton.setTitle("    Replace    ", for: .normal)
            editBtnHt_Constraint.constant = 0.5
        }
    }
}
