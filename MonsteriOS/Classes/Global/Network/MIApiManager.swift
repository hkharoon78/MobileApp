//
//  MIOnBoardManager.swift
//  MonsterIndia
//
//  Created by Monster on 12/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIApiManager: NSObject {

    class  func callAutoSuggest(searchTxt:String,excludeString:String, completion: @escaping ServiceCompletion) {
        
        let site = AppDelegate.instance.site
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        
        var aPath = APIPath.autoSuggestApi + searchTxt.addValueOFSpace() +  "&groupName=\(site?.defaultCountryDetails.langOne?.first?.name ?? "India")"
        
        
        if site?.defaultCountryDetails.langOne?.first?.name.lowercased() != "gulf" {
            var groupName = "SEA"
            if site?.defaultCountryDetails.langOne?.first?.name.lowercased() == "india" {
                groupName = site?.defaultCountryDetails.langOne?.first?.name ?? "India"
            }
            let countryName = site?.defaultCountryDetails.langOne?.first?.name ?? "India"
            aPath = APIPath.autoSuggestApi + searchTxt.addValueOFSpace() +  "&groupName=\(groupName)&countryName=\(countryName)"
        }
        
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class  func callSuggestedKeyword(key:String,excludeString:String, completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        let aPath = APIPath.suggestedKeyword + key
            //+ excludeString.addValueOFSpace()
        ServiceManager.execute(method: .get, path: aPath.encodedUrl(), param: nil, header: header, completion: completion)
    }
    
    class  func callHomeService(completion: @escaping ServiceCompletion) {
        
        let site = AppDelegate.instance.site
        //macaw/api/public/mobiles/sites/v1/load-data
        let aPath =  "\(kBaseUrl)/macaw/api/public/mobiles/sites/v1/load-data?site=\(site?.context ?? "rexmonster")&tenant=ios&category=home&lang=en&searchId="
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class  func callUpSkillService(completion: @escaping ServiceCompletion) {
        
        
        let site = AppDelegate.instance.site
        let aPath = "\(kBaseUrl)/macaw/api/public/mobiles/sites/v1/load-data?site=\(site?.context ?? "rexmonster")&tenant=ios&category=upskill&lang=en"
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class  func callLocationService(key:String, completion: @escaping ServiceCompletion) {
        
        let site = AppDelegate.instance.site
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        
        var aPath = APIPath.locationApi + key.addValueOFSpace() +  "&groupName=\(site?.defaultCountryDetails.langOne?.first?.name ?? "Gulf")"
        if site?.defaultCountryDetails.langOne?.first?.name.lowercased() != "gulf" {
            var groupName = "SEA"
            if site?.defaultCountryDetails.langOne?.first?.name.lowercased() == "india" {
                groupName = site?.defaultCountryDetails.langOne?.first?.name ?? "India"
            }
            let countryName = site?.defaultCountryDetails.langOne?.first?.name ?? "India"
            aPath = APIPath.locationApi + key.addValueOFSpace() + "&groupName=\(groupName)&countryName=\(countryName)"
        }
        
//        aPath.append("&siteContext=\(site?.context ?? "rexmonster")")
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class func callGetProfileApi(completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        let fields = "awards,skills,resumes,projects,it_skills,languages,educations,employments,saved_searches,pending_actions,social_presence,additional_profiles,courses_and_certifications,personal_details,personal_details,job_preferences"
        
        let aPath = APIPath.getProfileApi + fields
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class func callGetExistingProfile(completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        let aPath = APIPath.getExistingProfileApi
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class func callCreateEmptyProfile(completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        let aPath = APIPath.createEmptyProfileApi
        ServiceManager.execute(method: .post, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class func callImportProfile(param:[String:Any],completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        let aPath = APIPath.importProfileApi
        
        ServiceManager.execute(method: .post, path: aPath, param: param, header: header,isJsonType:true, completion: completion)
    }
    
    class func getProfileAPI(completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        let fields = "pending_actions,personal_details,skills,it_skills,additional_profiles,job_preferences"
        let aPath = APIPath.getProfileApi + fields
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class func updateProfileTitleAPI(profileTitle:String,completion: @escaping ServiceCompletion) {
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        let aPath = APIPath.updateProfileTitleApi
        let param = ["title": profileTitle]
        ServiceManager.execute(method: .put, path: aPath, param: param, header: header, completion: completion)
    }
    
    class func callCreateProfileLanguage(requestType:ServiceMethod,params:[[String:Any]],completion: @escaping ServiceCompletion) {
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        let aPath = APIPath.languageCreateProfileApi
        
        ServiceManager.executeArrayObject(method: requestType, path: aPath, param: params, header: header, isJsonType: true, completion: completion)
    }
    
    class func callDeleteProfileLanguage(param:[String:Any],completion: @escaping ServiceCompletion) {
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        let aPath = APIPath.languageCreateProfileApi
        ServiceManager.execute(method: .delete, path: aPath, param: param, header: header, completion: completion)
    }
    
    class func downloadResume(completion: @escaping (_ sucess: Bool, _ data: Data?, _ error: Error?, _ code: Int) -> Swift.Void) {
        
        let profileID = UserDefaults.standard.integer(forKey: "profileId")
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        let aPath = APIPath.downloadResumeApi + "\(profileID)"
        
        guard let request = ServiceMethod.get.requestWith(path: aPath, param: nil, headers: header, isJsonType: false) else {  // Invalid Request...
            DispatchQueue.main.async(execute: {
                completion(false, nil, nil, kBAD_URL_CODE)
            })
            return
        }
        
        URLSession.shared.downloadTask(with: request) { (url, response, error) in
            
            var data: Data?
            
            if let url = url {
                do {
                    data = try Data(contentsOf: url)
                } catch let e{
                    print(e)
                }
            }
            completion(true, data, error, (response as? HTTPURLResponse)?.statusCode ?? 400)

           // completion(true, data, error, data == nil ? kBAD_URL_CODE : kSuccessCode)
            }.resume()
    }
    
    
//    class  func callsrplistingService(completion: @escaping ServiceCompletion) {
//        let aPath = APIPath.srpListingApi
//        ServiceManager.execute(method: .get, path: aPath, param: nil, header: nil, completion: completion)
//    }
    
    class func callMasterService(funType:String, parentId:String, limit:String, countryISO:String? ,completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        var aPath = APIPath.masterListingApi + funType + parentId + "&limit=\(limit)"
        if funType == MasterDataType.LOCATION.rawValue {
            let site = AppDelegate.instance.site
            aPath.append("&siteContext=\(site?.context ?? "rexmonster")")

        }
        if funType == MasterDataType.VISA_TYPE.rawValue {
            aPath = APIPath.masterListingApi + funType + parentId + "&limit=\(limit)" + "&countryIsoCode=\(countryISO ?? "in")"
        }
        
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class func callMasterServiceSearching(searchString:String,funcType:String,parentId:String, limit:String, countryISO:String?,completion: @escaping ServiceCompletion) {
        
        var aPath = APIPath.masterListingApi + funcType + parentId + "&limit=\(limit)" + "&name=\(searchString.addValueOFSpace())"
        
        if funcType == "LOCATION" {
            aPath = APIPath.masterListingApi + funcType + "&limit=\(limit)" + "&name=\(searchString.addValueOFSpace())"
        }
        let header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: false, isDeviceToken: true, extraDic: nil)

        if funcType == MasterDataType.VISA_TYPE.rawValue {
            aPath = APIPath.masterListingApi + funcType + parentId + "&limit=\(limit)" + "&countryIsoCode=\(countryISO ?? "in")" + "&name=\(searchString.addValueOFSpace())"
        }
        
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: header, completion: completion)
    }
    
    class func callAPIForEmploymentEducationSkillDetail(method:ServiceMethod = .post,apiPath:String,params:[String:Any],completion: @escaping ServiceCompletion) {
        
        if !MIReachability.isConnectedToNetwork() {
            //No internet check
            completion(false,nil,ServiceError.noInternetConnection,503)

            return
        }
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .post, path:apiPath, param: params, header: header,isJsonType:true, completion: completion)
        
    }
    
    
    
    class func callAPIForRegisterPersonalDetail(path:String,params:[String:Any],completion:@escaping ServiceCompletion) {
        if !MIReachability.isConnectedToNetwork() {
            //No internet check
            completion(false,nil,ServiceError.noInternetConnection,503)

            return
        }

        let header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: false, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.requestForMultiPartData(path: path, params: params, fileExtension: "", headers: header, completion: completion, fileName: nil)
        
        //       ServiceManager.execute(path: path, param: params, header: header, image: nil, imageParameter: "", completion: completion)
    }
    
    class func callAPIForJobPreference(path:String,method:ServiceMethod,params:[String:Any], headerDict: [String: String], completion:@escaping ServiceCompletion) {
        
        if !MIReachability.isConnectedToNetwork() {
            //No internet check
            completion(false,nil,ServiceError.noInternetConnection,503)
            return
        }
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: headerDict)
        
        ServiceManager.execute(method: method, path: path, param: params, header: header, completion: completion)
        
    }
    
    class func callAPIForUploadAvatarResume(path:String,params:[String:Any],extenstion:String,filename:String?,customHeaderParams:[String:String],completion:@escaping ServiceCompletion) {
        if !MIReachability.isConnectedToNetwork() {
            //No internet check
            completion(false,nil,ServiceError.noInternetConnection,503)
            return
        }
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: false, extraDic: customHeaderParams)
        
        ServiceManager.requestForMultiPartData(path: path, params: params, fileExtension: extenstion, headers: header, completion: completion, fileName: filename)
    } 
    
    class func callAPIForUpdateEmploymentEducation(methodType:ServiceMethod,path:String,params:[[String:Any]],customHeaderParams:[String:String],completion:@escaping ServiceCompletion) {
        
        if !MIReachability.isConnectedToNetwork() {
            //No internet check
            completion(false,nil,ServiceError.noInternetConnection,503)
            return
        }
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: customHeaderParams)
        
        ServiceManager.executeArrayObject(method:methodType, path: path, param: params, header: header, completion:completion)
    }
    
    class func callAPIForUpdatePersonalDetail(methodType:ServiceMethod,path:String,params:[String:Any],completion:@escaping ServiceCompletion) {
        
        if !MIReachability.isConnectedToNetwork() {
            //No internet check
            completion(false,nil,ServiceError.noInternetConnection,503)
            return
        }
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: nil)
        
        ServiceManager.execute(method: methodType, path: path, param: params, header: header, completion: completion)
    }
    
    
    class func callAPIForGetPersonalDetail(methodType:ServiceMethod,path:String,completion:@escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: nil)
        
        ServiceManager.execute(method: methodType, path: path, param: nil, header: header, completion: completion)
    }
    
    class func callAPIForGETRecentKeywords(methodType:ServiceMethod,path:String,completion:@escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: true, isDeviceToken: false, extraDic: nil)
        ServiceManager.execute(method: methodType, path: path, param: nil, header: header, completion: completion)
    }
    
    class func callAPIForDeleteRecentKeywords(keywords:String,completion:@escaping ServiceCompletion) {
        let path = APIPath.recentSearchDeleteApi
        let header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: true, isDeviceToken: false, extraDic: nil)

        
        let dic = ["deviceId":UIDevice.current.identifierForVendor!.uuidString,"label":keywords]
        
        let param = [
            "events" : [dic]
            ] as [String : Any]
        
        ServiceManager.execute(method: .delete, path: path, param: param, header: header, completion: completion)
    }
    
    class func callAPIForDeleteRecentSearchAll(completion:@escaping ServiceCompletion) {
        let path = APIPath.recentSearchDeleteAll
        let header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: true, isDeviceToken: false, extraDic: nil)
        
        let dic = ["deviceId":UIDevice.current.identifierForVendor!.uuidString]
        
        let param = [
            "events" : [dic]
            ] as [String : Any]
        
        ServiceManager.execute(method: .delete, path: path, param: param, header: header, completion: completion)
    }
    
    
    class func callAPIForUpdateAddSkill(methodType:ServiceMethod,path:String,params:[[String:Any]],customHeader:[String:String],completion:@escaping ServiceCompletion) {
        
        if !MIReachability.isConnectedToNetwork() {
            //No internet check
            completion(false,nil,ServiceError.noInternetConnection,503)
            return
        }
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: customHeader)
        
        ServiceManager.executeArrayObject(method:methodType, path: path, param: params, header: header, completion:completion)
    }
    
    
    class func callAPIForSendOTP(methodType:ServiceMethod,path:String,params:[String:Any], headerDict: [String: String]? = nil, completion:@escaping ServiceCompletion) {

        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: headerDict)
        
        ServiceManager.execute(method: methodType, path: path, param: params, header: header,isJsonType:true, completion: completion)
        
        
    }
    
    class func callAPIForValidateOTP(methodType:ServiceMethod,path:String,params:[String:Any], headerDict: [String: String]? = nil,completion:@escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: headerDict)
        
        ServiceManager.execute(method: methodType, path: path, param: params, header: header,isJsonType:true, completion: completion)
        
        
    }
    class func callAPIForDeleteSkills(methodType:ServiceMethod,path:String,params:[String:Any],completion:@escaping ServiceCompletion) {
        
         let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: nil)
        
        ServiceManager.execute(method: methodType, path: path, param: params, header: header,isJsonType:true, completion: completion)
    }
    
    class func callAPIToRemoveProfilePic(path:String,completion:@escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .put, path: path, param: nil, header: header, completion: completion)
        
    }
    
    class func callAPIToUploadMultipleImagesForOCR(dataArr: [Data], completion:@escaping ServiceCompletion) {
               
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.requestForMultiPartData(path: APIPath.uploadResumeForOCREndPoint, params: ["fileToUpload": dataArr], fileExtension: "png", headers: header, completion: completion, fileName: "")
        
    }
    
    class func callAPIForSendMailForVerify(completion:@escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .post, path: APIPath.verifyemailApiEndPoint, param: [:], header: header, completion: completion)
    }
    class func callAPIForUpdateProfileTitle(methodType:ServiceMethod,path:String,params:[String:Any],completion:@escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: nil)
        ServiceManager.execute(method: methodType, path: path, param: params, header: header, isJsonType: true, completion: completion)
    }
    class func callAPIToUploadMultipleImagesForOCRPDFOption(dataArr: [Data],flowVia:FlowVia, completion:@escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: false, isDeviceToken: true, extraDic: nil)

        var params = [String:Any]()
        params["parseResume"] = CommonClass.enableResumeParse
        params["fileToUpload"] = dataArr

        ServiceManager.requestForMultiPartData(path:APIPath.uploadResumeForImagesParser , params: params, fileExtension: "png", headers: header, completion: completion, fileName: "")
        
    }
    
    class func callAPIForRegionBasedLocation(groupName:String,funcType:String,methodType:ServiceMethod,limit:String,completion:@escaping ServiceCompletion) {
        
        let aPath = APIPath.masterListingApi + funcType + "&limit=\(limit)" + "&groupName=\(groupName)"
        
        ServiceManager.execute(method: .get, path: aPath, param: nil, header: nil, completion: completion)

    }
    class func callAPIForUpdateWorkExperience(methodType:ServiceMethod,path:String,params:[String:Any],customHeaderParams:[String:String],completion:@escaping ServiceCompletion) {
        
        if !MIReachability.isConnectedToNetwork() {
            //No internet check
            completion(false,nil,ServiceError.noInternetConnection,503)
            return
        }
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: customHeaderParams)
        
        ServiceManager.execute(method: methodType, path: path, param: params, header: header, completion: completion)
    }
}


