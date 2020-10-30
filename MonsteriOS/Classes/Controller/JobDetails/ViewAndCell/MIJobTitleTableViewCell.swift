//
//  MIJobTitleTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 16/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIJobTitleTableViewCell: UITableViewCell {
    
    //MARK:Outlets And Variables
    
    //MARK:Outlets And Variables
    @IBOutlet weak var companyImageWidth: NSLayoutConstraint!
    @IBOutlet weak var proLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var walkinLabel: UILabel!
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
    
    @IBOutlet weak var locationNameLabel: UILabel!{
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
    
    @IBOutlet weak var skillLabel: UILabel!{
        didSet{
            skillLabel.font=UIFont.customFont(type: .Regular, size: 14)
            skillLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212b36")
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
            skillMatch.textColor = AppTheme.defaultGreenColor
        }
    }
//    var jobDetailTitle:JobDetailsTitle!{
//        didSet{
//            self.jobTitleLabel.text=jobDetailTitle.jobTitle
//            self.companyTitleLabel.text=jobDetailTitle.companyTitle
//            self.numberOfApplicationLabel.text=jobDetailTitle.appliedApp
//            self.locationNameLabel.text=jobDetailTitle.locationTitle
//            self.experienceLabel.text=jobDetailTitle.experience
//            self.skillLabel.text=jobDetailTitle.skill
//            self.companyIconImageView.image = #imageLiteral(resourceName: "img4184425241664419016")
//            self.postedDataLabel.text="Posted on : 29 Sep 2018"
//            self.totalViewLabel.text="Total Views : 364"
//
//        }
//    }
    
    
    var modelData:JoblistingCellModel!{
        didSet{
            self.jobTitleLabel.text=modelData.summary
            self.companyTitleLabel.text=modelData.companyTitle
            self.locationNameLabel.text=modelData.detailsViewLocation
            self.experienceLabel.text=modelData.experienceTitle
            self.skillLabel.text=modelData.allSkills.map({$0.name}).joined(separator: ", ")
            self.postedDataLabel.text = modelData.jobDetailsPostedDate
            self.jobIdLabel.text=modelData.displayKiwiJobID
            self.numberOfApplicationLabel.text=modelData.numberOfApplication
           // self.totalViewLabel.text=modelData.totalViews
            self.salaryLabel.text=modelData.salaryTitle
            self.companyIconImageView.setImage(with:modelData.companyIconURL, placeholder: defaultCompanyIcon)
            if modelData.companyIconURL == nil || modelData.companyIconURL?.count == 0{
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
            
            if CommonClass.isLoggedin() {
                self.jdSkillsName = modelData.allSkills.map({$0.name})
            }
            //self.filterSkill(jdSkillName: modelData.skillTitle ?? "")
       
        }

    }
    
    
    
    var jdSkillsName: [String] = []
    {
        didSet {
            self.filterSkill(jdSkillName: jdSkillsName)
        }
    }
    
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var experienceIcon: UIImageView!
    @IBOutlet weak var skillIcon: UIImageView!
    var companyDetailAction:(()->Void)?

    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        locationIcon.image=#imageLiteral(resourceName: "search_location_icon")
        experienceIcon.image = #imageLiteral(resourceName: "jobexp-ico")
        skillIcon.image = #imageLiteral(resourceName: "skill-ico")
        salaryIcon.image = #imageLiteral(resourceName: "coin")
        
        
        companyTitleLabel.isUserInteractionEnabled=true
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(MIJobTitleTableViewCell.comapnyDetailsAction(_:)))
        tapGest.numberOfTapsRequired=1
        companyTitleLabel.addGestureRecognizer(tapGest)
        
        self.walkinLabel.backgroundColor = AppTheme.defaltBlueColor
        self.walkinLabel.layer.cornerRadius = 10
        self.walkinLabel.layer.masksToBounds = true
        self.companyIconImageView.applyCircular()
        
        
    }

    func filterSkill(jdSkillName : [String]) {
        
        let parentVC =  self.superview?.parentViewController
        let vc = parentVC?.tabBarController as? MIHomeTabbarViewController
//        let skills = vc?.skillsNewArr ?? [""]
//        let itskills = vc?.itSkillsNewArr ?? [""]
//        let arr = (skills + itskills)
       // let newCombSkill = arr.map({$0.lowercased()}).removeDuplicates()
     
        let arr = vc?.userITPlusNonItSkill.map({ $0.skillName }) ?? []
        let newCombSkill = arr.removeDuplicates()
        
        let jdSkills = jdSkillName//.components(separatedBy: ", ") //.map({$0.lowercased()}) //JD Skills

        //filter skills with JDSkills
        var filter = [String]()
        for jdSkill in jdSkills {
            for newskill in newCombSkill {
                if jdSkill.lowercased() == newskill.lowercased() {
                    filter.append(jdSkill)
                    break
                }
            }
        }
        
        let filterJDSkill = filter //jdSkills.filter({ newCombSkill.contains($0)}) // compair jdskills with skill and itskills
        let filterSkill = filterJDSkill.joined(separator: ", ") //set text convert in string
        
        let remainingJDSkill = jdSkills.filter( { !filter.contains( $0 ) })
             //jdSkills.filter({ !newCombSkill.contains($0) }) // seperate jdskills from skills and itskills
        let remainingSkillJD = remainingJDSkill.joined(separator: ", ") //set text convert in string
        
        
        let match = "You match \(filterJDSkill.count) out of \(jdSkills.count) skills required for this job"
        self.skillMatch.text? = jdSkills.count != 0 ? match : ""
        
       let attributed = NSMutableAttributedString(string: remainingSkillJD, attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: "505050"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 13)])
        
        if !(remainingSkillJD.isEmpty)  && !(filterSkill.isEmpty){
            attributed.append(NSAttributedString(string: ", "))
        }
       
       // let stringBold = filterSkill.count != 0 ? (", " + filterSkill) : ""
        
        attributed.append(NSAttributedString(string:  filterSkill , attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "505050"), NSAttributedString.Key.font: UIFont.customFont(type: .Bold, size: 13)]))
        
        self.skillLabel.attributedText = attributed
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.companyImageWidth.constant = 65
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if CommonClass.isLoggedin() {
           self.filterSkill(jdSkillName: self.jdSkillsName)
        }
        
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        //self.filterSkill(jdSkillName: self.jdSkillsName)
    }
    

    
    @objc func comapnyDetailsAction(_ sender:UITapGestureRecognizer){
        CommonClass.googleEventTrcking("job_detail_screen", action: "company_name", label: "")
        if let action=companyDetailAction,self.companyTitleLabel.text != companyConfidential{
            action()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

