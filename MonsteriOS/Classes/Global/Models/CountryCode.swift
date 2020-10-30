//
//  CountryCode.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 13/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//
// To parse the JSON
//
//   let countryCode = try? newJSONDecoder().decode(CountryCode.self, from: jsonData)

import Foundation

typealias CountryCode = [CountryCodeItem]

struct CountryCodeItem: Codable {
    let name: String
    let dialCode: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
    }
}
