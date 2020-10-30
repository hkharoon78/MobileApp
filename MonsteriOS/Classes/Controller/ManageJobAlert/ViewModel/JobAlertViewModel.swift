//
//  JobAlertViewModel.swift
//  MonsteriOS
//
//  Created by ishteyaque on 25/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

class JobAlertModel {
    var alertName : String?
    var keywords : String?
    var desiredLocation : String?
    var experience : String?
    var salary : String?
    var functionalArea : String?
    var role : String?
    var industry : String?
    var id:String?
    var email:String?
    var frequency:String?
    var frequencyId:String?
    var salaryTitle:String?
    var experienceTitle:String?
    var masterData=[String:[MICategorySelectionInfo]]()
    init() {
        
    }
    func getDictionary()->[String:Any]{
        var param=[String:Any]()
        param["id"]=self.id
        param["email"]=AppDelegate.instance.userInfo.primaryEmail
        param["name"]=self.alertName
        param["keywords"] = (self.keywords?.count ?? 0 > 0 ) ? self.masterData[MasterDataTitle.keywords.rawValue]?.map({$0.name}) : []
        param["industries"] = (self.industry?.count ?? 0 > 0 ) ? self.masterData[MasterDataTitle.industry.rawValue]?.map({$0.name}) : []
        param["roles"] = (self.role?.count ?? 0 > 0 ) ? self.masterData[MasterDataTitle.role.rawValue]?.map({$0.name}) : []
        param["functions"] = (self.functionalArea?.count ?? 0 > 0 ) ? self.masterData[MasterDataTitle.funcionalArea.rawValue]?.map({$0.name}) : []
        param["locations"] = (self.desiredLocation?.count ?? 0 > 0 ) ? self.masterData[MasterDataTitle.desiredLocation.rawValue]?.map({$0.name}) : []
        param["experience"]=["years":experience ?? "","months":0]
        //param["maximumSalary"]=self.maximumSalary
        if AppDelegate.instance.site?.defaultCountryDetails.isoCode.lowercased() == "in" {
            if self.salary != nil && self.salary?.count ?? 0 > 0 {
                param["salary"]=["currency": "INR","absoluteValue": Int(self.salary!)!*100000]
            }else{
                param["salary"]=["currency": "INR","absoluteValue":0 ]
            }
        }
        
        
        param["frequency"]=["text":self.frequency ?? "","id":self.frequencyId ?? ""]
        return param
    }
    
    func getDictionaryJson()->[String:Any]{
        var param=[String:Any]()
        param["id"]=self.id
        param["email"]=AppDelegate.instance.userInfo.primaryEmail
        param["name"]=self.alertName
  
        param["keywords"] = (self.keywords?.count ?? 0 > 0 ) ? self.masterData[MasterDataTitle.keywords.rawValue]?.map({$0.name}) : []
        param["industries"] = (self.industry?.count ?? 0 > 0 ) ? self.createJsonModel(key: MasterDataTitle.industry.rawValue) : []
        param["roles"] = (self.role?.count ?? 0 > 0 ) ? self.createJsonModel(key: MasterDataTitle.role.rawValue) : []
        param["functions"] = (self.functionalArea?.count ?? 0 > 0 ) ? self.createJsonModel(key: MasterDataTitle.funcionalArea.rawValue) : []
        param["locations"] = (self.desiredLocation?.count ?? 0 > 0 ) ? self.createJsonModel(key: MasterDataTitle.desiredLocation.rawValue) : []
        param["experience"]=["years":experience ?? "","months":0]
        //param["maximumSalary"]=self.maximumSalary
        if AppDelegate.instance.site?.defaultCountryDetails.isoCode.lowercased() == "in" {
            if self.salary != nil && self.salary?.count ?? 0 > 0 {
                param["salary"]=["currency": "INR","absoluteValue": Int(self.salary!)!*100000]
            }else{
                param["salary"]=["currency": "INR","absoluteValue":0 ]
            }
        }
        
        
        param["frequency"]=["text":self.frequency ?? "","id":self.frequencyId ?? ""]
        return param
    }
    
    func createJsonModel(key:String)->[[String:Any]]{
        var keyObject=[[String:Any]]()
        for item in self.masterData[key] ?? []{
            keyObject.append(MIUserModel.getParamForIdTextForUUIDNil(id: item.id, value: item.name))
        }
        return keyObject
    }
    
