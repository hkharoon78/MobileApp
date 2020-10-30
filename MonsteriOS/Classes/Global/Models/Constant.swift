//
//  Constant.swift
//  MonsteriOS
//
//  Created by Monster on 16/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit


var apiMode: APIMode = .Production


//{
//    get {
//        let value = AppUserDefaults.value(forKey: .APIModeSelection, fallBackValue: "Production").stringValue
//        return APIMode(rawValue: value) ?? .Production
//    }
//    set {
//        AppUserDefaults.save(value: newValue.rawValue, forKey: .APIModeSelection)
//    }
//}

enum APIMode: String {
    case RFS = "RFS"
    case Production = "Production"
    case QA = "QA"
    case LOCAL = "LOCAL"

}

var kBaseUrl: String {
    
    switch apiMode {
        case .RFS:
            return "https://rfs.monsterindia.com"
        case .Production:
            return "https://apiv2.monsterindia.com"
        case .QA:
            return "https://qa1.monsterindia.com"
        case .LOCAL:
            return "http://10.216.168.200:8080"
    }
}



let kBaseUrlRex    = "rexmonster"
let kBaseUrlLang   = "en"
let kImgBaseUrl    = "https://media.monsterindia.com/trex/prod-cdn/media/" //"http://rexadmin-qa1.monsterlocal.com/storage/media/"
let kAppDelegate   = UIApplication.shared.delegate as! AppDelegate
let userDefaults   = UserDefaults.standard
let kScreenSize    = UIScreen.main.bounds
let kIsiPhone5s    = kScreenSize.height == 568
let kIsiPhone6Plus = kScreenSize.height == 736.0
let kIsiPhoneXS    = kScreenSize.height == 812.0
let kIsiPhoneXSMax = kScreenSize.height == 896.0
let Loader         = MILoader.shared
let kActivityIndicator  = MIActivityIndicator()
let kActivityView  = kActivityIndicator.activityIndicator

let kauthorizationOrgKey    = "2f91ca50-939d-4944-8569-36f999c87f1e:oSBVKh3borjwfwba7HyNDuuCSDKdE52oXukwFx3kNkyOcoHYAgt3O578U43SvFxi"
let base64AuthorizationKey  = kauthorizationOrgKey.data(using: String.Encoding.utf8)?.base64EncodedString()

let kLoginAuthKey  = "Basic MmY5MWNhNTAtOTM5ZC00OTQ0LTg1NjktMzZmOTk5Yzg3ZjFlOm9TQlZLaDNib3Jqd2Z3YmE3SHlORHV1Q1NES2RFNTJvWHVrd0Z4M2tOa3lPY29IWUFndDNPNTc4VTQzU3ZGeGk="

let kdummyAccess  = "Basic eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTM4NTI0MTQsInV1aWQiOiIxYmI2OTU1Mi00YjRiLTQwMDUtYmE3My00ZTkzMzM4YTMxNDEiLCJ1c2VyX25hbWUiOiJhYjVjaTJsbEBzc3NhYmMuY29tIiwianRpIjoiYWQ5YmQ1OWItYTAzZi00Y2EyLWEwZDYtMWM1MTBjNjU1NDAxIiwiY2xpZW50X2lkIjoiZmQxMTFhZjItNDkzZC0xMWU4LTk2MjEtMjRhMDc0ZjA2NDUwIiwic2NvcGUiOlsiYWxsIl19.Kqub0E8OOF4qPLcsodhDPKQyBDR9dNkJOwa25J8bHd9WvXypkNVMkIJFSPAxRX6_9Li3bOzsjxyyZQpN49RBeu1XJyWVzdmuw_DR9qB877kZgh15-u25fws0qV3zB3bEyCZoO5dXdJJWxgc51sth9Pp3gHMSEEkI7miUSH3RJ9QGM6Iy1PQT2LSbQlKxGPJTyFn6RcGSwIuRchoWFIqwl6K6dD3PqKdun_d45hTYr_GAys7TzwPcAKfT_P9CtSatz3SF3edKNRUTdqXm8lMbloBQytFtHRfi93rmt6L6-sGQ1fy7BTJZIDCiZe_jsXYquMS8A_G9NHTONSVEPM4xQCwanSFcOS1HRy5k3yfNuYHAdNnZ8Fk_cHeX6VSRq4DgCaL31o8PLDzxv9cHDwhtdZqSaAzX8wlIk9_UHz4nRALFUl6-iMmmS3gZZ3Yc7wiCFpUmnNFysyv8vyvzdxXuWXqsnBYfmBlKBaubKgYvPqHIDnzStsZQtVHPhW-uK9hOhbDyX35ktRPnSBAAf2VECYQC_gClmpJ4QMTUA7QMMrcz2lQUoGUdMcTLIKHQdSlEoqx5b1PkIABA4gN83On-zdqv1wiXWzLo5gY3D-jiHb5HghZGaCl4srEXzTNkNx4LIkCvvVvKWfAy0iQqnkcThHTRPchOgqNaOfQ8zTVj5MY"

