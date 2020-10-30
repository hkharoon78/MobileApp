//
//  MonsteriOSTests.swift
//  MonsteriOSTests
//
//  Created by Monster on 15/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import XCTest

@testable import MonsteriOS

class MonsteriOSTests: XCTestCase {
    var sut: URLSession!

    override func setUp() {
        super.setUp()
        sut = URLSession(configuration: .default)

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

 
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUpdateProfile() {

        
        let userModel = MIProfilePersonalDetailInfo(
                name: "Ravi",
                profilePic: "",
                email: "t7t@mailinator.com",
                countryCode: "91",
                country: "India",
                mobile: "826374243",
                mverifies: false,
                everifed: true,
                location: MICategorySelectionInfo(id: "2",
                                                  score: "",
                                                  uuid: "ew3c535453",
                                                  language: "en",
                                                  enabled: "",
                                                  orderBy: "",
                                                  name: "erergdf",
                                                  type: "",
                                                  kiwiId: "",
                                                  countryName: "",
                                                  countryISOCode: "",
                                                  parentUuid: ""),
                hometown: "Haldwani",
                title: "Exp for 5 years",
                site: "",
                uuid: "",
                visibility: false,
                userImg: UIImage(),
                otherUserData: MIAdditionalPersonalInfo(gender: "Male",
                                                        dob: "14/12/1991",
                                                        maritalStatus: "Unmarried",
                                                        pasport: "", permantAddress: "",
                                                        pincode: "26316",
                                                        differentAbled: "",
                                                        workexpyear: "5",
                                                        workexpmonth: "4",
                                                        cityName: "Haldwani",
                                                        salaryModal: SalaryDetail(salaryLakh: "5",
                                                                                  salaryThousnd: "4000",
                                                                                  salaryCurrency: "INR",
                                                                                  absoluteValue: 0, salaryModeAnually: true,
                                                                                  salaryMode: MICategorySelectionInfo(id: "2",
                                                                                                                      score: "",
                                                                                                                      uuid: "7cad9bf9-222e-11e9-9330-1418775c7275",
                                                                                                                      language: "en",
                                                                                                                      enabled: "",
                                                                                                                      orderBy: "",
                                                                                                                      name: "Annually",
                                                                                                                      type: "",
                                                                                                                      kiwiId: "",
                                                                                                                      countryName: "",
                                                                                                                      countryISOCode: "",
                                                                                                                      parentUuid: ""),
                                                                                  
                                                                                  confidential: true),
                                                        curentloca: MICategorySelectionInfo(id: "2",
                                                                                            score: "",
                                                                                            uuid: "f50176f3-a56f-4dc6-8eac-f85a5df10339",
                                                                                            language: "en",
                                                                                            enabled: "",
                                                                                            orderBy: "",
                                                                                            name: "Agra",
                                                                                            type: "",
                                                                                            kiwiId: "",
                                                                                            countryName: "",
                                                                                            countryISOCode: "",
                                                                                            parentUuid: "")
            ),
                rowdata: [],
                dict: [:],
                experlevel: "EXPERIENCED",
                countryCodeName: "",
                social: [],
                updateAt: "3453534534")

        
        self.testuserName(userModel: userModel)
    }

    func testuserName(userModel:MIProfilePersonalDetailInfo) {
        
        XCTAssertTrue(userModel.fullName.count > 0)
        XCTAssertTrue(userModel.fullName.isValidName)
        
        self.testUserLcoation(userModel: userModel)

    }
    func testUserLcoation(userModel:MIProfilePersonalDetailInfo) {
        XCTAssertFalse(userModel.additionPersonalInfo?.currentlocation.uuid.count ?? 0 <= 0 , "Free text not allowed.")
        XCTAssertTrue(userModel.additionPersonalInfo?.currentlocation.name.count ?? 0 > 0 )
        self.testEmailEmptyOrVerified(userModel: userModel)
    }
    func testEmailEmptyOrVerified(userModel:MIProfilePersonalDetailInfo) {
        XCTAssertFalse(userModel.primaryEmail.isEmpty, "Email can't be empty.")
        XCTAssertTrue(userModel.primaryEmail.isValidEmail, "Email is not in correct format.")
        XCTAssertTrue(userModel.emailVerifedStatus, "You have to verify your email to get best job alerts.")
        self.testMobileCodeAndNumber(userModel: userModel)
    }
    func testMobileCodeAndNumber(userModel:MIProfilePersonalDetailInfo) {
        XCTAssertFalse(userModel.countryCode.count == 0 , "Country code can't be empty")
        XCTAssertFalse(userModel.mobileNumber.count == 0, "Mobile number can't be empty")
        self.testUpdateProfileAPI(basicProfileInfo: userModel)
        
        
        
    }
    func testUpdateProfileAPI(basicProfileInfo:MIProfilePersonalDetailInfo) {
       
        AppDelegate.instance.authInfo.tokenType = "Bearer"
        AppDelegate.instance.authInfo.accessToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpbnRlcm5hbCI6ZmFsc2UsInVzZXJfbmFtZSI6IjFiYzY4NmI0LTNjZmEtNDZiMy1hYmEwLWZlNjc1ZTJjYjZiNSIsInNjb3BlIjpbImFsbCJdLCJleHAiOjE2MjA3OTcyNjYsInV1aWQiOiIxYmM2ODZiNC0zY2ZhLTQ2YjMtYWJhMC1mZTY3NWUyY2I2YjUiLCJhdXRob3JpdGllcyI6WyJST0xFX1NFRUtFUiJdLCJqdGkiOiJjNzE4MDJmMi0zNGUxLTRhM2YtYjFhOS04NjlhOTk5MmU4NmUiLCJjbGllbnRfaWQiOiIyZjkxY2E1MC05MzlkLTQ5NDQtODU2OS0zNmY5OTljODdmMWUifQ.I_XAU1XPG4KTXHO4LB8b4464033vvAudDiQFywqABcUD-Kvzu1bGG4tDIHiy_PU7p_mvIZs6edGC_Xh-ZXSKL9b2tg6agTMNo0Y-wqfqoeFDUHBwuPKKuBuM9NSXVm_ilNNWVuaeGbhdDZXI6_Vvh4IDI0rcSjW4YFflSvzJyuT3OwWs3CN-wTRrmX1oSTdJVcot5p_0V77iC8m1f221HNuC74aOFI9ZX-TLZ_55KNJZ026yrFqOViDKbJZ8EUE5SAqVKMfN9vdTx095RsrQoOU9k_EUzHaIxJ8XvXQfVmJ0YVJ6N-wnTzgrZoFnzkj8DG256TkFWBZRiqNSG3JUFlemTq8wn0TRTncnFTqGyDQghnOH8QNsTd-tlyJNtjEThYDJ3v5wOdrp8w1Uy1B6VtJYGcD76vPg63dEzbciZy6iyeYni5INDIq24lIYGEqLGrn4eXwXx3U785yfamNZxbBS2hmJcEm3lRnVsxht9YAIL5uhqI3LssEX_vbWgBRtLMBVWSAM9cAcFwVki6mhTgwjLgDRUTZUKe3emcbw0LsUVWqqjFntjFihWsz9PiAAB7xlfWkOJexiVrXZh5JQMWILMQBirvilxtz_9IxhiWMiIKn3qIs3bj7xRSr70NXa0bUh8_Cm-waJsrHzKCQTSZIf2hSYx_Pm5ajt2vK5nuw"

        let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: nil)

        let promise = expectation(description: "Success")
        let url =  URL(string: APIPath.personalDetailPUTAPIEndpoint)
        XCTAssertNotNil(url,"API Request Url can't be nil")
        let urlRequest = NSMutableURLRequest(url:url!)
      
        urlRequest.httpMethod = "PUT"
        XCTAssertNotNil(header, "Header can't be nil")
        if let h = header {
            for param in h {
                urlRequest.setValue(param.value, forHTTPHeaderField: param.key)
            }
        }
        
         var params = [String:Any]()
                
                params[APIKeys.fullNameAPIKey] = basicProfileInfo.fullName
                var mobileNumber = [String:Any]()
                mobileNumber[APIKeys.countryCodeAPIKey] = basicProfileInfo.countryCode.replacingOccurrences(of: "+", with: "")
                mobileNumber[APIKeys.mobileNumberAPIKey] = basicProfileInfo.mobileNumber
                params[APIKeys.experienceLevelAPIKey] = basicProfileInfo.expereienceLevel.uppercased()
                
                var additionalPersonalDetail = [String:Any]()
                additionalPersonalDetail[APIKeys.profileAPIKey] = basicProfileInfo.profileTitle
                additionalPersonalDetail[APIKeys.mobileNumberAPIKey] = mobileNumber
                if basicProfileInfo.additionPersonalInfo?.cityName.isEmpty ?? false {
                    additionalPersonalDetail[APIKeys.currentLocationAPIKey] = MIUserModel.getParamForIdText(id: (basicProfileInfo.additionPersonalInfo?.currentlocation.uuid ?? ""), value: (basicProfileInfo.additionPersonalInfo?.currentlocation.name ?? ""))
                    
                }else{
                    var locationParam = MIUserModel.getParamForIdText(id: (basicProfileInfo.additionPersonalInfo?.currentlocation.uuid ?? ""), value: (basicProfileInfo.additionPersonalInfo?.currentlocation.name ?? ""))
                    locationParam[APIKeys.otherTextAPIKey] = basicProfileInfo.additionPersonalInfo?.cityName
                    additionalPersonalDetail[APIKeys.currentLocationAPIKey] = locationParam
                    
                }
                if basicProfileInfo.expereienceLevel.uppercased() == "Experienced".uppercased() {
        //            var salaryParams = [String:Any]()
        //
        //
        //            if (basicProfileInfo.additionPersonalInfo?.salarylakh.isEmpty ?? true) {
        //                basicProfileInfo.additionPersonalInfo?.salarylakh = "0"
        //            }
        //            if (basicProfileInfo.additionPersonalInfo?.salaryThousand.isEmpty ?? true) {
        //                basicProfileInfo.additionPersonalInfo?.salaryThousand = "0"
        //            }
        //            var lakhAmount = Int(basicProfileInfo.additionPersonalInfo?.salarylakh ?? "0")
        //            let thousandAmount = Int(basicProfileInfo.additionPersonalInfo?.salaryThousand ?? "0")
        //            if basicProfileInfo.additionPersonalInfo?.salaryCurreny == "INR" {
        //                lakhAmount = (lakhAmount ?? 0)*100000 + (thousandAmount ?? 0)
        //            }
        //            salaryParams[APIKeys.currencyAPIKey] = basicProfileInfo.additionPersonalInfo?.salaryCurreny
        //            salaryParams[APIKeys.absoluteValueAPIKey] = lakhAmount
        //            var salaryMode = [String:Any]()
        //            salaryMode[APIKeys.textAPIKey] = "ANNUALLY"
        //            salaryParams[APIKeys.salaryModeAPIKey] = salaryMode
                    additionalPersonalDetail[APIKeys.currentSalaryAPIKey] = SalaryDetail.getSalaryParam(salary: basicProfileInfo.additionPersonalInfo?.salaryModal ?? SalaryDetail(), withConfidential: false)
                    var expereince = [String:Any]()
                    expereince[APIKeys.yearAPIKey] = basicProfileInfo.additionPersonalInfo?.workExperienceYear
                    expereince[APIKeys.monthAPIKey] = basicProfileInfo.additionPersonalInfo?.workExperienceMonth
                    additionalPersonalDetail[APIKeys.experienceAPIKey] = expereince
                }
                
                params[APIKeys.additionalPersonalDetailAPIKey] = additionalPersonalDetail
        
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        
        
        let task = sut.dataTask(with: (urlRequest as URLRequest)) {data, response, error in
            if let error = error {
              XCTFail("Error: \(error.localizedDescription)")
              return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
              if (200 <= statusCode) && (statusCode <= 299) {
                //2
                
                promise.fulfill()
              } else {
                XCTFail("Status code: \(statusCode)")
              }
            }
            
        }
        
        task.resume()
        wait(for: [promise], timeout: 60)
        
}
}
