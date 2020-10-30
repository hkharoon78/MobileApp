
//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//
import Foundation
 

public class JoblistingBaseModel {
	public var data : Array<JoblistingData>?
    public var sponsoredJobs:Array<JoblistingData>?
	public var meta : Meta?
	public var filters : Filters?
	public var selectedFilters : Filters?
    public var filterLabels=[String:String]()
    public class func modelsFromDictionaryArray(array:NSArray) -> [JoblistingBaseModel]
    {
        var models:[JoblistingBaseModel] = []
        for item in array
        {
            models.append(JoblistingBaseModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

        if let metaDict=dictionary["meta"] as? NSDictionary { meta = Meta(dictionary:metaDict) }
        if let dataArray = dictionary["data"] as? NSArray { data = JoblistingData.modelsFromDictionaryArray(array: dataArray,resultId: self.meta?.resultId ?? "")}
         if let dataArray = dictionary["sponsoredJobs"] as? NSArray { sponsoredJobs = JoblistingData.modelsFromDictionaryArray(array: dataArray,resultId: self.meta?.resultId ?? "")}
		if let filterDict=dictionary["filters"] as? NSDictionary { filters = Filters(dictionary: filterDict) }
		if let seltDict=dictionary["selectedFilters"] as? NSDictionary { selectedFilters = Filters(dictionary: seltDict)}
        if let labels=dictionary["filterLabels"]as?[String:String]{
            
            self.filterLabels=labels
            
        }
	}

}



public class Filters{
    var filters:Any?
    var filterValue=[String:[FilterModel]]()
    required public init?(dictionary: NSDictionary){
      
        if let filterMap=dictionary["filterMap"]as?[String:Any]{
            for (key,item) in filterMap{
                var filterModel=[FilterModel]()
                if let modelitemArray=item as? [[String:Any]]{
                    for newItemDict in modelitemArray{
                        if let title=newItemDict["name"]as?String{
                            if let selected=newItemDict["selected"]as?Bool{
                               // let count=String(newItemDict["count"]as?Int ?? 0)
                                filterModel.append(FilterModel(title: title + " (" + String(newItemDict["count"]as?Int ?? 0) + ")", isSelected: selected, isUserSelectEnable:true))
                            }else{
                                filterModel.append(FilterModel(title: title+" ("+String(newItemDict["count"]as?Int ?? 0) + ")", rawTitle: title))
                            }
                            
                        }
                    }
                }
                let splitted = key.splitBefore(separator: { $0.isUppercase }).map{String($0)}
                if splitted.count > 1{
                    filterValue[splitted[0].capitalizedFirstLetter()+" "+splitted[1].capitalizedFirstLetter()]=filterModel
                }else{
                    filterValue[key.capitalizedFirstLetter()]=filterModel
                }
                
            }
        }
    }
}

extension Sequence {
    func splitBefore(
        separator isSeparator: (Iterator.Element) throws -> Bool
        ) rethrows -> [AnySequence<Iterator.Element>] {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []
        
        var iterator = self.makeIterator()
        while let element = iterator.next() {
            if try isSeparator(element) {
                if !subSequence.isEmpty {
                    result.append(AnySequence(subSequence))
                }
                subSequence = [element]
            }
            else {
                subSequence.append(element)
            }
        }
        result.append(AnySequence(subSequence))
        return result
    }
}

extension Character {
    var isUppercase: Bool { return String(self).uppercased() == String(self) }
}

//extension String {
//    var capitalizedFirstLetter:String {
//        let string = self
//        return string.replacingCharacters(in: startIndex...startIndex, with: String(self[startIndex]).capitalized)
//}
//}

extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizedFirstLetter()
    }
    func smallFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    mutating func smallFirstLetter() {
        self = self.smallFirstLetter()
    }
}
