//
//  CompanyDetailsModel.swift
//  MonsteriOS
//
//  Created by ishteyaque on 20/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
class CompanyDetailsModel{
    var comapanyTitle:String?
    var comanyFunctional:String?
    var comapanyImageURL:String?
    var isFollow=false
    var compLocation:String?
    var recImageString:String?
    var isFollowShow:Bool=true
    init(comapanyTitle:String,comanyFunctional:String,comapanyImageURL:String?,isFollow:Bool=false,location:String="",recImageString:String? = nil,isFollowShow:Bool=true) {
        self.comapanyTitle=comapanyTitle
        self.comanyFunctional=comanyFunctional
        self.comapanyImageURL=comapanyImageURL
        self.isFollow=isFollow
        self.compLocation=location
        self.recImageString = recImageString
        self.isFollowShow=isFollowShow
    }
}