//MARK:- Anupam
//MARK:-
enum SplashMasterDataType: String {
    case COUNTRY
    case CURRENCY
}

extension MIApiManager {
    
    class func splashAPI(_ completion: @escaping CompletionHandler<SplashModel>) {

        var header = [
            "x-device"                : "iOS",
            "x-device-id"             : UIDevice.current.identifierForVendor!.uuidString ,
            "Content-Type"            : "application/json",
            "x-product"               : "seeker"
        ]
        
        if let authUser = AppDelegate.instance.authInfo, !authUser.accessToken.isEmpty {
            header["Authorization"] = [authUser.tokenType.capitalized, authUser.accessToken].joined(separator: " ")
        }

        ServiceManager.executeAPI(.get, path: APIPath.splashAPI, param: nil, header: header) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
         
            let newJSONDecoder = JSONDecoder()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(SplashModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
    }
    
    class func splashMasterDataAPI(_ type: SplashMasterDataType, completion: @escaping CompletionHandler<SplashCountryCurrencyModel>) {

        var header = [
            "x-device"                : "iOS",
            "x-device-id"             : UIDevice.current.identifierForVendor!.uuidString ,
            "Content-Type"            : "application/json",
            "x-product"               : "seeker"
        ]

        if let authUser = AppDelegate.instance.authInfo, !authUser.accessToken.isEmpty {
            header["Authorization"] = [authUser.tokenType.capitalized, authUser.accessToken].joined(separator: " ")
        }

