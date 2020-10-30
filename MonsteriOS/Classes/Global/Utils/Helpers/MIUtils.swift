//
//  MIUtils.swift
//  MonsteriOS
//
//  Created by Piyush on 15/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import NetworkExtension
import AdSupport
class MIUtils: NSObject {
    static let shared = MIUtils()
    class var appVersion : String {
        get {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        }
    }
    class var appBuild : String {
        get {
            return Bundle.main.infoDictionary?["CFBundleVersion"] as? String  ?? ""
        }
    }
    func removeStringElementFromArray(ttl:String,list:[String]) -> [String]  {
        var arr = list
        arr = list.filter({ ($0 != ttl)})
        return arr
    }
    
    class var mandateHeader:[String:Any]? {
        get {
            let site = AppDelegate.instance.site
            return [
                "x-source-site-context"   : site?.context ?? "",
                "x-source-country"    : site?.defaultCountryDetails.isoCode ?? "",
                "x-device"      : "iOS",
                "x-Language-Code"       : "en",
                "x-device-id"   : UIDevice.current.identifierForVendor?.uuidString,
                "x-session-id"  : sessionId,
                "x-product"     :"seeker",
                "sessionId"     : sessionId,
                "x-source-platform"        : "iOS",
                "x-source-platform-version"     : "\(MIUtils.appBuild) \(MIUtils.appVersion)",
                "x-real-ip"     : MIUtils.getIPAddress() ?? "" ,
                "x-forwarded-for"     : ""
            ]
        }
    }

   
    func apiHeaderWith(isToken:Bool,isContentType:Bool,isDeviceToken:Bool,extraDic:[String:String]?) -> [String:String]? {
        guard let _ = AppDelegate.instance.authInfo else { return nil }
    
        let token = [AppDelegate.instance.authInfo.tokenType.capitalized, AppDelegate.instance.authInfo.accessToken].joined(separator: " ")
        
        
        var mandateDic = MIUtils.mandateHeader
        
        if isToken {
            mandateDic?["Authorization"] = token
        }
        if isContentType {
            mandateDic?["Content-Type"] = "application/json"
        }
        //if isDeviceToken {
            mandateDic?["x-device-token"] = AppDelegate.instance.deviceToken
      //  }
        if let dic = extraDic {
            mandateDic = mandateDic?.merge(dict: dic)
        }
        
        return mandateDic as? [String : String]
    }
    class func getIPAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address ?? ""
    }
    
}

extension Dictionary {
    func merge(dict: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var mutableCopy = self
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}
