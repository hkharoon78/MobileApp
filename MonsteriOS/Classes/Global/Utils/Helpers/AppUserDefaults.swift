//
//  AppUserDefaults.swift
//
//  Created by Anupam Katiyar on 11/01/19.
//  Copyright © 2017 Anupam Katiyar. All rights reserved.
//
import Foundation
import SwiftyJSON

enum AppUserDefaults {
    
    enum Key: String, CaseIterable {
        
        //MARK:- Do Not delete these data
        case SelectedSite
        case SplashData
        
        case PreviousCountry
        case APIModeSelection
        //MARK:- ^^^^^^^^^^^
        
        case AuthenticationInfo
        case UserData
        case ProfileProgress

        //Old Rating Popup Keys
        case LaunchCount
        case RatingSubmitted
        
        //New Rating Popup Keys
        case JobApplyCount
        case JobApplyOnDate
        case JobApplyRating
        case JobSharedOnDate
        case JobShareRating
        case AppSharedOnDate
        case AppShareRating

        case JobFeedbackQueries
        case JobFeedbackLastDate

    }
}

extension AppUserDefaults {
    
    static func value(forKey key: Key, file : String = #file, line : Int = #line, function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            fatalError("No Value Found in UserDefaults\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return JSON(value)
    }
    
    static func value<T>(forKey key: Key, fallBackValue : T, file : String = #file, line : Int = #line, function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            print("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
            return JSON(fallBackValue)
        }
        
        return JSON(value)
    }
    
    static func unArchivedValue(forKey key: Key, file : String = #file, line : Int = #line, function : String = #function) -> Any? {
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) as? Data else {
            print("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
            return nil
        }
        
        let decodedValue = NSKeyedUnarchiver.unarchiveObject(with: value)
        return decodedValue
    }
    
    static func save(value : Any, forKey key : Key, archieve: Bool = false) {
        
        if archieve {
            let archivedData = NSKeyedArchiver.archivedData(withRootObject: value)
            UserDefaults.standard.set(archivedData, forKey: key.rawValue)
        } else {
            UserDefaults.standard.set(value, forKey: key.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forKey key : Key) {
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {        
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
    
}
