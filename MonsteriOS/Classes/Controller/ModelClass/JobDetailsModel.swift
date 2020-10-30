//
//  JobDetailsModel.swift
//  MonsteriOS
//
//  Created by ishteyaque on 20/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
class JobDetailsTitle{
    var jobTitle:String!
    var companyTitle:String!
    var locationTitle:String!
    var experience:String!
    var appliedApp:String!
    var skill:String!
    
init(jobTitle:String,companyTitle:String,locationTitle:String,appliedApp:String,skill:String,experience:String) {
        self.jobTitle=jobTitle
        self.companyTitle=companyTitle
        self.locationTitle=locationTitle
        self.appliedApp=appliedApp
        self.skill=skill
        self.experience=experience
    }
}

class JobDetailsModel{
    var industryTitle:String!
    var roleTitle:String!
    var functionalTitle:String!
    var expLevel:String? = ""
    init(industryTitle:String,roleTitle:String,functionalTitle:String,expLevel:String = "") {
        self.industryTitle=industryTitle
        self.roleTitle=roleTitle
        self.functionalTitle=functionalTitle
        self.expLevel=expLevel
    }
}
