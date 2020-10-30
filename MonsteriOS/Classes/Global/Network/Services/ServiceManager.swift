//
//  ServiceManager.swift
//
//  Created by Piyush Dwivedi on 27/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//


import UIKit

let kSuccessCode     = 200
let kAuthCode        = 401
let kBAD_URL_CODE    = 999
let kNoInternetConn  = 5000

typealias ServiceCompletion = (_ sucess: Bool, _ response: Any?, _ error: Error?, _ code: Int) -> Swift.Void
internal typealias CompletionHandler<T> = (_ result: T?, _ error: Swift.Error?) -> Void


public enum ServiceMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    
    func requestWithArrayObject(path: String, param: [[String: Any]]?, headers: [String: String]?, isJsonType: Bool = false) -> URLRequest? {
        if let url = URL(string: path) {
            let request         = NSMutableURLRequest(url: url)
            request.httpMethod  = self.rawValue
            
            if let mHeader = headers {
                for hEntity in mHeader {
                    request.setValue(hEntity.value, forHTTPHeaderField: hEntity.key)
                }
            }
            
            if param != nil && self != .get {
                if isJsonType == true {
                    request.httpBody = try! JSONSerialization.data(withJSONObject: param!, options: [])
                } else {
                    request.httpBody = try! JSONSerialization.data(withJSONObject: param!, options: [])
                }
            }
            return request as URLRequest
        }
        return nil
    }
    func requestWith(path: String, param: [String: Any]?, headers: [String: String]?, isJsonType: Bool = false) -> URLRequest? {
        if let url = URL(string: path) {
            let request         = NSMutableURLRequest(url: url)
            request.httpMethod  = self.rawValue
            
            if let mHeader = headers {
                for hEntity in mHeader {
                    request.setValue(hEntity.value, forHTTPHeaderField: hEntity.key)
                }
            }
            
            if param != nil && self != .get {
                if isJsonType == true {
                    request.httpBody = try! JSONSerialization.data(withJSONObject: param!, options: [])
                }
                else {
                    if let mParam = param as? [String : String] {
                        request.encode(parameters: mParam)
                    } else {
                        request.httpBody = try! JSONSerialization.data(withJSONObject: param!, options: [])
                    }
                }
            }
            return request as URLRequest
        }
        return nil
    }
}

/*
 * MARK: - ServiceManager
 * Description:-  A class is written just to call the API.
 */
class ServiceManager: NSObject {
    class func codeFrom(res: URLResponse?) -> Int {
        if let mResponse = res as? HTTPURLResponse {
            return mResponse.statusCode
        }
        return kBAD_URL_CODE
    }
    
    class func dictFrom(data: Data?) -> Any? {
        if let mData = data  {
            var myDict : Any?
            do {
                myDict = try JSONSerialization.jsonObject(with: mData, options:
                    JSONSerialization.ReadingOptions.mutableContainers)
                
            } catch {
            }
            return myDict
        }
        return nil
    }
    
