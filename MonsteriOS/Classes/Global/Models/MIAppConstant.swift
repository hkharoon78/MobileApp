//
//  MIAppConstant.swift
//  MonsteriOS
//
//  Created by Rakesh on 29/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class JobSeekerSingleton {
    
    static let sharedInstance = JobSeekerSingleton()
    var dataArray : [String]?
    var fieldLevelDataArray : [String]? {
        didSet {
            if fieldLevelDataArray?.count ?? 0 > 0 {
                self.callAPIForFieldLevelTracking()
            }
        }
    }
    private init(){
        dataArray = [String]()
        fieldLevelDataArray = [String]()
    }
    
    func getLastScreenName()->String{
        return dataArray?.first ?? ""
    }
    func addScreenNameBasedOnController(vc:UIViewController) {
        
        if dataArray?.count ?? 0 >= 2 {
            dataArray?.removeFirst()
        }
        if dataArray?.contains(vc.screenName) ?? false {
            return
        }
        dataArray?.append(vc.screenName)
    }
    func addScreenName(screenName:String) {
        
        if dataArray?.count ?? 0 >= 2 {
            dataArray?.removeFirst()
        }
        if dataArray?.contains(screenName) ?? false {
            return
        }
        dataArray?.append(screenName)

    }
    func callAPIForFieldLevelTracking() {
        
        DispatchQueue.main.async {
            if let data = JobSeekerSingleton.sharedInstance.fieldLevelDataArray , data.count > 0 {
                MIApiManager.callAPIForFieldLevelUpdateTracking(fields: data) { (success, response, error, code) in
                    
                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray?.removeAll()
                }
            }

        }
        
    }
}

class CountryData {
    
    var code = ""
    var uniCode = ""
    var name = ""
    var flagEmoj = ""

    init(data:[String:Any]) {
        
        code = data.stringFor(key: "code")
        uniCode = data.stringFor(key: "unicode")
        name = data.stringFor(key: "name")
        flagEmoj = data.stringFor(key: "emoji")
    }
    
    class func getCountryDataFroISOCode(code:String,countryData:[String:Any]) -> CountryData {

        guard let country = countryData.filter({$0.key == code}) as? [String:Any] , let data = country[code] as? [String:Any]  else {
            return CountryData(data: [:])

        }
        return CountryData(data: data)

    }
    
}
