//
//  FilterModelData.swift
//  MonsteriOS
//
//  Created by ishteyaque on 22/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
struct FilterModelData{
    static let yearOfExperiences=[FilterModel(title: "0-1 years", isSelected: false, isUserSelectEnable: true),
                                  FilterModel(title: "1-2 years", isSelected: false, isUserSelectEnable: true),
                                  FilterModel(title: "2-3 Years", isSelected: false, isUserSelectEnable: true),FilterModel(title: "3-4 Years", isSelected: false, isUserSelectEnable: true),FilterModel(title: "4-5 Years", isSelected: false, isUserSelectEnable: true),FilterModel(title: "5-6 Years", isSelected: false, isUserSelectEnable: true),FilterModel(title: "6-7 Years", isSelected: false, isUserSelectEnable: true),FilterModel(title: "7-8 Years", isSelected: false, isUserSelectEnable: true),FilterModel(title: "8-9 Years", isSelected: false, isUserSelectEnable: true),FilterModel(title: "9-10 Years", isSelected: false, isUserSelectEnable: true)]
    static let industry=[FilterModel(title: "Automotive/ Ancillaries", isSelected: false, isUserSelectEnable: true),
                                  FilterModel(title: "Bio Technology & Life Sciences", isSelected: false, isUserSelectEnable: true),
                                  FilterModel(title: "Agriculture/ Diary/ Forestry/Farming", isSelected: false, isUserSelectEnable: true),FilterModel(title: "Agriculture/ Diary/ Forestry/Farming", isSelected: false, isUserSelectEnable: true),FilterModel(title: "Defense/Foreign Policy Advocates", isSelected: false, isUserSelectEnable: true),FilterModel(title: "Doctors & Other Health Professionals", isSelected: false, isUserSelectEnable: true),FilterModel(title: "Electronics Manufacturing & Equipment", isSelected: false, isUserSelectEnable: true),FilterModel(title: "IT", isSelected: false, isUserSelectEnable: true),FilterModel(title: "Electronics Manufacturing & Equipment", isSelected: false, isUserSelectEnable: true),FilterModel(title: "Electronics Manufacturing & Equipment", isSelected: false, isUserSelectEnable: true)]
    static let fresness=[FilterModel(title: "7 Days", rawTitle: "7 Days"),FilterModel(title: "15 Days", rawTitle: "15 Days"),FilterModel(title: "30 Days", rawTitle: "30 Days"),FilterModel(title: "2 Months", rawTitle: "2 Months")]

}


class FilterModel: NSObject,Selectable {
    var title: String
    var rawTitle: String = ""

    var isSelected: Bool = false
    var isUserSelectEnable: Bool = true
    var key:String = ""
    init(title:String,isSelected:Bool,isUserSelectEnable:Bool) {
        self.title = title
        self.isSelected = isSelected
        self.isUserSelectEnable = isUserSelectEnable
        self.rawTitle = ""
    }
    init(title:String,rawTitle:String = "") {
        self.title=title
        self.rawTitle = rawTitle 
    }
}

struct FilterStructModel{
    var title:String
    var isSelected:Bool=false
    init(model:FilterModel) {
        self.title=model.title
        self.isSelected=model.isSelected
    }
}
