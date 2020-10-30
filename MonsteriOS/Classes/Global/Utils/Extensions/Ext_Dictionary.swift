//
//  Ext_NSDictionary.swift
//  EExpress
//
//  Created by TTLAPTOP0437 on 2/24/17.
//  Copyright © 2017 Paytm. All rights reserved.
//

import UIKit


extension Dictionary where Key == String  { // where Key: String, Value: Any

    func stringFor(key: String) -> String {
        return self.actualValueFor(key: key, inInt: true)
    }

    func intFor(key: String) -> Int {
        if let mInt = self[key] as? Int { return mInt }
        let value = Int(self.actualValueFor(key: key, inInt: true))
        return value != nil ? value! : 0
    }

    func doubleFor(key: String) -> Double {
        let value = Double(self.actualValueFor(key: key, inInt: false))
        return value != nil ? value! : 0.0
    }

    func booleanFor(key: String) -> Bool {
        return self.stringFor(key: key).lowercased() == "true" || self.intFor(key: key) >= 1
    }

    func dictionaryFor(key: String) -> [String: Any] {
        return self[key] as? [String: Any] ?? [:]
    }
    
    private func actualValueFor(key: String, inInt: Bool) -> String {
        let str1 = self[key]
        if str1 == nil { return "" }

        
        if let str = str1 as? String {
            return (str.lowercased() == "nil" || str.lowercased() == "null") ? "" : str
        }

        if let num = str1 as? NSNumber {
            return inInt ? String(format:"%i", num.int32Value) : String(format:"%f", num.doubleValue)
        }
        return ""
    }
    
    @discardableResult
    func dictionaryToJSONString(printData:Bool = false) -> String{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            let jsonStrig = String(data: jsonData, encoding: .utf8)
            if printData {
                if let json = jsonStrig{
                    printDebug(json)
                    return json
                }else{
                    print("Format incorrect")
                    return ""

                }
            }
        }catch {
            printDebug(error.localizedDescription)
            return ""

        }
        return ""

    }
//    func merge(pair: [String: Any]) {
//        for ky in pair.keys { self[ky] = pair[ky] }
//    }
    
    
//    func handleNullValues() -> Dictionary {
//      
//        func filterNull(from dict: JSONDICT) -> JSONDICT {
//            return
//        }
//        func filterNull(from arr: [Any]) -> [Any] {
//            var dataAr = [Any]
//        }
//       
//        let data = self.filter { (key, value) -> Bool in
//            var d = [String: Any]()
//            switch value {
//            case is Dictionary:
//                d.merge(filterNull(from: value as! JSONDICT) { (current, _) in current }
//                
//            case is Array:
//                d.merge(filterNull(from: value as! JSONDICT) { (current, _) in current }
//                
//            default: break
//            }
//        }
//        
//        return self.filter { $0.value != nil }.mapValues { $0 }
//    }

}