    func getDictionaryClever()->[String:Any]{
        var param=[String:Any]()
        param["no_job"]=self.id
        param["email_id"]=AppDelegate.instance.userInfo.primaryEmail
        param["jobalert_name"]=self.alertName
        param["jobalert_keyword"]=self.keywords?.components(separatedBy: ",")
        param["jobalert_industry"]=self.industry?.components(separatedBy: ",")
        param["jobalert_role"]=self.role?.components(separatedBy: ",")
        // param["functions"]=self.functionalArea?.components(separatedBy: ",")
        param["jobalert_location"]=self.desiredLocation?.components(separatedBy: ",")
        param["jobalert_experience"]=["years":experience ?? "","months":0]
        //param["maximumSalary"]=self.maximumSalary
        if self.salary != nil{
            if let salry = Int(self.salary ?? "0") {
                param["jobalert_salary"]=["currency": "RUPEE","absoluteValue": salry]
                
            }
        }
        
        // param["frequency"]=["text":self.frequency ?? "","id":self.frequencyId ?? ""]
        return param
    }
    init(model:JobAlertModelDataWithMaster) {
        var catInfo=[MICategorySelectionInfo]()
        self.alertName=model.name
        self.id=model.id
        self.email=model.email
        if let keys=model.keywords{
            self.keywords=keys.joined(separator: ",")
            catInfo.removeAll()
            for item in keys{
                let categ=MICategorySelectionInfo()
                categ.name=item
                catInfo.append(categ)
            }
            self.masterData[MasterDataTitle.keywords.rawValue]=catInfo
        }
        if let expe=model.experience{
            self.experience = expe.years
            var expString=""
            if expe.years != nil,Int(expe.years!)! > 0{
                if Int(expe.years!)! == 1{
                    expString+=expe.years! + " Year "
                }else{
                    expString+=expe.years! + " Years "
                }
            }
            self.experienceTitle=expString
            
        }
        if let salary=model.salary{
            if var abs=salary.absoluteValue , abs > 0{
                abs = abs/100000
                var salaryTttl=""
                self.salary="\(abs)"
                if abs == 1{
                    salaryTttl += "\(abs) Lakh"
                }else{
                    salaryTttl += "\(abs) Lakhs"
                }
                self.salaryTitle = salaryTttl
            }
        }
        if let funct=model.functions{
            self.functionalArea=funct.map({$0.text ?? ""}).joined(separator: ",")
            catInfo.removeAll()
            for item in funct{
                let categ=MICategorySelectionInfo()
                categ.name=item.text ?? ""
                categ.id=item.id ?? ""
                if let id=item.id{
                    categ.uuid=id.replacingOccurrences(of: "en:", with: "")
                }
                catInfo.append(categ)
            }
            self.masterData[MasterDataTitle.funcionalArea.rawValue]=catInfo
        }
        if let role=model.roles{
            self.role=role.map({$0.text ?? ""}).joined(separator: ",")
            catInfo.removeAll()
            for item in role{
                let categ=MICategorySelectionInfo()
                categ.name=item.text ?? ""
                categ.id=item.id ?? ""
                catInfo.append(categ)
            }
            self.masterData[MasterDataTitle.role.rawValue]=catInfo
        }
        if let industr=model.industries{
            self.industry=industr.map({$0.text ?? ""}).joined(separator: ",")
            catInfo.removeAll()
            for item in industr{
                let categ=MICategorySelectionInfo()
                categ.name=item.text ?? ""
                categ.id=item.id ?? ""
                catInfo.append(categ)
            }
            self.masterData[MasterDataTitle.industry.rawValue]=catInfo
        }
        self.desiredLocation=model.locations?.map({$0.text ?? ""}).joined(separator: ",")
        catInfo.removeAll()
        for item in model.locations ?? []{
            let categ=MICategorySelectionInfo()
            categ.name=item.text ?? ""
            categ.id=item.id ?? ""
            catInfo.append(categ)
        }
        self.masterData[MasterDataTitle.desiredLocation.rawValue]=catInfo
        if let frequency=model.frequency{
            self.frequency=frequency.text
            self.frequencyId=frequency.id
        }
    
    }
    
    init(model:JobAlertModelData) {
        var catInfo=[MICategorySelectionInfo]()
        self.alertName=model.name
        self.id=model.id
        self.email=model.email
        if let keys=model.keywords{
            self.keywords=keys.joined(separator: ",")
            catInfo.removeAll()
            for item in keys{
                let categ=MICategorySelectionInfo()
                categ.name=item
                catInfo.append(categ)
            }
            self.masterData[MasterDataTitle.keywords.rawValue]=catInfo
        }
        if let expe=model.experience{
            self.experience = expe.years
            var expString=""
            if expe.years != nil,Int(expe.years!)! > 0{
                if Int(expe.years!)! == 1{
                    expString+=expe.years! + " Year "
                }else{
                    expString+=expe.years! + " Years "
                }
            }
            self.experienceTitle=expString
            
        }
        if let salary=model.salary{
            if var abs=salary.absoluteValue , abs > 0{
                abs = abs/100000
                var salaryTttl=""
                self.salary="\(abs)"
                if abs == 1{
                    salaryTttl += "\(abs) Lakh"
                }else{
                    salaryTttl += "\(abs) Lakhs"
                }
                self.salaryTitle = salaryTttl
            }
        }
        if let funct=model.functions{
            self.functionalArea=funct.joined(separator: ",")
            catInfo.removeAll()
            for item in funct{
                let categ=MICategorySelectionInfo()
                categ.name=item
                catInfo.append(categ)
            }
            self.masterData[MasterDataTitle.funcionalArea.rawValue]=catInfo
        }
        if let role=model.roles{
            self.role=role.joined(separator: ",")
            catInfo.removeAll()
            for item in role{
                let categ=MICategorySelectionInfo()
                categ.name=item
                catInfo.append(categ)
            }
            self.masterData[MasterDataTitle.role.rawValue]=catInfo
        }
        if let industr=model.industries{
            self.industry=industr.joined(separator: ",")
            catInfo.removeAll()
            for item in industr{
                let categ=MICategorySelectionInfo()
                categ.name=item
                catInfo.append(categ)
            }
            self.masterData[MasterDataTitle.industry.rawValue]=catInfo
        }
        self.desiredLocation=model.locations?.joined(separator: ",")
        catInfo.removeAll()
        for item in model.locations ?? []{
            let categ=MICategorySelectionInfo()
            categ.name=item
            catInfo.append(categ)
        }
        self.masterData[MasterDataTitle.desiredLocation.rawValue]=catInfo
        if let frequency=model.frequency{
            self.frequency=frequency.text
            self.frequencyId=frequency.id
        }
    }
    
}
