//
//  MICategorySelectionInfo.swift
//  MonsteriOS
//
//  Created by Piyush on 27/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MICategorySelectionInfo: NSObject, NSCoding, NSCopying {
    
    public var id       = ""
    public var score    = ""
    public var uuid     = ""
    public var language = ""
    public var enabled  = ""
    public var orderBy  = ""
    public var name     = ""
    public var type     = ""
    public var kiwiId   = ""
    public var countryName   = ""
    public var countryISOCode   = ""
    public var parentUuid       = ""
    public var countryUUID       = ""
    public var countryISOCodeListVisa   = [String]()

    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MICategorySelectionInfo] {
        
        var models:[MICategorySelectionInfo] = []
        for item in array
        {
            if let info = MICategorySelectionInfo(dictionary:item){
                models.append(info)
            }
        }
        return models
    }
   
    override init() {
        
    }
    
    class func getDefaultVisaTypeForDontHaveAuthorization() -> MICategorySelectionInfo {
        
        return MICategorySelectionInfo(id: "", score: "", uuid: "", language: "en", enabled: "", orderBy: "", name: kDONT_HAVE_WORK_AUTHORIZATION, type: "VISA_TYPE", kiwiId: "", countryName: "", countryISOCode: "", parentUuid: "", countryUuId: "",countryIsoCodeArray:[String]())
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let obj = MICategorySelectionInfo(id: id, score: score, uuid: uuid, language: language, enabled: enabled, orderBy: orderBy, name: name, type: type, kiwiId: kiwiId, countryName: kiwiId, countryISOCode: countryISOCode, parentUuid: parentUuid,countryUuId:countryUUID, countryIsoCodeArray: countryISOCodeListVisa)
        return obj
    }

    init(id: String, score: String, uuid: String, language: String, enabled: String, orderBy: String, name: String, type: String, kiwiId: String, countryName: String, countryISOCode: String, parentUuid: String,countryUuId:String,countryIsoCodeArray:[String]) {
        
        self.id       = id
        self.score    = score
        self.uuid     = uuid
        self.language = language
        self.enabled  = enabled
        self.orderBy  = orderBy
        self.name     = name
        self.type     = type
        self.kiwiId   = kiwiId
        self.countryName   = countryName
        self.countryISOCode   = countryISOCode
        self.parentUuid       = parentUuid
        self.countryUUID       = countryUuId
        self.countryISOCodeListVisa =  countryIsoCodeArray
    }
    
    required public init?(dictionary: [String:Any]) {
        
        score = dictionary.stringFor(key:"score")
        language = dictionary.stringFor(key:"language")
        enabled  = dictionary.stringFor(key:"enabled")
        orderBy  = dictionary.stringFor(key:"orderBy")
        if !dictionary.stringFor(key:"name").isEmpty {
            name     = dictionary.stringFor(key:"name")
            id    = dictionary.stringFor(key:"id")
            uuid  = dictionary.stringFor(key:"uuid")

        } else {
            name     = dictionary.stringFor(key:"text")
            uuid    = dictionary.stringFor(key:"id")

        }
        
        if let country = dictionary["country"] as? [String:Any] {
            countryName       = country.stringFor(key:"name")
            countryISOCode    = country.stringFor(key:"isoCode")
            countryUUID    = country.stringFor(key:"uuid")

        }
        //For Nationality and Location Master Data
        if let extraInfo = dictionary["extraInfo"] as? [String:Any] {
           
            countryISOCode       = extraInfo.stringFor(key:"countryIsoCode")
            countryName       = extraInfo.stringFor(key:"countryName")
            countryUUID    = extraInfo.stringFor(key:"countryUuId")
        }
        
        if countryISOCode.isEmpty {
            countryISOCode    = dictionary.stringFor(key:"countryIsoCode")
        }
        if let countryIsoCodeArray = dictionary["countryIsoCodeArray"] as? [String] {
            countryISOCodeListVisa = countryIsoCodeArray
        }
        type     = dictionary.stringFor(key:"type")
        kiwiId   = dictionary.stringFor(key:"kiwiId")
        if let dic = dictionary["parentUuid"] as? [String],dic.count > 0 {
            parentUuid = dic.joined(separator: ",")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as! String
        score    = aDecoder.decodeObject(forKey: "score") as! String
        uuid     = aDecoder.decodeObject(forKey: "uuid") as! String
        language = aDecoder.decodeObject(forKey: "language") as! String
        enabled  = aDecoder.decodeObject(forKey: "enabled") as! String
        orderBy  = aDecoder.decodeObject(forKey: "orderBy") as! String
        name     = aDecoder.decodeObject(forKey: "name") as! String
        type     = aDecoder.decodeObject(forKey: "type") as! String
        kiwiId   = aDecoder.decodeObject(forKey: "kiwiId") as! String
        countryName   = aDecoder.decodeObject(forKey: "countryName") as! String
        countryISOCode   = aDecoder.decodeObject(forKey: "countryISOCode") as! String
        countryUUID   = aDecoder.decodeObject(forKey: "countryUUID") as! String
        countryISOCodeListVisa   = aDecoder.decodeObject(forKey: "countryISOCodeListVisa") as! [String]

        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(language, forKey: "language")
        aCoder.encode(enabled, forKey: "enabled")
        aCoder.encode(orderBy, forKey: "orderBy")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(kiwiId, forKey: "kiwiId")
        aCoder.encode(countryName, forKey: "countryName")
        aCoder.encode(countryISOCode, forKey: "countryISOCode")
        aCoder.encode(countryUUID, forKey: "countryUUID")
        aCoder.encode(countryISOCodeListVisa, forKey: "countryISOCodeListVisa")

        
    }
    
    class func getParentUUIDs(modalDataSource:[MICategorySelectionInfo]) -> String {
        var parentUUIDs = ""
        if modalDataSource.count > 0 {
            let UUIDs = modalDataSource.map({$0.uuid}).joined(separator: ",")
            if UUIDs.count > 0{
            parentUUIDs = "&parentUuids=" + UUIDs
            }
        }
        return parentUUIDs
    }
    
    class func getSelectedMasterDataFor(dataSource:[MICategorySelectionInfo]) -> (masterDataNames:[String],masterDataObject:[MICategorySelectionInfo]) {
        var selectedInfoArray = [String]()
        var selectDataArray = [MICategorySelectionInfo]()
        if (dataSource.count) > 0 {
            selectedInfoArray = (dataSource.map({ $0.name}))
            selectDataArray = dataSource
        }
        return (selectedInfoArray,selectDataArray)
        
    }
}
