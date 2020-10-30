//
//  MILoginModel.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 11/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//
import Foundation

struct LoginAuth: Codable {
    var accessToken, tokenType: String
    let expiresIn: Int?
    let scope, jti: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope, jti
    }
}

extension LoginAuth {
    func commit() {        
        guard let data = try? JSONEncoder().encode(self) else {
            return
        }
        guard let authInfo = String(data: data, encoding: .utf8) else { return }
        AppUserDefaults.save(value: authInfo, forKey: .AuthenticationInfo)
    }
}


struct AppleRefreshToken: Codable {
    let refreshToken: String
    let idToken: String
}

struct OTPModel: Codable {
    var id: String
}

struct ErrorModel: Codable {
    let appName, appVersion, errorCode, errorMessage: String
}

struct LoginErrorModel: Codable {
    let error, error_description: String
}


struct SuccessModel: Codable {
    let successMessage: String
}


struct ValidationModel: Codable {
    let message: String
}
