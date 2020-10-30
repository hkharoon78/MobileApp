//
//  MICookieHelper.swift
//  MonsteriOS
//
//  Created by Rakesh on 28/05/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

class MICookieHelper {
   
    static var urlHost:String?
    
    class func setUpCookiePolicyAndRegisterCookies(forurl:String){
        if let url = URL(string: forurl) {
            if let host = url.host {
                self.urlHost = host.replacingOccurrences(of: "www", with: "")
            }
        }
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        self.registerCookies()
    }
    
    class func registerCookies() {
       // self.clearCustomCookies()
        if let siteDomain = self.urlHost {
            if CommonClass.isLoggedin() && CommonClass.allDomains.contains(siteDomain){
                let cookieStorage = HTTPCookieStorage.shared
//               let path = APIPath.rioAutoLoginOldSystemEndpoint + MICookieHelper.getMSSOATCookieValue()

//               guard let url = URL(string: path) else{
//                             return
//                         }
//                   if let cookies =  HTTPCookieStorage.shared.cookies(for: url) {
//                       for ck in cookies  {
//                           print(ck)
//                           cookieStorage.setCookie(ck)
//                       }
//                   }

                           let mssoatCookie: HTTPCookie = HTTPCookie(properties: [.name : "MSSOAT",
                                                                                  .value : self.getMSSOATCookieValue(),
                                                                                  .domain : siteDomain,
                                                                                  .path : "/",
                                                                                  .version : "0",
                                                                                  .secure : true,
                                                                                  .expires : Date().addingTimeInterval(24*60*60)
                                                                                  
                           ]) ?? HTTPCookie()
                          //  mssoatCookie.isHTTPOnly = true
                           cookieStorage.setCookie(mssoatCookie)
                           let mssoclientCookie: HTTPCookie = HTTPCookie(properties: [.name : "MSSOCLIENT",
                                                                                      .value : UUID().uuidString,
                                                                                      .domain : siteDomain,
                                                                                      .path : "/",
                                                                                      .version : "0",
                                                                                      .secure : true,
                                                                                      .expires : Date().addingTimeInterval(24*60*60)
                                                                                      
                           ]) ?? HTTPCookie()
                          //  mssoclientCookie.isHTTPOnly = true

                           cookieStorage.setCookie(mssoclientCookie)
                
                
                
                
            
                
            }
        }
    }
    class func getMSSOATCookieValue() -> String{
     
        let token = AppDelegate.instance.authInfo.accessToken
        let expiredIn = "\(AppDelegate.instance.authInfo.expiresIn ?? 24*60*60):"
        let finalKey =  (token + "::bearer:" + expiredIn)
        let base64String = Data(finalKey.utf8).base64EncodedString()
        return base64String.replacingOccurrences(of: "=", with: "")
   
    }
    
    class func clearCustomCookies(){
        //HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        guard let cookies = HTTPCookieStorage.shared.cookies else {return}
        for cook in  cookies{
            print("==============> name:\(cook.name) domain:\(cook.domain),value:\(cook.value)<================")
            HTTPCookieStorage.shared.deleteCookie(cook)
        }
    }
}
