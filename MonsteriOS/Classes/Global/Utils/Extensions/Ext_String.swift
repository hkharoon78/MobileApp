//
//  Ext_String.swift
//  MonsteriOS
//
//  Created by Monster on 29/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit.UIFont

extension String {
    
    func validiateMobile(for countryCode: String) -> (isValidate:Bool,erroMessage:String,thresholdValue:Int) {
        var code = countryCode
        if code.hasPrefix("+") { code.removeFirst() }

        switch code {
        case "971", "973", "965", "968", "974", "962", "966", "90", "852",
             "62", "60", "63", "65", "66", "84":
            return (self.count >= 6 && self.count <= 10,"Mobile Number should be of 6 to 10 digits.",10)
            
        case "91":
            return (self.count == 10,"Mobile Number should be of 10 digits.",10)
            
        default:
            return (self.count >= 6 && self.count <= 13,"Mobile Number should be of 6 to 13 digits.",13)
        }
    }
    
    
    var bool: Bool {
        return (self == "1") || (self == "true")
    }
    
    var isBlank: Bool { get { return self.withoutWhiteSpace().count <= 0 } }
   
    var withoutSpecialCharacters: String {
        return self.components(separatedBy: CharacterSet.symbols).joined(separator: "")
    }
    
    var isValidEmail: Bool {
        get {
            if !self.isBlank {
                let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with: self)
            }
            return false
        }
    }
    var isValidVersion: Bool {
        get {
            if !self.isBlank {
                let regex = "[0-9]+"
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with: self)
            }
            return false
        }
    }
    var isValidPassword : Bool {
        get {
            if !self.isBlank {
//                There’s at least one uppercase letter
//                There’s at least one lowercase letter
//                There’s at least one numeric digit
//                There’s at least one special symbol
//                The text is at least 6 characters long
                
                
                let regex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[$&+,:;=?@#|'<>.^*()%!-]).{6,}"
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with: self)
            }
            return false
        }
    }
    var isValidName: Bool {
        get {
            if !self.isBlank {
                let regex = "[a-zA-Z ]*"
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with: self)
            }
            return false
        }
    }
 
    func withoutWhiteSpace() -> String {
        let sText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return sText
    }
    
    public var isNumeric: Bool {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
    
    public var parseInt: Int? {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
    func addValueOFSpace(ch:String = "%20") -> String {
        let arr = self.components(separatedBy: " ")
        if arr.count > 0 {
            let str = arr.joined(separator: ch)
            return str
        } else {
            return self
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func encodedUrl () -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! //.urlHostAllowed
    }
    
    mutating func removeChars(chars:[String]) {
        for char in chars {
            self = self.replacingOccurrences(of: char, with: "")
        }
    }
    
    func convertStringToJSon() -> Any {
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                return jsonArray
            }
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                return jsonArray
            }
        } catch let error as NSError {
            printDebug(error)
        }
        return [[:]]
    }
    
    func convertStringToJSonArticle() -> Any {
         let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                return jsonArray
            }
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                return jsonArray
            }
        } catch let error as NSError {
            printDebug(error)
        }
        return [:]
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func returnStringArray(separateChar:String) -> [String] {
        let arr = self.components(separatedBy: separateChar)
        var finalArray = [String]()
        for data in arr {
            let trimStr = data.trimmingCharacters(in: .whitespaces)
            finalArray.append(trimStr)
        }
        return finalArray
    }
    func removeSpecialCharsFromString() -> String {
        let okayChars : Set<Character> =
            Set("0123456789 abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890_")
        return String(self.filter {okayChars.contains($0) })
    }
    
    public func displaySortText() -> String {
        let acronyms = self.components(separatedBy:" ").map({ $0.first != nil ?  String($0.first!) : "" }).joined(separator: "")

        if acronyms.count > 2 {
            return acronyms.substring(start: 0, end: 2)
        }
        return acronyms
    }
    
    public func checkIfAtlestOneCharaterFound() {
     
    }
    
    public func substring(start: Int, end: Int) -> String {
        if self.count <= 0 {return ""}
        let maxChar = self.count > 2 ? 3 : self.count
        return "".padding(toLength:maxChar, withPad:self, startingAt:start)
    }
    
    
    func validateUrl() -> Bool {
        
        //let urlRegEx = "(((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$" //"((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        //let urlRegEx =  "((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    func canOpenURL() -> Bool {
        guard let url = NSURL(string: self) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self)
    }
    

    func checkStringContains(subStringValue:String) -> Bool {
        
        return self.contains(subStringValue)
    }
    
    mutating func removedSpaceFromStarting() {
        var count = 0
        for ch in self {
            if ch != " " {
                break
            }
            count = count + 1
        }
        if count > 0 {
            let charIndex = self.index(self.startIndex, offsetBy: count)
            let removedStartSpace = self.suffix(from: charIndex)
            self = String(removedStartSpace)
        }
    }
    
    func getMonthNumberFromName()->Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let aDate = formatter.date(from: self) ?? Date()
        let components = Calendar.current.component(.month, from: aDate)
        return components

    }
    func getMonthNameFromNumber()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let aDate = formatter.date(from: self) ?? Date()
        let name = formatter.string(from: aDate)
        return name
    }
    
    
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}  

extension NSMutableAttributedString {
    
    func getAstrikWithPlaceholder() -> NSMutableAttributedString{
        let astrik = NSAttributedString(string: "*", attributes: [.foregroundColor : UIColor.red])
        self.append(astrik)
        return self
    }
   
}

extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }

}
