//
//  MIJobDetailTitleTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 16/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIJobDetailTitleTableViewCell: UITableViewCell {
    
    //MARK:Outlets And Variables
    
    //MARK:Outlets And Variables
    @IBOutlet weak var companyImageWidth: NSLayoutConstraint!
    @IBOutlet weak var proLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var walkinLabel: UILabel!
    
    @IBOutlet weak var tagListViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tagListView: AKTagListView!
    @IBOutlet weak var addSkillsButton: UIButton!
    
    @IBOutlet weak var jobTitleLabel: UILabel!{
        didSet{
            jobTitleLabel.font=UIFont.customFont(type: .Medium, size: 16)
            jobTitleLabel.textColor=AppTheme.textColor
            //jobTitleLabel.textAlignment = .justified
        }
    }
    
    @IBOutlet weak var companyIconImageView: UIImageView!
    
    @IBOutlet weak var postedDataLabel: UILabel!{
        didSet{
            postedDataLabel.font=UIFont.customFont(type: .Regular, size: 12)
            postedDataLabel.textColor=UIColor.init(hex: "8894a2")
        }
    }
    @IBOutlet weak var totalViewLabel: UILabel!{
        didSet{
            totalViewLabel.font=UIFont.customFont(type: .Regular, size: 12)
            totalViewLabel.textColor=UIColor.init(hex: "8894a2")
        }
    }
    
    @IBOutlet weak var companyTitleLabel: UILabel!{
        didSet{
            companyTitleLabel.font=UIFont.customFont(type: .Medium, size: 14)
            companyTitleLabel.textColor = AppTheme.defaltBlueColor
        }
    }
    
    @IBOutlet weak var jobIdLabel: UILabel! {
        didSet{
            jobIdLabel.font=UIFont.customFont(type: .Medium, size: 12)
            jobIdLabel.textColor=UIColor.init(hex: "637381")
        }
    }
    @IBOutlet weak var numberOfApplicationLabel: UILabel!{
        didSet{
            numberOfApplicationLabel.font=UIFont.customFont(type: .Medium, size: 12)
            numberOfApplicationLabel.textColor=UIColor.init(hex: "637381")
        }
    }
    
    @IBOutlet weak var locationNameLabel : UILabel!{
        didSet{
            locationNameLabel.font=UIFont.customFont(type: .Regular, size: 14)
            locationNameLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212b36")
        }
    }
    
    @IBOutlet weak var experienceLabel: UILabel!{
        didSet{
            experienceLabel.font=UIFont.customFont(type: .Regular, size: 14)
            experienceLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212b36")
        }
    }
    
    @IBOutlet weak var salaryIcon: UIImageView!
    
    @IBOutlet weak var salaryLabel: UILabel!{
        didSet{
            salaryLabel.font=UIFont.customFont(type: .Regular, size: 14)
            salaryLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212b36")
        }
    }
    
    @IBOutlet weak var skillMatch: UILabel! {
        didSet {
            skillMatch.font = UIFont.customFont(type: .Regular, size: 14)
            skillMatch.textColor = AppTheme.textColor
        }
    }
    
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var experienceIcon: UIImageView!
    @IBOutlet weak var skillIcon: UIImageView!
    var companyDetailAction:(()->Void)?
    var addSkillAction:(([MIAutoSuggestInfo])->Void)?
    
    private var unMatchedSkills = [MIAutoSuggestInfo]()
    
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        locationIcon.image=#imageLiteral(resourceName: "search_location_icon")
        experienceIcon.image = #imageLiteral(resourceName: "jobexp-ico")
        skillIcon.image = #imageLiteral(resourceName: "skill-ico")
        salaryIcon.image = #imageLiteral(resourceName: "coin")
        
        
        companyTitleLabel.isUserInteractionEnabled=true
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(comapnyDetailsAction(_:)))
        tapGest.numberOfTapsRequired=1
        companyTitleLabel.addGestureRecognizer(tapGest)
        
        self.walkinLabel.backgroundColor = AppTheme.defaltBlueColor
        self.walkinLabel.layer.cornerRadius = 10
        self.walkinLabel.layer.masksToBounds = true
        self.companyIconImageView.applyCircular()
    }
    
    func populateData(_ modelData: JoblistingCellModel, userSkills: [MIUserSkills]) {
      
        self.jobTitleLabel.text=modelData.summary
        self.companyTitleLabel.text=modelData.companyTitle
        self.locationNameLabel.text=modelData.detailsViewLocation
        self.experienceLabel.text=modelData.experienceTitle
        self.postedDataLabel.text = modelData.jobDetailsPostedDate
        self.jobIdLabel.text=modelData.displayKiwiJobID
        self.numberOfApplicationLabel.text=modelData.numberOfApplication
        // self.totalViewLabel.text=modelData.totalViews
        self.salaryLabel.text=modelData.salaryTitle
        self.companyIconImageView.setImage(with:modelData.companyIconURL, placeholder: defaultCompanyIcon)
        if modelData.companyIconURL == nil || modelData.companyIconURL?.count == 0 {
            self.companyImageWidth.constant=0
        }
        if modelData.isWalkInPro{
            self.walkinLabel.isHidden=false
            self.proLabelHeight.constant = 30
        }else{
            self.walkinLabel.isHidden=true
            self.proLabelHeight.constant = 0
        }
        if modelData.isWalkIn{
            self.postedDataLabel.text = modelData.walkInDate
        }
        
        let skillTitle = modelData.allSkills.map({ $0.name.withoutWhiteSpace() })
        
        let userSkillArray = userSkills.map({ $0.skillName.withoutWhiteSpace().lowercased() })
        let jdSkillSet = Set( skillTitle.map({$0.lowercased()}) )
        let matchedSkills = jdSkillSet.intersection(userSkillArray)

        unMatchedSkills = modelData.allSkills.filter({ !matchedSkills.contains($0.name.withoutWhiteSpace().lowercased()) })
        
        if !CommonClass.isLoggedin() || (matchedSkills.count == jdSkillSet.count) {
            self.addSkillsButton.isHidden = true
        } else {
            self.addSkillsButton.isHidden = false
        }
        
        var skills:[(skill: String, match: Bool)] = skillTitle.map { str -> (String, Bool) in
            return (str, matchedSkills.contains(str.lowercased()))
        }
        skills = skills.sorted(by: { $0.match.int > $1.match.int })
        self.tagListView.removeAllTags()
        for item in skills {
            let image = item.match ?  #imageLiteral(resourceName: "star-matched") : #imageLiteral(resourceName: "star-gray")
            let tagItem = AKTag(id: item.skill, name: item.skill, typeImage: image)
            self.tagListView.addTag(tagItem)
        }
       
        
        self.tagListViewHeight.constant = self.tagListView.getContentHeight()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            guard self.notReused else { return }
            self.tableView?.reloadData()
        }
                
        if CommonClass.isLoggedin()  {
            guard !jdSkillSet.isEmpty else {
                
                self.skillMatch.text = "Skills are not mentioned for this job."
                self.addSkillsButton.isHidden = true
                self.tagListViewHeight.constant = -100

                return
            }
            var colorToUse: UIColor = UIColor(hex: 0x212b36)
            let matchPercantage = matchedSkills.count * 100 / jdSkillSet.count
            if matchPercantage > CommonClass.matchingSkillPercentageForJD {
                colorToUse = UIColor(hex: 0x30b248)
            }
           // You match 5 out of the 8 skills required for this job.
            let middleText = " \(matchedSkills.count) out of the \(jdSkillSet.count) "
            let middleAttributed = NSMutableAttributedString(string: middleText, attributes: [NSAttributedString.Key.foregroundColor : colorToUse, NSAttributedString.Key.font: UIFont.customFont(type: .Bold, size: 14)])

            let attibuted1 = NSMutableAttributedString(string: "You match", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: 0x212b36), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 14)])
            let attibuted2 = NSMutableAttributedString(string: "skills required for this job.", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: 0x212b36), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 14)])

            attibuted1.append(middleAttributed)
            attibuted1.append(attibuted2)
            self.skillMatch.attributedText = attibuted1

        } else {
            let attibuted1 = NSMutableAttributedString(string: "Log-In ", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: 0x212b36), NSAttributedString.Key.font: UIFont.customFont(type: .Bold, size: 14)])
            let attibuted2 = NSMutableAttributedString(string: "to see how you match with the preferred skills", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: 0x212b36), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 14)])
            attibuted1.append(attibuted2)

            self.skillMatch.attributedText = attibuted1
        }
    }
    
    var notReused = true
    override func prepareForReuse() {
        super.prepareForReuse()
        notReused = false

        self.companyImageWidth.constant = 65
    }
    
    @objc func comapnyDetailsAction(_ sender:UITapGestureRecognizer){
        CommonClass.googleEventTrcking("job_detail_screen", action: "company_name", label: "")
        if let action=companyDetailAction,self.companyTitleLabel.text != companyConfidential{
            action()
        }
    }
    
    @IBAction func addSkillAction(_ sender: UIButton) {
        self.addSkillAction?(unMatchedSkills)
    }
}

