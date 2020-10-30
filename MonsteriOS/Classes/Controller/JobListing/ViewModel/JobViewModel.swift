//
//  JobViewModel.swift
//  MonsteriOS
//
//  Created by ishteyaque on 25/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

class JoblistingCellModel{
    var summary:String?
    var companyTitle:String?
    var locationTitle:String?
    var experienceTitle:String?
    var salaryTitle:String?
    var allSkills:[MIAutoSuggestInfo]
    var isSelected=false
    var postedDate:String?
    var displayKiwiJobID:String?
    var numberOfApplication:String?
    var totalViews:String?
    var isWalkIn=false
    var walkInDate:String?
    var companyIconURL:String?
    var jobId:Int?
    var isSavedJob=false
    var isAppliedJob=false
    var isWalkInPro=false
    var isSJSJob=false
    var isViewed=false
    var kiwiJobId:String?
    var jobDetailsPostedDate:String?
    var compLocation: String?
    var jobFunc: String?
    var jobIndustry: String?
    var jobType: String?
    var resId: String?
    var walkinVenue: String?
    var detailsViewLocation:String?
    var locationMoreString:String?
    
    init(model:JoblistingData,isSaved:Bool = false,isSearchLogo:Int=0) {
        self.compLocation = model.company?.location?.city ?? model.company?.location?.country
        self.jobFunc = model.functions?.joined(separator: ",")
        self.jobIndustry = model.industries?.joined(separator: ",")
        self.jobType = model.jobTypes?.joined(separator: ",")
        self.walkinVenue = model.walkInVenue?.addresses?.joined(separator: ",")
        
        self.isSelected=model.isSelected
        self.kiwiJobId=model.kiwiJobId
        self.summary=model.title
        self.jobId = model.jobId
        self.isSavedJob=model.isSaved ?? false
        self.isAppliedJob=model.isApplied ?? false
        self.isViewed=model.isViewed ?? false
        self.isWalkInPro=model.walkInPro ?? false
        
        self.displayKiwiJobID = "Job Id: " + (model.kiwiJobId ?? "")
        self.numberOfApplication  = "No. of Application: \(model.totalApplicants)"
        
        self.companyTitle=model.company?.name
        if isSearchLogo == 1{
            self.companyIconURL=model.company?.logo
        }
        if model.jobTypes?.filter({$0.lowercased().contains(JobTypes.walkIn.value.lowercased())}).count ?? 0 > 0{
            self.isWalkIn=true
        }
        
        if model.jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0{
            self.isSJSJob=true
        }
        var experienceRange=""
        if let minimum=model.minimumExperience?.years{
            experienceRange=String(minimum)+" - "
        }
        if let maximum=model.maximumExperience?.years{
            experienceRange+=String(maximum)+SRPListingStoryBoardConstant.Years
        }
        self.experienceTitle = experienceRange
        
        var salaryRange=""
        if let minimum=model.minimumSalary?.absoluteValue{
            salaryRange=minimum.formattedWithSeparator+" - "
        }
        if let maximum=model.maximumSalary?.absoluteValue{
            salaryRange+=maximum.formattedWithSeparator
        }
        if salaryRange.count > 0{
            self.salaryTitle=salaryRange
        }else{
            self.salaryTitle=" Not Specified "
        }
        self.experienceTitle = experienceRange
       
        var skill = model.skills?.map({ MIAutoSuggestInfo(id: $0.id ?? "", name: $0.text ?? "", type: .NonITSkill) }) ?? []
        let itskill = model.itSkills?.map({ MIAutoSuggestInfo(id: $0.id ?? "", name: $0.text ?? "", type: .ITSkill) }) ?? []
        skill.append(contentsOf: itskill)
        skill = skill.removeDuplicates()
        self.allSkills = skill.filter({ !$0.name.isEmpty })
        
//        if let skills = model.skills?.map({ $0.text ?? "" }).filter({ !$0.isEmpty }) {
//            skillText.append(contentsOf: skills)
//        }
//        if let itSkills = model.itSkills?.map({ $0.text ?? "" }).filter({ !$0.isEmpty }) {
//            skillText.append(contentsOf: itSkills)
//        }

//        self.skillTitle = skillText
        
//        if let skillData=model.skills{
//            for skill in skillData{
//                if skill.text != nil{
//                    skillText.append(skill.text!)
//                }
//            }
//        }
//        if let itskillData=model.itSkills{
//            for itskill in itskillData{
//                if itskill.text != nil{
//                    skillText.append(itskill.text!)
//                }
//            }
//        }
//        if skillText.count == 0{
//            self.skillTitle = "N/A"
//        }else{
//            self.skillTitle = skillText.joined(separator: ", ")
//        }
        
        
        var skillText = [String]()
        if let location=model.location{
            for item in location{
                if item.city != nil{
                    skillText.append(item.city!)
                }else if item.country != nil{
                    skillText.append(item.country!)
                }
            }
        }
        if skillText.count == 0{
            self.locationTitle=model.walkInVenue?.city
            self.detailsViewLocation = model.walkInVenue?.city
        }else{
            self.detailsViewLocation = skillText.joined(separator: ", ")
            if skillText.count <= 2{
                self.locationTitle=skillText.joined(separator: ", ")
            }else{
                self.locationTitle=skillText[0]
                self.locationMoreString = " +\(skillText.count-1)" + " more"
            }
            
        }
        if self.locationTitle == nil || self.locationTitle?.count==0{
            self.locationTitle="N/A"
            self.detailsViewLocation = "N/A"
        }
        if let intDate=model.freshness{
            self.postedDate=formatPostedDate(dateValue: intDate, titl:SRPListingStoryBoardConstant.Posted )
            self.jobDetailsPostedDate=self.postedDate
            
        }
        if self.isWalkIn{
            self.walkInDate = "From " + self.formatDateWalkingString(str: (model.walkInStartDate ?? "")) + " to " +  self.formatDateWalkingString(str: (model.walkInEndDate ?? ""))
        }
        if self.isSavedJob{
            if model.jobSavedDate != nil{
            }
        }
        if self.isViewed{
            self.postedDate = "Viewed"
        }
        if self.isAppliedJob{
            self.postedDate="Applied"
            if model.jobAppliedDate != nil,model.jobAppliedDate != 0{
                self.postedDate=formatPostedDate(dateValue: model.jobAppliedDate!, titl: SRPListingStoryBoardConstant.applied )
            }
        }
        
    }
    
    func formatDateWalkingString(str:String)->String{
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat = PersonalTitleConstant.dateFormatePattern
        if let newDate=dateFormatter.date(from: str){
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            return dateFormatter.string(from: newDate)
        }
        return str
        
    }
    
    
    
}


extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
