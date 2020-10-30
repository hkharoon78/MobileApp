//
//  AppliedJobModel.swift
//  MonsteriOS
//
//  Created by ishteyaque on 20/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
class AppliedJobModel{
    var jobTitle:String!
    var companyTitle:String!
    var locationTitle:String!
    var appliedSuccesTitle:String!
    init(jobTitle:String,companyTitle:String,locationTitle:String,appliedSuccesTitle:String) {
        self.jobTitle=jobTitle
        self.companyTitle=companyTitle
        self.locationTitle=locationTitle
        self.appliedSuccesTitle=appliedSuccesTitle
    }
}
