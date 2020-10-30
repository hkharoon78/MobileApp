//
//  MIAPIClient.swift
//  MonsteriOS
//
//  Created by ishteyaque on 21/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit
typealias JSONDICT = [String: Any]
typealias JSONSARR = [String]
typealias JSONARR = [Any]
typealias jsonArr = [[String: Any]]
let BASE_IP_ADDRESS_API = "\(kBaseUrl)"
//
//enum MIAPIPath:String{
//    case searchJob="macaw/api/public/search/v3/jobs"
//    case getJobAlert="falcon/api/users/v3/jobs/alerts"
//    case deleteJobAlert="falcon/api/users/v3/jobs/alerts/"
//    case getJobDetails="macaw/api/public/search/v1/job-detail"
//    case saveJob="macaw/api/users/v1/jobs/save"
//    case unsaveJob="macaw/api/users/v1/jobs/unsave"
//    case savedJob="macaw/api/users/v1/jobs/saved"
//    case netwrokJob="macaw/api/users/v1/ml/jobs/network"
//    case followCompany="swarm/api/v1/seeker/follow/company/"
//    case unfollowCompany="swarm/api/v1/seeker/unfollow/company/"
//    case followRecruiter="swarm/api/v1/seeker/follow/recruiter/"
//    case unfollowRecruiter="swarm/api/v1/seeker/unfollow/recruiter/"
//    case getFollowedCompany="swarm/api/v1/seeker/following/companies"
//    case getFollowedRecruiter="swarm/api/v1/seeker/following/recruiters"
//    case canApply="falcon/api/users/v3/jobs/can/apply"
//    case forceApply="falcon/api/users/v3/jobs/apply"
//    case appliedJob="macaw/api/users/v1/jobs/applied"
//    case companyDetails="raven/api/public/search/v1/company-detail"
//    case similarJobs="macaw/api/search/v1/ml/similar-jobs"
//    case appliedalsoapplied="macaw/api/public/users/v1/ml/jobs/applied-also-applied"
//    case suggestedJobs="macaw/api/users/v1/ml/jobs/suggested"
//    case applyTrackEvent="penguin/api/public/events/new/v2/publish"
//    case skippedJob="falcon/api/users/v1/jobs/save/skipped"
//    case viewedJobs="falcon/api/track/v1/jobs/viewed"
//}
//@@*** Catch Service errors
enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .other:
            return "Something went wrong"
        case .custom(let message):
            return message
        }
    }
}

extension ServiceError {
    // TODO: add a provision for request time out.
    init(json: JSONDICT) {
        if let message =  json["errorMessage"] as? String {
            self = .custom(message)
        }
        else if let message = json["errorCode"] as? String {
            self = .custom(message)
        }
        else {
            self = .other
        }
    }
}


//@@@*** Defines HTTP Request types
enum RequestMethod: String {
    case get =      "GET"
    case post =     "POST"
    case put =      "PUT"
    case delete =   "DELETE"
}

//TODO: - Add more constructors here
extension URL {
    init(baseUrl: String, path: String, params: JSONDICT, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        switch method {
        case .get:
            components.queryItems = params.map {
               URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
            break
        default:
            break
        }
        
        self = components.url!
    }
    
    init(baseUrl: String, path: String, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        self = components.url!
    }
}

extension URLRequest {
    struct HTTPHeader {
        static let accept = "Accept"
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
        static let xdevice="x-device"
        static let xdeviceid="x-device-id"
        static let xdevicetoken="x-device-token"
        static let xproduct="x-product"
        static let cachecontrol="cache-control"
        static let xSessionId="x-session-id"
        static let xplatform_name="x-source-platform"
        static let xplatform_version="x-source-platform-version"
        static let xip_address="x-real-ip"
    }
    
    struct HTTPHeaderVal {
        static let Json = "application/json"
        static let UrlEncoded = "application/x-www-form-urlencode"
        static let xdeviceVal="iOS"
        static let xdeviceidVal = UIDevice.current.identifierForVendor!.uuidString 
        static let xproductVal="seeker"
        static let nocache="no-cache"
        static let platform_nameVal="iOS"
        static let platform_versionVal="\(MIUtils.appBuild) \(MIUtils.appVersion)"
        static let ip_addressVal=MIUtils.getIPAddress()

    }
}

//TODO: - Add more constructors here
extension URLRequest {
    init(baseUrl: String, path: String, method: RequestMethod, params: JSONDICT) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        timeoutInterval = 20.0
        setValue(HTTPHeaderVal.Json, forHTTPHeaderField: HTTPHeader.accept)
        setValue(HTTPHeaderVal.Json, forHTTPHeaderField: HTTPHeader.contentType)
        if !AppDelegate.instance.authInfo.accessToken.isEmpty{
            setValue("Bearer " + AppDelegate.instance.authInfo.accessToken, forHTTPHeaderField: HTTPHeader.authorization)
        }
        setValue(HTTPHeaderVal.xdeviceVal, forHTTPHeaderField: HTTPHeader.xdevice)
        setValue(HTTPHeaderVal.xdeviceidVal, forHTTPHeaderField: HTTPHeader.xdeviceid)
        setValue(HTTPHeaderVal.xproductVal, forHTTPHeaderField: HTTPHeader.xproduct)
        setValue(HTTPHeaderVal.platform_nameVal, forHTTPHeaderField: HTTPHeader.xplatform_name)
        setValue(HTTPHeaderVal.platform_versionVal, forHTTPHeaderField: HTTPHeader.xplatform_version)
        setValue(HTTPHeaderVal.ip_addressVal, forHTTPHeaderField: HTTPHeader.xip_address)

