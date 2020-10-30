//
//  MIProfileViewedContractedConsideredCell.swift
//  MonsteriOS
//
//  Created by Anushka on 24/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProfileViewedContractedConsideredCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblSkillName: UILabel!
    @IBOutlet weak var lblPostedTime: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblJobPosted: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var heightConstraintsViewFollow: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintsViewStatus: NSLayoutConstraint!
    
    
    var controllerType: OpenProfile = .fromProfileViewed {
        
        didSet {
            switch controllerType {
            case .fromProfileViewed:
                self.heightConstraintsViewStatus.constant = 0
                self.lblStatus.isHidden = true
                self.viewStatus.isHidden = true
            case .fromConsidered:
                self.heightConstraintsViewFollow.constant = 80.0
                break
            case .fromContracted:
                self.heightConstraintsViewFollow.constant = 0
                self.btnFollow.isHidden = true
                self.lblJobPosted.isHidden = true
                self.lblStatus.isHidden = true
                self.viewStatus.isHidden = true
            }
        }
        
    }
    
    var modelData : RecuiterActionCellViewModel! {
       
        didSet{
            self.lblName.text = modelData.name
            self.lblCompanyName.text = modelData.companyName
            self.lblSkillName.text = modelData.skillName
            self.lblPostedTime.text = modelData.timeViewed
            self.lblStatus.attributedText = modelData.attributedStatus
            self.lblJobPosted.text = modelData.jobPostedCount
            self.imgProfile.setImage(with: modelData.avatarUrl, placeholder: defaultRecruiterIcon)
            self.lblPostedTime.text = modelData.timeViewed
            
            if modelData.isFollowed {
                self.btnFollow.setTitle("Following", for: .normal)
                self.btnFollow.backgroundColor = AppTheme.defaltBlueColor//UIColor(hexString: "5c4aae")
                self.btnFollow.setTitleColor(UIColor.white, for: .normal)
            } else {
                self.btnFollow.setTitle("Follow", for: .normal)
                self.btnFollow.backgroundColor = UIColor.clear
                self.btnFollow.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
            }
            
            switch controllerType {
            case .fromContracted:
                if modelData.msgViewed {
                    self.viewContainer.backgroundColor = .white
                } else {
                    self.viewContainer.backgroundColor = UIColor(red: 92/255, green: 74/255, blue: 174/255, alpha: 0.1)
                }
            default:
                break
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgProfile.applyCircular()
        
        self.btnFollow.roundCorner(1, borderColor: AppTheme.defaltBlueColor, rad: 5)
       // self.btnFollow.backgroundColor = UIColor.clear
//        self.btnFollow.setTitle("Follow", for: .normal)
//        self.btnFollow.setTitle("Following", for: .selected)
        
        self.btnFollow.tintColor = UIColor.clear

        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
         self.lblStatus.isHidden = false
         self.viewStatus.isHidden = false
         self.heightConstraintsViewStatus.constant = 32
         self.heightConstraintsViewFollow.constant = 80.0
         self.btnFollow.isHidden = false
         self.lblJobPosted.isHidden = false
         self.lblName.text = nil
         self.lblCompanyName.text = nil
         self.lblSkillName.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}


class RecuiterActionCellViewModel {
  
    var name:String?
    var companyName:String?
    var skillName:String?
    var timeViewed:String?
    var status:String?
    var jobPostedCount:String?
    var isFollowed:Bool = false
    var avatarUrl:String?
    var msgId:Int?
    var sentVai:String?
    var attributedStatus:NSAttributedString?
    var recruiterID: String?
    var msgViewed: Bool = false
    
    init(model: RecruiterActionViewed) {
        self.name         = model.name
        self.companyName  = model.companyName
        self.skillName    = ""
        self.avatarUrl    = model.avatarUrl
        self.isFollowed   = model.followed ?? false
        self.jobPostedCount = String(model.jobPostedCount ?? 0) + " Jobs Posted"
        self.recruiterID = "\(model.recruiterId ?? 0)"
        
        if let timeStamp = model.actionTimestamp {
            self.timeViewed = self.timesStampFormat(timeStamp: timeStamp)
        }
        
    }
    
    init(model:RecruiterActionContracted) {
        self.name         = model.name
        self.companyName  = model.companyName
        self.skillName    = ""
        self.avatarUrl    = model.avatarUrl
        self.msgId        = model.messageId
        self.sentVai      = model.contactMedium?.joined(separator: ", ")
        self.recruiterID  = "\(model.recruiterId ?? 0)"
        self.msgViewed    = model.messageViewed ?? false
        
        if let timeStamp = model.actionTimestamp {
            self.timeViewed = self.timesStampFormat(timeStamp: timeStamp)
        }


    }
    
    init(model:RecruiterActionConsidered) {
        self.name         = model.name
        self.companyName  = model.companyName
        self.skillName    = ""
        self.avatarUrl    = model.avatarUrl
        self.isFollowed   = model.followed ?? false
        self.jobPostedCount = String(model.jobPostedCount ?? 0) + " Jobs Posted"
        self.recruiterID = "\(model.recruiterId ?? 0)"
        
        if let timeStamp = model.actionTimestamp {
            self.timeViewed = self.timesStampFormat(timeStamp: timeStamp)
        }
     
        let attributed=NSMutableAttributedString(string: "Status: ", attributes: [NSAttributedString.Key.foregroundColor:AppTheme.grayColor,NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 13)])
        attributed.append(NSAttributedString(string: model.status ?? "", attributes: [NSAttributedString.Key.foregroundColor:AppTheme.grayColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)]))
        
        self.attributedStatus = attributed
        self.status       = model.status
    }
    
    
    func timesStampFormat(timeStamp: Int) -> String {
        var postedDate = ""
        
        let df = DateFormatter()
        df.dateFormat = "MMM d yyyy"
        
        let appliedDate = Date(timeIntervalSince1970: Double(timeStamp/1000))
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: appliedDate, to: Date())
        
        if components.month != nil,components.month! > 0{
            postedDate = df.string(from: appliedDate)
            
        }else if components.day != nil, components.day! > 0 {
            if components.day! > 7 {
                postedDate = df.string(from: appliedDate)
            } else if  components.day! == 1 {
                postedDate = "1 day ago"
            } else {
                postedDate = String(components.day!) + " days ago"
            }
            
        } else if let hours = components.hour , hours > 0{
            if hours == 1 {
                postedDate = String(hours) + " hour ago"
            } else {
                postedDate = String(hours) + " hours ago"
            }
        } else if let min = components.minute, min > 0 {
            if min == 1 {
                postedDate = String(min) + " min ago"
            } else {
                postedDate = String(min) + " mins ago"
            }
        } else {
            postedDate = "now"
        }
        
        return postedDate
    }
    
}


