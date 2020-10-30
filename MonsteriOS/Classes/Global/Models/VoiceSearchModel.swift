//
//  VoiceSearchModel.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 01/05/19.
//  Copyright © 2019 Monster. All rights reserved.
//
// To parse the JSON
//
//   let voiceSearchModel = try? newJSONDecoder().decode(VoiceSearchModel.self, from: jsonData)

import Foundation

struct VoiceSearchModel: Codable {
    let data: VoiceModel
}

struct VoiceModel: Codable {
    let skills: [String]
    let salary, locations, experience: [String]
}
