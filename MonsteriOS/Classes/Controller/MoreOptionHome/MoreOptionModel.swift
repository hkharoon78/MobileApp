//
//  MoreOptionModel.swift
//  MonsteriOS
//
//  Created by ishteyaque on 26/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation



protocol MoreOptionViewModelItem {
    var type: MoreOptionViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
    var isCollapsible: Bool { get }
    var isCollapsed: Bool { get set }
}

extension MoreOptionViewModelItem {
    var rowCount: Int {
        return 1
    }
    
    var isCollapsible: Bool {
        return true
    }
}

class RecruiterActions:MoreOptionViewModelItem{
    var type: MoreOptionViewModelItemType{
        return .recruiterActions
    }
    var isCollapsible: Bool {
        return false
    }
    var rowCount: Int{
        return 0
    }
    var sectionTitle: String {
        return MoreOptionViewModelItemType.recruiterActions.value
    }
    var isCollapsed = true
    
}

class CareerServices:MoreOptionViewModelItem{
    var type: MoreOptionViewModelItemType{
        return .careerServices
    }
    var isCollapsible: Bool {
        return true
    }
    
    var sectionTitle: String {
        return MoreOptionViewModelItemType.careerServices.value
    }
    var rowCount: Int{
        return 4
    }
    var isCollapsed = true
    
    let subtitle=CarrierServices.allCases
    
}

class MonsterEducation:MoreOptionViewModelItem{
    var type: MoreOptionViewModelItemType{
        return .monsterEducation
    }
    var isCollapsible: Bool {
        return false
    }
    var rowCount: Int{
        return 0
    }
    var sectionTitle: String {
        return MoreOptionViewModelItemType.monsterEducation.value
    }
    var isCollapsed = true
    
}

class Articles:MoreOptionViewModelItem{
    var type: MoreOptionViewModelItemType{
        return .articles
    }
    var isCollapsible: Bool {
        return false
    }
    
    var sectionTitle: String {
        return MoreOptionViewModelItemType.articles.value
    }
    var isCollapsed = true
    var rowCount: Int{
        return 0
    }
    
}

class ShareApp:MoreOptionViewModelItem{
    var type: MoreOptionViewModelItemType{
        return .shareApp
    }
    var isCollapsible: Bool {
        return false
    }
    
    var sectionTitle: String {
        return MoreOptionViewModelItemType.shareApp.value
    }
    var isCollapsed = true
    var rowCount: Int{
        return 0
    }
    
}

class Settings:MoreOptionViewModelItem{
    var type: MoreOptionViewModelItemType{
        return .settings
    }
    var isCollapsible: Bool {
        return true
    }
    
    var sectionTitle: String {
        return MoreOptionViewModelItemType.settings.value
    }
    var rowCount: Int{
        return 6
    }
    var isCollapsed = true
   
    let subtitle=SettingsMore.allCases

}

class Feedback:MoreOptionViewModelItem{
    var type: MoreOptionViewModelItemType{
        return .feedback
    }
    var isCollapsible: Bool {
        return false
    }
    
    var sectionTitle: String {
        return MoreOptionViewModelItemType.feedback.value
    }
    var isCollapsed = true
    var rowCount: Int{
        return 0
    }
    
}

class ContactUs:MoreOptionViewModelItem{
    var type: MoreOptionViewModelItemType{
        return .contactUs
    }
    var isCollapsible: Bool {
        return false
    }
    
    var sectionTitle: String {
        return MoreOptionViewModelItemType.contactUs.value
    }
    var isCollapsed = true
    var rowCount: Int{
        return 0
    }
    
}

//class PrivacyPolicy:MoreOptionViewModelItem{
//    var type: MoreOptionViewModelItemType{
//        return .privacyPolicy
//    }
//    var isCollapsible: Bool {
//        return false
//    }
//
//    var sectionTitle: String {
//        return MoreOptionViewModelItemType.privacyPolicy.value
//    }
//    var isCollapsed = true
//    var rowCount: Int{
//        return 0
//    }
//
//}

//class TermsCondition:MoreOptionViewModelItem{
//    var type: MoreOptionViewModelItemType{
//        return .termsCondition
//    }
//    var isCollapsible: Bool {
//        return false
//    }
//    
//    var sectionTitle: String {
//        return MoreOptionViewModelItemType.termsCondition.value
//    }
//    var isCollapsed = true
//    var rowCount: Int{
//        return 0
//    }
//    
//}