//CLASS12 = "b521765c-b4b2-4b92-8f8f-7862a5e0f315"
let kCLASS10 = "ef02168e-7718-11e9-97c3-000c29344ed7"
let kClass12Id = "b521765c-b4b2-4b92-8f8f-7862a5e0f315"

let kHighSchool = "ef662c4e-8eb8-4925-aa70-f7786d069384"
let kIndianNationalityUUID = "20601099-fc81-11e8-92d8-000c290b6677"
let kmonthlyModeSalaryUUID = "69a8f26e-222e-11e9-9330-1418775c7275"
let kannuallyModeSalaryUUID = "7cad9bf9-222e-11e9-9330-1418775c7275"
let kSpeciallyAbleTypeIsPhysicalUUID = "7b2486a2-fc74-11e8-92d8-000c290b6677"

//let kHighestQualificationOtherUUID = "d1f770d0-7701-4b97-9dfc-8963caf12bad"
//let kSpecilisationOtherUUID = "0e5ff30c-c58c-4070-bd74-51541c41d5ca"
let kCollegeOtherUUID = "2efdca6a-7024-438f-8f47-33c2d6353f07"
let kGenderMaleUUID = "bd5a224c-fc69-11e8-92d8-000c290b6677"
let kGenderFemaleUUID = "ccc7faa0-fc69-11e8-92d8-000c290b6677"
let kGenderOtherUUID = "c7f21630-2480-11e9-aabd-70106fbef856"


let kGmailClientId          = "591528984509-bm6cp3at5q1nfi0kkahs0eq9nqamd2iv.apps.googleusercontent.com"
let kMOBILE_NUMBER_EXISTS   = "MOBILE_NUMBER_EXISTS"
let kEMAIL_ID_EXISTS   = "EMAIL_OR_MOBILE_EXISTS"
let kDONT_HAVE_WORK_AUTHORIZATION   = "I don't have Work Authorization"



//MARK: - New Relic Application Token
//If you change it here please do the same in run script
let kNewRelicApplicationToken = "AA55e7831d47da2315c5196d22a7e630ac6155afdc-NRMA"

//MARK: - Dev Google Analytics
//let googleAnalyticsTrackingId = "UA-126739682-1"

//MARK: - Production Google Analytics
let googleAnalyticsTrackingId = "UA-83047176-1"


//==== BASE ====
extension Data {
    func mimeType() -> String {
        
        var b: UInt8 = 0
        self.copyBytes(to: &b, count: 1)
        
        switch b {
        case 0xFF:
            return "jpg"
        case 0x89:
            return "png"
        case 0x47:
            return "gif"
        case 0x4D, 0x49:
            return "tiff"
        case 0x25, 0x37:
            return "pdf"
        case 0xD0, 0x80:
            return "doc"
        case 123:
            return "rtf"
//        case 0xD0:
//            return "vnd"
        case 0x46:
            return "plain"
        default:
            return "docx"
        }
    }
}



