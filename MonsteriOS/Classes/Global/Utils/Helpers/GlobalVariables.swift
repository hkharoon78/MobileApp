//
//  GlobalVariables.swift
//  MonsteriOS
//
//  Created by Piyush on 27/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

class MIMasterDataTypeInfo:NSObject  {
    var key = ""
    var data_count = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIMasterDataTypeInfo]
    {
        var models:[MIMasterDataTypeInfo] = []
        for item in array
        {
            if let info = MIMasterDataTypeInfo(dictionary:item){
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        self.key   = dictionary.stringFor(key: "key")
        self.data_count = dictionary.stringFor(key: "doc_count")
    }
}

class GlobalVariables {
    static var masterDataTypeArray = [MIMasterDataTypeInfo]()
}
