//
//  DeepLinkModel.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 20/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

struct DeepLinkResponse: Codable {
    let data: DeepLinkModel
}

// MARK: - DataClass
struct DeepLinkModel: Codable {
    let salary, locations: [String]
    let skills, experience: [String]
}