public class RecruiterActionViewed {
    public var recruiterId : Int?
    public var name : String?
    public var companyId : Int?
    public var kiwiRecruiterId : Int?
    public var actionTimestamp : Int?
    public var followed : Bool?
    public var jobPostedCount : Int?
    public var status : String?
    public var avatarUrl : String?
    public var companyName : String?
    public var id : String?

  
    public class func modelsFromDictionaryArray(array:NSArray) -> [RecruiterActionViewed]
    {
        var models:[RecruiterActionViewed] = []
        for item in array
        {
            models.append(RecruiterActionViewed(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    

    required public init?(dictionary: NSDictionary) {
        
        recruiterId = dictionary["recruiterId"] as? Int
        name = dictionary["name"] as? String
        companyId = dictionary["companyId"] as? Int
        kiwiRecruiterId = dictionary["kiwiRecruiterId"] as? Int
        actionTimestamp = dictionary["actionTimestamp"] as? Int
        followed = dictionary["followed"] as? Bool
        jobPostedCount = dictionary["jobPostedCount"] as? Int
        status = dictionary["status"] as? String
        avatarUrl = dictionary["avatarUrl"] as? String
        companyName = dictionary["companyName"] as? String
        id = dictionary["id"] as? String //check id key name

    }
    
   
    
}
public class RecruiterActionViewedBase {
    public var data : Array<RecruiterActionViewed>?
    public var meta : Meta?

    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["data"] != nil) { data = RecruiterActionViewed.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray) }
        if (dictionary["meta"] != nil) { meta = Meta(dictionary: dictionary["meta"] as! NSDictionary) }
    }
    
}


public class RecruiterActionContracted {
    public var recruiterId : Int?
    public var name : String?
    public var companyId : Int?
    public var kiwiRecruiterId : Int?
    public var actionTimestamp : Int?
    public var avatarUrl : String?
    public var companyName : String?
    public var contactMedium : Array<String>?
    public var messageId : Int?
    public var messageViewed : Bool?
    public var id : String?
    
  
    public class func modelsFromDictionaryArray(array:NSArray) -> [RecruiterActionContracted]
    {
        var models:[RecruiterActionContracted] = []
        for item in array
        {
            models.append(RecruiterActionContracted(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    

    required public init?(dictionary: NSDictionary) {
        
        recruiterId = dictionary["recruiterId"] as? Int
        name = dictionary["name"] as? String
        companyId = dictionary["companyId"] as? Int
        kiwiRecruiterId = dictionary["kiwiRecruiterId"] as? Int
        actionTimestamp = dictionary["actionTimestamp"] as? Int
        avatarUrl = dictionary["avatarUrl"] as? String
        companyName = dictionary["companyName"] as? String
        if let contactMed = dictionary["contactMedium"] as? [String] { contactMedium = contactMed }
        messageId = dictionary["messageId"] as? Int
        messageViewed = dictionary["messageViewed"] as? Bool
        id = dictionary["id"] as? String //check id key name

    }
    
}


public class RecruiterActionContractedBase {
    public var data : Array<RecruiterActionContracted>?
    public var meta : Meta?
    

    public class func modelsFromDictionaryArray(array:NSArray) -> [RecruiterActionContractedBase]
    {
        var models:[RecruiterActionContractedBase] = []
        for item in array
        {
            models.append(RecruiterActionContractedBase(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["data"] != nil) { data = RecruiterActionContracted.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray) }
        if (dictionary["meta"] != nil) { meta = Meta(dictionary: dictionary["meta"] as! NSDictionary) }
    }
    
}


public class RecruiterActionConsidered {
    public var recruiterId : Int?
    public var name : String?
    public var companyId : Int?
    public var kiwiRecruiterId : Int?
    public var actionTimestamp : Int?
    public var followed : Bool?
    public var jobPostedCount : Int?
    public var status : String?
    public var avatarUrl : String?
    public var companyName : String?
    public var id : String?

    

    public class func modelsFromDictionaryArray(array:NSArray) -> [RecruiterActionConsidered]
    {
        var models:[RecruiterActionConsidered] = []
        for item in array
        {
            models.append(RecruiterActionConsidered(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
   
    required public init?(dictionary: NSDictionary) {
        
        recruiterId = dictionary["recruiterId"] as? Int
        name = dictionary["name"] as? String
        companyId = dictionary["companyId"] as? Int
        kiwiRecruiterId = dictionary["kiwiRecruiterId"] as? Int
        actionTimestamp = dictionary["actionTimestamp"] as? Int
        followed = dictionary["followed"] as? Bool
        jobPostedCount = dictionary["jobPostedCount"] as? Int
        status = dictionary["status"] as? String
        avatarUrl = dictionary["avatarUrl"] as? String
        companyName = dictionary["companyName"] as? String
        id = dictionary["id"] as? String //check id key name

    }
    
}

public class RecruiterActionConsideredBase {
    public var data : Array<RecruiterActionConsidered>?
    public var meta : Meta?
    
  
    public class func modelsFromDictionaryArray(array:NSArray) -> [RecruiterActionConsideredBase]
    {
        var models:[RecruiterActionConsideredBase] = []
        for item in array
        {
            models.append(RecruiterActionConsideredBase(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["data"] != nil) { data = RecruiterActionConsidered.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray) }
        if (dictionary["meta"] != nil) { meta = Meta(dictionary: dictionary["meta"] as! NSDictionary) }
    }
    
    
}