        setValue(sessionId, forHTTPHeaderField: HTTPHeader.xSessionId)
        
        let site = AppDelegate.instance.site
        setValue(site?.context, forHTTPHeaderField: "x-source-site-context")
        setValue(site?.defaultCountryDetails.isoCode, forHTTPHeaderField: "x-source-country")
        setValue("en", forHTTPHeaderField: "x-language-code")
        setValue( AppDelegate.instance.deviceToken, forHTTPHeaderField: HTTPHeader.xdevicetoken)
       // print(self.allHTTPHeaderFields)
        
        switch method {
        case .post, .put , .delete:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
            
        default:
            break
        }
    }
    
    //@@.. Using with Login especially ..@@
    init(baseUrl: String, path: String, method: RequestMethod, params: Any) {
        let url = URL(baseUrl: baseUrl, path: path, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        switch method {
        case .post, .put:
            if let str = params as? String {
                httpBody = str.data(using: .utf8)
            } else {
                httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            }
        default:
            break
        }
    }
}

//final
class MIAPIClient {
    
    var baseUrl: String
    static let sharedClient = MIAPIClient(baseUrl: BASE_IP_ADDRESS_API)
    private init() {self.baseUrl = BASE_IP_ADDRESS_API}
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    @discardableResult
    
    func load(path: String, method: RequestMethod, params: JSONDICT, completion: @escaping (Any?, ServiceError?,Int) -> ()) -> URLSessionDataTask? {
        // Checking internet connection availability
        if !MIReachability.isConnectedToNetwork() {
            completion(nil, ServiceError.noInternetConnection,500)
            return nil
        }
        
        // Creating the URLRequest object
        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params)
        
        // Sending request to the server.
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Parsing incoming data
            var object: Any? = nil
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }

             ServiceManager.printRequest(request.url?.absoluteString ?? "", header: request.allHTTPHeaderFields, method:method.rawValue, param: params, response: data,responseheader:response,error:error  )
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(object, nil,httpResponse.statusCode)
            }
            else {
                let error = (object as? JSONDICT).flatMap(ServiceError.init) ?? ServiceError.other
                if let httpResponse = response as? HTTPURLResponse{
                    completion(object, error,httpResponse.statusCode)
                    if httpResponse.statusCode == kAuthCode {
                        //                AppManager.sessionExpire()
                        DispatchQueue.main.async(execute: {
                            if let tabbar = (AppDelegate.instance.window?.rootViewController as? MIHomeTabbarViewController) ?? (AppDelegate.instance.window?.rootViewController?.presentedViewController?.presentedViewController as? MIHomeTabbarViewController)
                            {
                                tabbar.logoutUnAuthorizedUserPopUp()
                            }
                        })
                        return
                    }
                }else{
                    completion(nil,ServiceError.custom("Please try after some time"),508)
                }
            }
        }
        task.resume()
        return task
    }
    
    
//    func load(path: String, method: RequestMethod, params: String, completion: @escaping (Any?, ServiceError?) -> ()) -> URLSessionDataTask? {
//        // Checking internet connection availability
//        if !MIReachability.isConnectedToNetwork() {
//            completion(nil, ServiceError.noInternetConnection)
//            return nil
//        }
//
//        // Creating the URLRequest object
//        let request = URLRequest(baseUrl: baseUrl, path: path, method: .get, params: params)
//
//        // Sending request to the server.
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            // Parsing incoming data
//            var object: Any? = nil
//            if let data = data {
//                object = try? JSONSerialization.jsonObject(with: data, options: [])
//            }
//
//            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
//                completion(object, nil)
//            }
//            else {
//                let error = (object as? JSONDICT).flatMap(ServiceError.init) ?? ServiceError.other
//                completion(object, error)
//            }
//        }
//        task.resume()
//        return task
//    }
    
    @discardableResult
    func validiateSEO(_ param: [String: String], completion: @escaping (Any?, ServiceError?, Int) -> ()) -> URLSessionDataTask? {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: true, isDeviceToken: true, extraDic: nil) ?? [:]
        
        if !MIReachability.isConnectedToNetwork() {
            completion(nil, ServiceError.noInternetConnection,500)
            return nil
        }
        var request = URLRequest(baseUrl: baseUrl, path: APIPath.validiateSEOURL, method: .post, params: param)
        
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        // Sending request to the server.
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Parsing incoming data
            var object: Any? = nil
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(object, nil,httpResponse.statusCode)
            } else {
                let error = (object as? JSONDICT).flatMap(ServiceError.init) ?? ServiceError.other
                if let httpResponse = response as? HTTPURLResponse{
                    completion(object, error,httpResponse.statusCode)
                    if httpResponse.statusCode == kAuthCode {
                        DispatchQueue.main.async(execute: {
                            if let tabbar = (AppDelegate.instance.window?.rootViewController as? MIHomeTabbarViewController) ?? (AppDelegate.instance.window?.rootViewController?.presentedViewController?.presentedViewController as? MIHomeTabbarViewController)
                            {
                                tabbar.logoutUnAuthorizedUserPopUp()
                            }
                        })
                        return
                    }
                }else{
                    completion(nil,ServiceError.custom("Please try after some time"),508)

                }
            }
            
        }
        task.resume()
        return task
    }
    
}