        let splashURL = APIPath.splashMasterAPI + type.rawValue
        ServiceManager.executeAPI(.get, path: splashURL, param: nil, header: header) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
         
            let newJSONDecoder = JSONDecoder()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(SplashCountryCurrencyModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
    }

    
    class  func loginAPI(_ param: inout [String: String], completion: @escaping CompletionHandler<LoginAuth>) {

        var header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: false, isDeviceToken: true, extraDic: nil)
        header?["Authorization"] = kLoginAuthKey

        
        param["grant_type"] = "password"
        param["scope"]      = "all"
        
        ServiceManager.executeAPI(.post, path: APIPath.loginApi, param: param, header: header) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            // let df = DateFormatter()
            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(LoginAuth.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(LoginErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                completion(nil,  NSError(domain: errorValue.error_description,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.error_description]))
            }
        }
    }
    
    class  func appleLoginRefreshTokenAPI(_ socialAccessToken: String, completion: @escaping CompletionHandler<AppleRefreshToken>) {

        var header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: false, isDeviceToken: true, extraDic: nil)
        header?["Authorization"] = kLoginAuthKey
                
        let url = APIPath.appleRefreshTokenAPI + "?socialProvider=apple&socialAccessToken=" + socialAccessToken
        
        ServiceManager.executeSocialAPI(.get, path: url, param: [:], header: header) { (data, error, code) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            // let df = DateFormatter()
            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(AppleRefreshToken.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(LoginErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                completion(nil,  NSError(domain: errorValue.error_description,
                                         code: code ?? 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.error_description]))
            }
        }
        
    }

    
    class  func socialLoginAPI(_ param: inout [String: String], completion: @escaping CompletionHandler<LoginAuth>) {

        
        var header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: false, isDeviceToken: true, extraDic: nil)
        header?["Authorization"] = kLoginAuthKey
        
        param["grant_type"] = "password"
        param["scope"]      = "all"
        
        
        ServiceManager.executeSocialAPI(.post, path: APIPath.loginApi, param: param, header: header) { (data, error, code) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            // let df = DateFormatter()
            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(LoginAuth.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(LoginErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                completion(nil,  NSError(domain: errorValue.error_description,
                                         code: code ?? 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.error_description]))
            }
        }
        
    }
    
    class  func sendOTP(_ userName: String, completion: @escaping CompletionHandler<OTPModel>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        
        let param = [ "username" : userName ]
        
        ServiceManager.executeAPI(.post, path: APIPath.sendOTP, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            // let df = DateFormatter()
            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(OTPModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
    }
    
    class  func updateProject(_ method: ServiceMethod, param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        

        
        ServiceManager.executeAPI(method, path: APIPath.userProjects, param: [param], header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            // let df = DateFormatter()
            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class func deleteProject(_ method: ServiceMethod, param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        

        
        
        ServiceManager.executeAPI(method, path: APIPath.userProjects, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            // let df = DateFormatter()
            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
        
    }
    
    class func deleteEducationDetails(_ method: ServiceMethod, param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(method, path: APIPath.deleteEducationDetails, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            // let df = DateFormatter()
            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class func deleteEmploymentDetails(_ method: ServiceMethod, param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {

        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(method, path: APIPath.deleteEmploymentDetails, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            // let df = DateFormatter()
            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
        
        
    }
    
    class  func updateSkill(_ method: ServiceMethod, param: JSONDICT, completion: @escaping ServiceCompletion) {

        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeArrayObject(method: method, path: APIPath.postITSkill, param: [param], header: header, isJsonType: true, completion: completion)
        
      //  ServiceManager.execute(method: method, path: APIPath.postITSkill, param: [param], header: header, completion: completion)
        
        
//        ServiceManager.executeAPI(method, path: APIPath.postITSkill, param: [param], header: header, isJsonType: true) { (data, error) in
//            guard let d = data else {
//                completion(nil, error)
//                return
//            }
//            let newJSONDecoder = JSONDecoder()
//            // let df = DateFormatter()
//            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
//            do {
//                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
//                completion(model, nil)
//            } catch let err {
//                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
//                    print("Error:- \n \(err)")
//                    completion(nil, err)
//                    return
//                }
//                AKAlertController.alert("Alert", message: errorValue.errorMessage)
//                completion(nil,  NSError(domain: errorValue.errorMessage,
//                                         code: 400,
//                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
//            }
//        }
        
    }
    
    class  func deleteSkill(_ param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.delete, path: APIPath.skillAddUpdateDeleteAPIEndpoint, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            // let df = DateFormatter()
            // df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // newJSONDecoder.dateDecodingStrategy = .formatted(df)
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class  func deleteCourseNCertification(_ param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.delete, path: APIPath.coursesCertification, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class  func deleteAwards(_ param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.delete, path: APIPath.awardsAchivement, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class  func deleteITSkill(_ param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.delete, path: APIPath.postITSkill, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class  func deleteOnlinePresence(_ param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.delete, path: APIPath.deleteOnlinePresence, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
    }

    class  func deleteProfileLanguage(_ param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        let aPath = APIPath.languageCreateProfileApi
        
        ServiceManager.executeAPI(.delete, path: aPath, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
    }
    
    class  func linkSocial(_ param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {
        
//        let token = [AppDelegate.instance.authInfo.tokenType.capitalized, AppDelegate.instance.authInfo.accessToken].joined(separator: " ")
//
//        let site = AppDelegate.instance.site
//        let sourceCountry = site?.defaultCountryDetails.isoCode ?? ""
//        let siteContext = site?.context ?? ""
//
//        let header = [
//            "Authorization"           : token,
//            "x-source-site-context"   : siteContext,
//            "x-source-country"        : sourceCountry,
//            "x-device"                : "ios",
//            "x-device-id"             : UIDevice.current.identifierForVendor!.uuidString ,
//            "Content-Type"            : "application/json",
//            "x-product"               : "seeker"
//        ]
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.put, path: APIPath.linkSocial, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class  func unlinkSocial(_ param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {
        
//        let token = [AppDelegate.instance.authInfo.tokenType.capitalized, AppDelegate.instance.authInfo.accessToken].joined(separator: " ")
//
//        let site = AppDelegate.instance.site
//        let sourceCountry = site?.defaultCountryDetails.isoCode ?? ""
//        let siteContext = site?.context ?? ""
//
//        let header = [
//            "Authorization"           : token,
//            "x-source-site-context"   : siteContext,
//            "x-source-country"        : sourceCountry,
//            "x-device"                : "ios",
//            "x-device-id"             : UIDevice.current.identifierForVendor!.uuidString ,
//            "Content-Type"            : "application/json",
//            "x-product"               : "seeker"
//        ]
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.put, path: APIPath.unlinkSocial, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class  func jobFeedbackAPI(_ param: JSONDICT, completion: @escaping CompletionHandler<SuccessModel>) {
        
//        let token = [AppDelegate.instance.authInfo.tokenType.capitalized, AppDelegate.instance.authInfo.accessToken].joined(separator: " ")
//
//        let site = AppDelegate.instance.site
//        let sourceCountry = site?.defaultCountryDetails.isoCode ?? ""
//        let siteContext = site?.context ?? ""
//
//        let header = [
//            "Authorization"           : token,
//            "x-source-site-context"   : siteContext,
//            "x-source-country"        : sourceCountry,
//            "x-device"                : "ios",
//            "x-device-id"             : UIDevice.current.identifierForVendor!.uuidString ,
//            "Content-Type"            : "application/json",
//            "x-product"               : "seeker"
//        ]
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.post, path: APIPath.jobFeedback, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(SuccessModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class  func voiceSearchAPI(_ str: String, completion: @escaping CompletionHandler<VoiceModel>) {
        
//        let token = [AppDelegate.instance.authInfo.tokenType.capitalized, AppDelegate.instance.authInfo.accessToken].joined(separator: " ")
//
//        let site = AppDelegate.instance.site
//        let sourceCountry = site?.defaultCountryDetails.isoCode ?? ""
//        let siteContext = site?.context ?? ""
//
//        let header = [
//            "Authorization"           : token,
//            "x-source-site-context"   : siteContext,
//            "x-language-code"         : "en",
//            "x-source-country"        : sourceCountry,
//            "x-device"                : "ios",
//            "x-device-id"             : UIDevice.current.identifierForVendor!.uuidString ,
//            "Content-Type"            : "application/json",
//            "x-product"               : "seeker"
//        ]
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)

        let param = ["data" : str.lowercased()]
        
        ServiceManager.executeAPI(.post, path: APIPath.voiceSearchAPI, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(VoiceSearchModel.self, from: d)
                completion(model.data, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class func profileEngagementAPI(_ completion: @escaping CompletionHandler<EngagementCards>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
//        header?["Content-Type"] = "application/x-www-form-urlencoded"

        let param = [
            "sourceTraffic" : UserEngagementConstant.instance.sourceTraffic,
            "sourcePage"    : UserEngagementConstant.instance.sourcePage
        ]
        
      ServiceManager.executeAPI(.post, path: APIPath.profileEngagementURL, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(EngagementCards.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
               // AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
       // return task
    }
    
    class  func validiateEmail(_ email: String, completion: @escaping CompletionHandler<ValidationModel>) {
        
        let param = [ "email": email ]
        let header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.post, path: APIPath.validiateEmail, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(ValidationModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }
    
    class  func validiateMobile(_ param: JSONDICT, completion: @escaping CompletionHandler<ValidationModel>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: false, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.executeAPI(.post, path: APIPath.validiateMobile, param: param, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(ValidationModel.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }

    class  func seekerABTestingAPI(_ param: JSONDICT, completion: @escaping CompletionHandler<ABTestingEvent>) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: nil)
        var parameter = param
        parameter["siteContext"] = AppDelegate.instance.site?.context as Any
        parameter["tenant"]      = "iOS"
        parameter["userAgent"]   = UIDevice.modelName
        parameter["stateFlag"]                 = "L"
        
        if !CommonClass.isLoggedin() {
            parameter["uuid"] = URLRequest.HTTPHeaderVal.xdeviceidVal
            parameter["stateFlag"]                 = "NL"
        }
        
//        let p = [
//            "events" : parameter
//        ]

        ServiceManager.executeAPI(.post, path: APIPath.abTestingAPI, param: parameter, header: header, isJsonType: true) { (data, error) in
            guard let d = data else {
                completion(nil, error)
                return
            }
            let newJSONDecoder = JSONDecoder()
            do {
                let model = try newJSONDecoder.decode(ABTestingEvent.self, from: d)
                completion(model, nil)
            } catch let err {
                guard let errorValue = try? newJSONDecoder.decode(ErrorModel.self, from: d) else {
                    print("Error:- \n \(err)")
                    completion(nil, err)
                    return
                }
                //AKAlertController.alert("Alert", message: errorValue.errorMessage)
                completion(nil,  NSError(domain: errorValue.errorMessage,
                                         code: 400,
                                         userInfo: [NSLocalizedDescriptionKey: errorValue.errorMessage]))
            }
        }
        
    }

}


//Anushka
extension MIApiManager {
    
    class func hitBlockCompaniesAPI(_ companyName: JSONARR, completion: @escaping ServiceCompletion) {
        
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        let param =
            [
                "companies" : companyName
        ]
        
        ServiceManager.execute(method: .post, path:APIPath.blockCompanies, param: param, header: header, isJsonType: true, completion: completion)
        
        
    }
    
    class func hitUnblockCompanyAPI(_ id: String, completion: @escaping ServiceCompletion) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        let param = [
            "company" : [
                "id" : id
            ]
        ]
        
        ServiceManager.execute(method: .delete, path: APIPath.unblockCompany, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    
    class func hitGetBlockCompanyAPi(_ completion: @escaping ServiceCompletion) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .get, path: APIPath.getBlockCompany, param: nil, header: header, isJsonType: true, completion: completion)
    }
    
    
    class func hitDeativateUserAPI(_ completion: @escaping ServiceCompletion) {
        
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .put, path:APIPath.deactivateUser, param: nil, header: header, isJsonType: true, completion: completion)
        
        
        
    }
    
    class func hitDeleteAccountAPI(_ reason: String, completion: @escaping ServiceCompletion) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        let param = [
            "reason" : reason
        ]
        
        ServiceManager.execute(method: .put, path:APIPath.deleteProfile, param: param, header: header, isJsonType: true, completion: completion)
    }
    
    class func hitProfileVisibiltyAPI(_ visibilty: Bool, completion: @escaping ServiceCompletion) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        let param = [
                "visibility"  : visibilty
          ]
        
        ServiceManager.execute(method: .put, path:APIPath.profileVisibilty, param: param, header: header, isJsonType: true, completion: completion)
    }
    
    class func hitEmailPreferencesAPI(_ recommendedJobs: Bool, jobAlert: Bool, applicationStatus: Bool, profileViews: Bool, improveProfileStrength:Bool, recruiterCommunications: Bool, promotionsAndSpecialOffers: Bool, careerAdviceAndTips: Bool, completion: @escaping ServiceCompletion ) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        let param = [
            "jobNotification"               : [
                "recommendedJobs"   : recommendedJobs,
                "jobAlert"          : jobAlert,
                "applicationStatus" : applicationStatus
            ],
            "profileRelatedNotification"    : [
                "profileViews"           : profileViews,
                "improveProfileStrength" : improveProfileStrength
            ],
            //"recruiterCommunications"       : recruiterCommunications,
            "promotionsAndSpecialOffers"    : promotionsAndSpecialOffers,
            "careerAdviceAndTips"           : careerAdviceAndTips
            ] as [String : Any]
        
        ServiceManager.execute(method: .put, path: APIPath.emailPreferences, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitGetEmailPreferencesAPI(_ completion: @escaping ServiceCompletion ) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .get, path: APIPath.emailPreferences, param: nil, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitChangePassword(_ oldPasswd: String, newPasswd: String, confirmPasswd: String, completion: @escaping ServiceCompletion){

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        let param = [
            "oldPassword"     : oldPasswd,
            "newPassword"     : newPasswd,
            "confirmPassword" : confirmPasswd
        ]
        
        ServiceManager.execute(method: .put, path: APIPath.changePassword, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    
    class func hitReportBug(_ category: String, name: String, email: String, mobileNumber: String, details: String, rating: Int? = nil, tags: [String]? = nil, completion: @escaping ServiceCompletion) {
        
        
        let site = AppDelegate.instance.site

        let sourceCountry = site?.defaultCountryDetails.callPrefix.stringValue ?? "91"


        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        var param = [
            "category"    : category,
            "name"        : name,
            "email"       : email,
            "mobile"      : [
                "countryCode"  : sourceCountry,
                "mobileNumber" : mobileNumber
            ],
            "details"      : details,
            "uuid"         : UIDevice.current.identifierForVendor!.uuidString,
            "sessionId"    : ""
            ] as [String : Any]
        if let r = rating {
            param["rating"] = r
        }
        if let t = tags {
            param["feedbackTags"] = t
        }
        
        ServiceManager.execute(method: .post, path: APIPath.reportBug, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitGetJobSearchStageAPI(_ completion: @escaping ServiceCompletion) {
        
        let token = [AppDelegate.instance.authInfo.tokenType.capitalized, AppDelegate.instance.authInfo.accessToken].joined(separator: " ")
        
        let header = [
            "Authorization"   : token,
            "Content-Type"    : "application/json",
            ]
        
        ServiceManager.execute(method: .get, path: APIPath.getJobSearchStage, param: nil, header: header, isJsonType: true, completion: completion)
    }
    
    class func hitGetJobSearchStageStatusAPI(_ completion: @escaping ServiceCompletion) {
        
        let token = [AppDelegate.instance.authInfo.tokenType.capitalized, AppDelegate.instance.authInfo.accessToken].joined(separator: " ")
        
        let header = [
            "Authorization"   : token,
            "Content-Type"    : "application/json",
            ]
        
        ServiceManager.execute(method: .get, path: APIPath.jobSearchStage, param: nil, header: header, isJsonType: true, completion: completion)
    }
    
    class func hitJobSearchStageAPI(_ jobSearchStage: String, completion: @escaping ServiceCompletion) {
        
        let token = [AppDelegate.instance.authInfo.tokenType.capitalized, AppDelegate.instance.authInfo.accessToken].joined(separator: " ")
        
        let header = [
            "Authorization"   : token,
            "Content-Type"    : "application/json",
            ]
        let param = [ "jobSearchStage"  : jobSearchStage ]
        
        ServiceManager.execute(method: .put, path: APIPath.jobSearchStage, param: param, header: header, isJsonType: true, completion: completion)
    }
    
    
    class func hitOnLinePresenceAPI(_ method:  ServiceMethod, id: String, name: String, url: String, description: String, completion: @escaping ServiceCompletion) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        var param = [
            "name"        : name,
            "url"         : url,
            "id"          : id
        ]
        if !description.isEmpty {
            param["description"] = description
        }
        
        ServiceManager.executeArrayObject(method: method, path: APIPath.onlinePresence, param: [param], header: header, isJsonType: true, completion: completion)
    }
    
    
    class func hitAwardAchievementAPI(_ method:  ServiceMethod, id: String, title: String, date: String, description: String, completion: @escaping ServiceCompletion) {
        
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        let param = [[
            "title"       : title,
            "date"        : date,
            "description" : description,
            "id"          : id
            ]]
        
        ServiceManager.executeArrayObject(method: method, path: APIPath.awardsAchivement, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    
    class func hitCoursesCertificationAPI(_ method:  ServiceMethod, id: String, name: String, lastUsed:String?,  issuer: String, completion: @escaping ServiceCompletion) {
        

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        let param = [[
            "name"        : name,
            "issuer"      : issuer,
            "expiryDate"  : lastUsed ?? "",
            "id"          : id
            ]]
        
        ServiceManager.executeArrayObject(method: method, path: APIPath.coursesCertification, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitManageActiveProfile(_ id: Int, completion: @escaping ServiceCompletion) {

        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .put, path: APIPath.manageActiveProfile + "\(id)" + "/activate", param: nil, header: header, isJsonType: true, completion: completion)
        
    }
    

    
    class func hitManageDeleteProfile(_ id: Int, completion: @escaping ServiceCompletion) {

        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        let param = [ "id"  : "\(id)" ]
        
        ServiceManager.execute(method: .delete, path: APIPath.manageDeleteProfile, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitRecruiterActionAPI(_ path: String, completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .get, path: path, param: nil, header: header, isJsonType: true, completion: completion)
    }
    
    class func hitRemindMeLaterApi(_ type: String, userActions: String, headerDict: [String: String], completion: @escaping ServiceCompletion) {
  
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: headerDict)
        
        let param = [
            "type"           : type,
            "userActions"    : userActions
        ]
        
        ServiceManager.execute(method: .post, path: APIPath.skipCards, param: param, header: header, isJsonType: true, completion: completion)
    }
    
    class func getSesssionIDAPI() {
        let header =  MIUtils.shared.apiHeaderWith(isToken: false, isContentType: true, isDeviceToken: true, extraDic: nil)

            guard let request = ServiceMethod.post.requestWith(path: APIPath.getSessionIdEndPoint, param: nil, headers: header, isJsonType: true) else {  
                return
            }
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = (response as? HTTPURLResponse) {
                    if (response.statusCode >= 200) && (response.statusCode <= 299)    {
                        if let sessionID = response.allHeaderFields["sessionid"] as? String {
                            sessionId = sessionID
                           
                        }
                    }else{
                       
                    }
                }
                
            }.resume()


    }
    
    class func hitTrackingEventsApi(_ attribute: String, updated: Int, remindMeLater: Int, oldValue: JSONDICT, newValue: JSONDICT, timeSpent: Int, headerDict: [String: String]? = nil,cardRule:Card? ,completion: @escaping ServiceCompletion)
    {
        let header =  MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: headerDict)

        let payloads = [
            "currentURL"      : UserEngagementConstant.instance.sourcePage, //pageNAme
            "attribute"       : attribute,
           
            "platform"        : "iOS",
            "siteContext"     : AppDelegate.instance.site?.context ?? "",
            "referralSource"  : UserEngagementConstant.instance.sourceTraffic,
            "accessToken"     : AppDelegate.instance.authInfo.accessToken,
           
            "fullName"        : AppDelegate.instance.userInfo.fullName,
            "countryCode"     : AppDelegate.instance.userInfo.countryCode,
            "mobile"          : AppDelegate.instance.userInfo.mobileNumber,
            "email"           : AppDelegate.instance.userInfo.primaryEmail,
            "nationality"     : AppDelegate.instance.userInfo.country,
            
            
            "updated"         : updated,
            "remindMeLater"   : remindMeLater,
            "oldData"         : oldValue,
            "newData"         : newValue,
            "timeSpent"       : timeSpent,
            "splSource"       : UserEngagementConstant.instance.spl 
            
            ] as [String : Any]
        
        let apiHeader = [
            "x-Source-Country"      : AppDelegate.instance.site?.defaultCountryDetails.isoCode ?? "",
            "x-Language-Code"       : "en",
            "x-Source-Site-Context" : AppDelegate.instance.site?.context ?? "",
            "x-rule-applied"        : cardRule?.ruleApplied ?? "",
            "x-rule-version"        : cardRule?.ruleVersion ?? ""
            ] as [String : Any]
        
        let events = [[
            "splAction"  : "USER_ENGAGEMENT",
            "payload"    : payloads as [String : Any],
            "apiHeaders" : apiHeader
        ]] as [[String : Any]]
        
        let param = [
            "events" : events
        ]
        
        ServiceManager.execute(method: .post, path: APIPath.trackingEvents, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    
    
    class func  hitSeekerJourneyMapEvents(_ actionType: String, data: [String: Any], source: String="", destination: String, completion: @escaping ServiceCompletion ) {
        
      
        let header =  MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        var param = [String:Any]()
        
        param["type"]                 = actionType
        param["sessionId"]            = sessionId
        
        let site                      = AppDelegate.instance.site
        param["siteContext"]          = site?.context
        param["referralUrl"]          = JobSeekerSingleton.sharedInstance.getLastScreenName()
        param["tenant"]               = "iOS"
        param["userAgent"]            = UIDevice.modelName
        
        param["accessedUrl"]          = destination
        param["data"]                 = data
        
        param["stateFlag"]            = "L"

        if !CommonClass.isLoggedin() {
            param["uuid"]          = UIDevice.current.identifierForVendor!.uuidString
            param["stateFlag"]     = "NL"
        }
        
        let events = [
            "events" : [param]
        ] as [String: Any]
        
        if CommonClass.isTracking {
            ServiceManager.execute(method: .post, path: APIPath.seekerMapEvents, param: events, header: header, isJsonType: true, completion: completion)
        }
        
    }

    class func callAPIForFieldLevelUpdateTracking(fields:[String],completion: @escaping ServiceCompletion) {
        let header =  MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        var param = [String:Any]()
        
        param["fieldNames"] = fields
        param["profileId"] = UserDefaults.standard.integer(forKey: "profileId")
        let site                      = AppDelegate.instance.site
        param["siteContext"]          = site?.context
        param["tenant"] = "iOS"

        ServiceManager.execute(method: .post, path: APIPath.fieldLevelTrackingEndPoint, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitCovidFlagAPI(_ method:  ServiceMethod, covidFlag: Bool, completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        var param = [String: Any]()
        if method == .put {
            param["covidLayoff"] = covidFlag
        }
        
         ServiceManager.execute(method: method, path: APIPath.covidFlag, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitGleacCandidateAPI(_  completion: @escaping ServiceCompletion) {
        
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        var param = [String: Any]()
        param["firstname"] = AppDelegate.instance.userInfo.fullName
        param["lastname"] = ""//AppDelegate.instance.userInfo.fullName
        param["email"] = AppDelegate.instance.userInfo.primaryEmail
        
        ServiceManager.execute(method: .post, path: APIPath.gleacCandidateID, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitGleacInstructionAPI(_  id: String, completion: @escaping ServiceCompletion) {
        
        let path = APIPath.gleacInstruction + id
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .get, path: path, param: nil, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitGleacMarkReporttAPI(_ completion: @escaping ServiceCompletion) {
       
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .get, path: APIPath.gleacMarkReport, param: nil, header: header, isJsonType: true, completion: completion)
        
    }
        
    class func hitGleacSkillsResultAPI(_ completion: @escaping ServiceCompletion) {
       
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .get, path: APIPath.gleacSkillResult, param: nil, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitGleacSkillMapEventsAPI(_ pageType: String, accessedUrl: String, data: [String: Any], completion: @escaping ServiceCompletion) {
        
         let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
//            let date = Date()
//            let timeStamp = date.currentTimeMillis()
        
            var param = [String:Any]()
            
            param["accessedUrl"]          = accessedUrl
            //param["currentTimestamp"]     = timeStamp
         
            param["pageType"]             = pageType
            param["referralUrl"]          = JobSeekerSingleton.sharedInstance.getLastScreenName()
            param["sessionId"]            = sessionId
            
            let site                      = AppDelegate.instance.site
            param["siteContext"]          = site?.context
            param["tenant"]               = "iOS"
            param["userAgent"]            = UIDevice.modelName
            
            param = param.merge(dict: data)
                
           ServiceManager.execute(method: .post, path: APIPath.gleacSkillMapEvents, param: param, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func hitCompanyDetailsAPI(_ compID: String, completion: @escaping ServiceCompletion) {
        
        let path = APIPath.companyDetails + compID
       
        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil)
        
        ServiceManager.execute(method: .get, path: path, param: nil, header: header, isJsonType: true, completion: completion)
        
    }
    
    class func getOldSystemCookiesData() {
        MICookieHelper.clearCustomCookies()
      //  let header =  MIUtils.shared.apiHeaderWith(isToken: false, isContentType: true, isDeviceToken: true, extraDic: nil)

        let path = "https://my\(AppDelegate.instance.site?.domain.replacingOccurrences(of: "www", with: "") ?? ".monsterindia.com")" + APIPath.rioAutoLoginOldSystemEndpoint + MICookieHelper.getMSSOATCookieValue()
        
        guard let url = URL(string: path) else{
            return
        }
      
        var request = URLRequest(url: url)
      //  request.addValue("MSSOAT=\(MICookieHelper.getMSSOATCookieValue()); MSSOCLIENT=\(UUID().uuidString)", forHTTPHeaderField: "Cookie")

        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
                            
            
            if let response = (response as? HTTPURLResponse) {
                                   if (response.statusCode >= 200) && (response.statusCode <= 299)    {
                                    guard let url = URL(string: path),let header = response.allHeaderFields as? [String:String] else{
                                              return
                                          }
                                     let cookiesFromOldSystem =  HTTPCookie.cookies(withResponseHeaderFields: header, for: url)
                                    for ck in cookiesFromOldSystem {
                            //            print(ck.name)
                                        HTTPCookieStorage.shared.setCookie(ck)
                                    }
        
                                   }else{
        
                                   }
                               }
        
                           }.resume()

//                   guard let request = ServiceMethod.post.requestWith(path: path, param: nil, headers: header, isJsonType: true) else {
//                       return
//                   }
//
//                   URLSession.shared.dataTask(with: request) { (data, response, error) in
//                       if let response = (response as? HTTPURLResponse) {
//                           if (response.statusCode >= 200) && (response.statusCode <= 299)    {
//                            guard let url = URL(string: path),let header = response.allHeaderFields as? [String:String] else{
//                                      return
//                                  }
//                             let cookiesFromOldSystem =  HTTPCookie.cookies(withResponseHeaderFields: header, for: url)
//                            for ck in cookiesFromOldSystem {
//                              //  print(ck)
//                                HTTPCookieStorage.shared.setCookie(ck)
//                            }
//
//                           }else{
//
//                           }
//                       }
//
//                   }.resume()
        
        
    }
    
}