    // MARK: - Execute the Service (Calling API)
    class func executeArrayObject(method: ServiceMethod, path: String,
                                  param: [[String: Any]]?,
                                  header:[String: String]?,
                                  isJsonType: Bool = false,
                                  completion : ServiceCompletion?) {
        
        if !MIReachability.isConnectedToNetwork() {
            DispatchQueue.main.async(execute: {
                completion?(false, nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
            })
            return
        }
        
        guard let request = method.requestWithArrayObject(path: path, param: param, headers: header, isJsonType: isJsonType) else {  // Invalid Request...
            DispatchQueue.main.async(execute: {
                completion?(false, nil, nil, kBAD_URL_CODE)
            })
            return
        }
        
        
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            printRequest(path, header: header, method: method.rawValue, param: param, response: data, responseheader: response, error: error)
            let stCode = ServiceManager.codeFrom(res: response)
            if !MIReachability.isConnectedToNetwork() {
                DispatchQueue.main.async(execute: {
                    completion?(false, nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
                })
                return
            }
            if stCode == kAuthCode {
                DispatchQueue.main.async(execute: {
                    completion?(true, nil, nil, kAuthCode)
                    if let tabbar = (AppDelegate.instance.window?.rootViewController as? MIHomeTabbarViewController) ?? (AppDelegate.instance.window?.rootViewController?.presentedViewController?.presentedViewController as? MIHomeTabbarViewController)
                    {
                        tabbar.logoutUnAuthorizedUserPopUp()
                    }
                })
                return
            }
            if let _ = error {
                completion?(false, nil, nil, kBAD_URL_CODE)
                return
            }
            var mDict : Any? = nil
            if let theDict = ServiceManager.dictFrom(data: data) {
                mDict = theDict
            } else {
                if let str = String(data: data!, encoding: .utf8) {
                    mDict = ["resStr": str]
                }
            }
            completion?(true, mDict, nil, stCode)
        }
        task.resume()
    }
    class func execute(method: ServiceMethod, path: String,
                       param: [String: Any]?,
                       header:[String: String]?,
                       isJsonType: Bool = false,
                       completion : ServiceCompletion?) {
        if param != nil {
            // print("Request ----->  \(json)")
            param?.dictionaryToJSONString(printData: false)
        }
        if !MIReachability.isConnectedToNetwork() {
            DispatchQueue.main.async(execute: {
                completion?(false, nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
            })
            return
        }
        guard let request = method.requestWith(path: path, param: param, headers: header, isJsonType: isJsonType) else {  // Invalid Request...
            DispatchQueue.main.async(execute: {
                completion?(false, nil, nil, kBAD_URL_CODE)
            })
            return
        }
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            DispatchQueue.global(qos: .background).async {
                printRequest(path, header: header, method: method.rawValue, param: param, response: data, responseheader: response, error: error)
            }
            if !MIReachability.isConnectedToNetwork() {
                DispatchQueue.main.async(execute: {
                    completion?(false, nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
                })
                return
            }
            let stCode = ServiceManager.codeFrom(res: response)
            if stCode == kAuthCode {
                DispatchQueue.main.async(execute: {
                    completion?(true, nil, nil, kAuthCode)
                    if let tabbar = (AppDelegate.instance.window?.rootViewController as? MIHomeTabbarViewController) ?? (AppDelegate.instance.window?.rootViewController?.presentedViewController?.presentedViewController as? MIHomeTabbarViewController)
                    {
                        tabbar.logoutUnAuthorizedUserPopUp()
                    }
                })
                return
            }
            
            if let _ = error {
                completion?(false, nil, nil, kBAD_URL_CODE)
                return
            }
            var mDict : Any? = nil
            if let theDict = ServiceManager.dictFrom(data: data) {
                mDict = theDict
                //                AppManager.writeInLog(mDict)
            } else {
                if let str = String(data: data!, encoding: .utf8) {
                    mDict = ["resStr": str]
                }
            }
            
            if let response = (response as? HTTPURLResponse) {
                let abTestingUrl = APIPath.abTestingAPI.replacingOccurrences(of: kBaseUrl, with: "")
                let jobSeekerMapEvent = APIPath.seekerMapEvents.replacingOccurrences(of: kBaseUrl, with: "")
                
                if ((response.url?.absoluteString.lowercased().range(of: abTestingUrl) != nil) ||  (response.url?.absoluteString.lowercased().range(of: jobSeekerMapEvent) != nil) ) {
                    if (response.statusCode >= 200) && (response.statusCode <= 299)    {
                        
                        if let sessionID = response.allHeaderFields["sessionid"] as? String {
                            sessionId = sessionID
                        }
                    }
                }
            }
            completion?(true, mDict, nil, stCode)
        }
        task.resume()
    }
    
    
    class func execute(path: String, param: [String: Any]?,header:[String: String]?, image: Data?, imageParameter: String, completion : ServiceCompletion?) {
        
        if !MIReachability.isConnectedToNetwork() {
            DispatchQueue.main.async(execute: {
                completion?(false, nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
            })
            return
        }
        guard let request = ServiceManager.requestImageWith(path: path, param: param, headers: header, image: image, imageParameter: imageParameter) else {  // Invalid Request...
            
            DispatchQueue.main.async(execute: {
                completion?(false, nil, nil, kBAD_URL_CODE)
            })
            return
        }
        let task = URLSession.shared.dataTask(with: request) {
            
            (data, response, error) in
            
            if !MIReachability.isConnectedToNetwork() {
                DispatchQueue.main.async(execute: {
                    completion?(false, nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
                })
                return
            }
            let stCode = ServiceManager.codeFrom(res: response)
            if stCode == kAuthCode { // authentication error
                
                DispatchQueue.main.async(execute: {
                    
                    completion?(true, nil, nil, kAuthCode)
                    if let tabbar = (AppDelegate.instance.window?.rootViewController as? MIHomeTabbarViewController) ?? (AppDelegate.instance.window?.rootViewController?.presentedViewController?.presentedViewController as? MIHomeTabbarViewController)
                    {
                        tabbar.logoutUnAuthorizedUserPopUp()
                    }
                })
                return
            }
            
            if let _ = error {
                completion?(false, nil, nil, kBAD_URL_CODE)
                return
                
            }
            let mDict = ServiceManager.dictFrom(data: data)
            completion?(true, mDict, nil, stCode)
        }
        
        task.resume()
    }
    
    class func requestForMultiPartData(path:String, params:[String:Any]?, fileExtension:String?, headers:[String:String]?, completion: ServiceCompletion?, fileName:String?) {
        if !MIReachability.isConnectedToNetwork() {
            DispatchQueue.main.async(execute: {
                completion?(false, nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
            })
            return
        }
        if let urlPath = URL(string: path) {
            let request = NSMutableURLRequest(url: urlPath)
            request.httpMethod = "POST"
            
            let boundary = "Boundary-\(NSUUID().uuidString)"
            
            if let mHeader = headers {
                for hEntity in mHeader {
                    request.setValue(hEntity.value, forHTTPHeaderField: hEntity.key)
                }
            }
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = request.createBodyForFormData(boundary: boundary, params: params!, fileExtension: fileExtension!, fileName: fileName) as Data
            if let mHeader = headers {
                for hEntity in mHeader {
                    request.setValue(hEntity.value, forHTTPHeaderField: hEntity.key)
                }
            }
            request.timeoutInterval = 60
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                if !MIReachability.isConnectedToNetwork() {
                    DispatchQueue.main.async(execute: {
                        completion?(false, nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
                    })
                    return
                }
                let stCode = ServiceManager.codeFrom(res: response)
                if stCode == kAuthCode {
                    DispatchQueue.main.async(execute: {
                        completion?(true, nil, nil, kAuthCode)
                        if let tabbar = (AppDelegate.instance.window?.rootViewController as? MIHomeTabbarViewController) ?? (AppDelegate.instance.window?.rootViewController?.presentedViewController?.presentedViewController as? MIHomeTabbarViewController)
                        {
                            tabbar.logoutUnAuthorizedUserPopUp()
                        }
                    })
                    return
                }
                
                if let _ = error {
                    completion?(false, nil, nil, kBAD_URL_CODE)
                    return
                }
                var mDict : Any? = nil
                if let theDict = ServiceManager.dictFrom(data: data) {
                    mDict = theDict
                } else {
                    if let str = String(data: data!, encoding: .utf8) {
                        mDict = ["resStr": str]
                    }
                }
                completion?(true, mDict, nil, stCode)
            }
            
            task.resume()
            
        }
        
    }
    
    class func requestImageWith(path: String, param: [String: Any]?,headers: [String: String]?, image: Data?, imageParameter: String) -> URLRequest? {
        
        if let url = URL(string: path) {
            
            let request = NSMutableURLRequest(url: url as URL)
            
            request.httpMethod = "POST"
            
            let boundary = "Boundary-\(NSUUID().uuidString)"
            
            
            if let mHeader = headers {
                for hEntity in mHeader {
                    request.setValue(hEntity.value, forHTTPHeaderField: hEntity.key)
                }
            }
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var image_data:Data?
            if image != nil {
                image_data = image
            }
            if(image_data == nil)  { }
            let body = NSMutableData()
            
            let fname = "document"
            let mimetype = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\(imageParameter); filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            if image_data != nil, (image_data?.count)! > 0 {
                body.append(image_data!)
            }else {
                body.append(Data())
            }
            
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            request.httpBody = body as Data
            
            return request as URLRequest
            
        }
        return nil
        
    }
    
    class func getRemoteDate(path:String,isJSonType:Bool = false,completion:ServiceCompletion?) {
        //        let url = URL(string: path)
        //        let theRequest = NSURLRequest(url: url!)
        
        let url = URL(string: path)!
        
        let request         = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            //   printDebug(response as Any)
        }
        task.resume()
    }
    
    
    
    // MARK: - Execute the Service (For Social)
    class func executeSocialAPI(_ method: ServiceMethod, path: String,
                                param: Any?,
                                header:[String: String]?,
                                isJsonType: Bool = false,
                                completion : ((Data?, Error?, Int?) -> Void)?) {
        
        var request: URLRequest?
        if let params = param as? [String: Any] {
            request = method.requestWith(path: path, param: params, headers: header, isJsonType: isJsonType)
        } else {
            request = method.requestWithArrayObject(path: path, param: param as? [JSONDICT], headers: header, isJsonType: isJsonType)
        }
        if !MIReachability.isConnectedToNetwork() {
            DispatchQueue.main.async(execute: {
                completion?(nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
            })
            return
        }
        guard let req = request else {  // Invalid Request...
            DispatchQueue.main.async(execute: {
                completion?(nil, nil, nil)
            })
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: req) {
            (data, response, error) in
            printRequest(path, header: header, method: method.rawValue, param: param, response: data, responseheader: response, error: error)
            DispatchQueue.main.async(execute: {
                if !MIReachability.isConnectedToNetwork() {
                    completion?(nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]), kNoInternetConn)
                    return
                }
                completion?(data, error, (response as? HTTPURLResponse)?.statusCode)
            })
        }
        task.resume()
    }
    
    // MARK: - Execute the Service (Calling API)
    //@discardableResult
    class func executeAPI(_ method: ServiceMethod, path: String,
                          param: Any?,
                          header:[String: String]?,
                          isJsonType: Bool = false,
                          completion : ((Data?, Error?) -> Void)?)  {
        
        var request: URLRequest?
        if let params = param as? [String: Any] {
            request = method.requestWith(path: path, param: params, headers: header, isJsonType: isJsonType)
        } else {
            request = method.requestWithArrayObject(path: path, param: param as? [JSONDICT], headers: header, isJsonType: isJsonType)
        }
        
        guard let req = request else {  // Invalid Request...
            DispatchQueue.main.async(execute: {
                completion?(nil, nil)
            })
            return //nil
        }
        if !MIReachability.isConnectedToNetwork() {
            DispatchQueue.main.async(execute: {
                completion?(nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]))
            })
            return
        }
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil )
        
        let task = session.dataTask(with: req) {
            (data, response, error) in
            DispatchQueue.main.async {
                if !MIReachability.isConnectedToNetwork() {
                    completion?(nil, NSError.init(domain: "com.no.internet", code: kNoInternetConn, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection Found."]))
                    return
                }
                printRequest(path, header: header, method: method.rawValue, param: param, response: data, responseheader: response, error: error)
                completion?(data, error)
            }
            if let response = (response as? HTTPURLResponse) {
                let abTestingUrl = APIPath.abTestingAPI.replacingOccurrences(of: kBaseUrl, with: "")
                let jobSeekerMapEvent = APIPath.seekerMapEvents.replacingOccurrences(of: kBaseUrl, with: "")
                
                if ((response.url?.absoluteString.lowercased().range(of: abTestingUrl) != nil) ||  (response.url?.absoluteString.lowercased().range(of: jobSeekerMapEvent) != nil) ) {
                    if (response.statusCode >= 200) && (response.statusCode <= 299)    {
                        if let sessionID = response.allHeaderFields["sessionid"] as? String {
                            sessionId = sessionID
                        }
                    }
                }
            }
            
        }
        task.resume()
        
        // return task
    }
}
struct ImageHeaderData{
    static var PNG: UInt8 = 0x89
    static var JPEG: UInt8 = 0xFF
    static var GIF: UInt8 = 0x47
    static var TIFF_01: UInt8 = 0x49
    static var TIFF_02: UInt8 = 0x4D
    static var PDF: UInt8 = 0x37
    static var DOC: UInt8 = 0x80
    static var RTF: UInt8 = 123
    
}

enum ImageFormat{
    case Unknown, PNG, JPEG, GIF, TIFF
}

extension String {
    
    var mimeType : String {
        if self == "pdf" {
            return "application/pdf"
            
        }
        if self == "doc" {
            return "application/msword"
            
        }
        
        if self == "docx" {
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        }
        if self == "rtf" {
            return "application/rtf"
            
        }
        if self == "png" {
            return "image/png"
            
        }
        if self == "jpg" {
            return "image/jpeg"
            
        }
        
        return ""
    }
}

extension NSMutableURLRequest {
    
    private func percentEscape(str: String) -> String {
        var characterSet = NSMutableCharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return str.addingPercentEncoding(withAllowedCharacters: characterSet)!.replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    
    func encode(parameters: [String : String]) {
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscape(str: value))"
        }
        
        self.httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
    
    func createBodyForFormData(boundary: String, params: [String:Any], fileExtension:String, fileName:String?) -> NSMutableData {
        let bodyData = NSMutableData()
        for (key, value) in params {
            
            if value is String || value is Bool {
                bodyData.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
                
            } else if value is Dictionary<String,Any> {
                for(nestedkey,nestedvalue) in value as! [String:Any]{
                    if nestedvalue is String {
                        bodyData.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        bodyData.append("Content-Disposition: form-data; name=\"\(nestedkey)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                        bodyData.append("\(nestedvalue)\r\n".data(using: String.Encoding.utf8)!)
                    }
                }
                
            } else if value is Data {
                let imgData = value as! Data
                bodyData.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                if fileName == nil {
                    
                    bodyData.append("Content-Disposition: form-data; name=\(key); filename=\"\(Int(Date().timeIntervalSince1970)).\(fileExtension)\"\r\n".data(using: String.Encoding.utf8)!)
                    
                }else{
                    bodyData.append("Content-Disposition: form-data; name=\(key); filename=\"\(fileName ?? "\(Int(Date().timeIntervalSince1970))").\(fileExtension)\"\r\n".data(using: String.Encoding.utf8)!)
                    
                }
                bodyData.append("Content-Type: \(fileExtension.mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append(imgData)
                bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                
            } else if value is Array<Any> {
                let arrayData = value as! Array<Any>
                for (_ , obj) in arrayData.enumerated() {
                    if obj is Data {
                        let imgData = obj as! Data
                        bodyData.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        if (fileName?.isEmpty)! {
                            bodyData.append("Content-Disposition: form-data; name=\(key); filename=\"\(Int(Date().timeIntervalSince1970)).\(fileExtension)\"\r\n".data(using: String.Encoding.utf8)!)
                            
                        }else{
                            bodyData.append("Content-Disposition: form-data; name=\(key); filename=\"\(fileName ?? "\(Int(Date().timeIntervalSince1970))").\(fileExtension)\"\r\n".data(using: String.Encoding.utf8)!)
                        }
                        bodyData.append("Content-Type: \(fileExtension.mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                        bodyData.append(imgData)
                        
                        bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                        
                    } else if obj is [String:Any] {
                        if  let paramsData = obj  as? [String:Any] {
                            for(key , value) in paramsData {
                                if value is Data {
                                    let imgData = value as! Data
                                    bodyData.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                    if fileName == nil {
                                        
                                        bodyData.append("Content-Disposition: form-data; name=\(key); filename=\"\(Int(Date().timeIntervalSince1970)).\(fileExtension)\"\r\n".data(using: String.Encoding.utf8)!)
                                        
                                    }else{
                                        bodyData.append("Content-Disposition: form-data; name=\(key); filename=\"\(fileName ?? "\(Int(Date().timeIntervalSince1970))").\(fileExtension)\"\r\n".data(using: String.Encoding.utf8)!)
                                        
                                    }
                                    bodyData.append("Content-Type: \(fileExtension.mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                                    bodyData.append(imgData)
                                    bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
        bodyData.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        return bodyData
    }
}

extension HTTPURLResponse {
    
    func setSessionIdFromResponseHeader(){
        
        let abTestingUrl = APIPath.abTestingAPI.replacingOccurrences(of: kBaseUrl, with: "")
        let jobSeekerMapEvent = APIPath.seekerMapEvents.replacingOccurrences(of: kBaseUrl, with: "")
        
        if ((self.url?.absoluteString.lowercased().range(of: abTestingUrl) != nil) ||  (self.url?.absoluteString.lowercased().range(of: jobSeekerMapEvent) != nil) ) {
            if (self.statusCode >= 200) && (self.statusCode <= 299)    {
                
                if let sessionID = self.allHeaderFields["sessionid"] as? String {
                    sessionId = sessionID
                }
            }
        }
    }
}


extension ServiceManager {
    
    class func printRequest(_ url: String, header: JSONDICT?, method: String, param: Any?, response: Data?,responseheader:URLResponse?,error:Error?) {
        
        #if DEBUG
        do {
            let headerFormat = try JSONSerialization.data(withJSONObject: header ?? [:], options: .prettyPrinted)
            let paramsFormat = try JSONSerialization.data(withJSONObject: param ?? [:], options: .prettyPrinted)
            
            printDeviceLogger(
                """
                \n
                API Request:-
                --------------
                URL         : \(url)
                Headers     : \(String(bytes: headerFormat , encoding: .utf8) ?? "")
                HTTP Method : \(method)
                Parameters  : \(String(bytes: paramsFormat , encoding: .utf8) ?? "")
                
                Response    : \(String(bytes: response ?? Data(), encoding: .utf8) ?? "")
                
                URLResponse : \(responseheader ?? URLResponse())

                Error       : \(error ?? NSError.init(domain: "com.dummy.error", code: 100, userInfo: [NSLocalizedDescriptionKey: "Default check error."]))

                \n\n
                """
            )
        } catch let error as NSError {
            print(error)
        }
        
        #endif

    }
    
}

func printDeviceLogger(_ obj: String) {

  //  NSLog("%@", obj)
   printDebug(obj)
}

func printDebug<T>(_ obj: T) {
    #if DEBUG
      print(obj)
    #endif
}
