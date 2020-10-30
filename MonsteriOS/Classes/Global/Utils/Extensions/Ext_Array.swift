//
//  Ext_Array.swift
//  MonsteriOS
//
//  Created by Piyush on 12/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

extension Array where Element:MICategorySelectionInfo {
    func removeMasterDataDuplicates() -> [MICategorySelectionInfo] {
        var result = [MICategorySelectionInfo]()
        var res = [String]()
        for value in self {
            if res.contains(value.name) == false {
                result.append(value)
                res.append(value.name)
            }
        }
        
        return result
    }
}

extension Array where Element:MIAutoSuggestInfo {
    func removeSearchAutoSuggestedDuplicates() -> [MIAutoSuggestInfo] {
        var result = [MIAutoSuggestInfo]()
        var res = [String]()
        for value in self {
            if res.contains(value.name) == false {
                result.append(value)
                res.append(value.name)
            }
        }
        
        return result
    }
}
extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension Equatable {
    func oneOf(_ other: Self...) -> Bool {
        return other.contains(self)
    }
}
