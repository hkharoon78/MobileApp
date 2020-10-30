//
//  EngagementCards.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 20/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//
//  To parse the JSON
//
//  let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
//
//  Reference: https://stackoverflow.com/questions/44603248/how-to-decode-a-property-with-type-of-json-dictionary-in-swift-4-decodable-proto
//
import Foundation

// MARK: - Welcome
struct EngagementCards: Decodable {
    let cards: [Card]
    let ruleApplied: String?
    let ruleVersion: String?
}

// MARK: - Card
struct Card: Decodable {
    let type, text: String

    var ruleApplied: String?
    var ruleVersion: String?
    
    private var __data: AnyDecodable
    
    var data: Any? {
        get {
            return __data.value
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case __data = "data"
        case type, text
    }
}


public struct AnyDecodable: Decodable {
    public var value: Any?
    
    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        init?(stringValue: String) { self.stringValue = stringValue }
    }
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var result = [String: Any]()
            try container.allKeys.forEach { (key) throws in
                result[key.stringValue] = try container.decode(AnyDecodable.self, forKey: key).value
            }
            value = result
        } else if var container = try? decoder.unkeyedContainer() {
            var result = [Any]()
            while !container.isAtEnd {
                result.append(try container.decode(AnyDecodable.self).value!)
            }
            value = result
        } else if let container = try? decoder.singleValueContainer() {
            if let intVal = try? container.decode(Int.self) {
                value = intVal
            } else if let doubleVal = try? container.decode(Double.self) {
                value = doubleVal
            } else if let boolVal = try? container.decode(Bool.self) {
                value = boolVal
            } else if let stringVal = try? container.decode(String.self) {
                value = stringVal
            } else {
                //throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing serialisable")
                value = nil
            }
        } else {
            value = nil
            //throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
        }
    }
}



//public protocol JSONType: Codable {
//    var jsonValue: Any { get }
//}
//extension Int: JSONType {
//    public var jsonValue: Any { return self }
//}
//extension String: JSONType {
//    public var jsonValue: Any { return self }
//}
//extension Double: JSONType {
//    public var jsonValue: Any { return self }
//}
//extension Bool: JSONType {
//
//    public var jsonValue: Any { return self }
//}
//
//public struct AnyJSONType: JSONType {
//    public let jsonValue: Any
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//
//        if let intValue = try? container.decode(Int.self) {
//            jsonValue = intValue
//        } else if let stringValue = try? container.decode(String.self) {
//            jsonValue = stringValue
//        } else if let boolValue = try? container.decode(Bool.self) {
//            jsonValue = boolValue
//        } else if let doubleValue = try? container.decode(Double.self) {
//            jsonValue = doubleValue
//        } else if let doubleValue = try? container.decode(Array<AnyJSONType>.self) {
//            jsonValue = doubleValue
//        } else if let doubleValue = try? container.decode(Dictionary<String, AnyJSONType>.self) {
//            jsonValue = doubleValue
//        } else {
//            jsonValue = container.decodeNil()
//            //throw DecodingError.typeMismatch(JSONType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported JSON type"))
//        }
//    }
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        if let intValue = jsonValue as? Int {
//            try container.encode(intValue)
//        } else if let stringValue = jsonValue as? String {
//            try container.encode(stringValue)
//        } else if let boolValue = jsonValue as? Bool {
//            try container.encode(boolValue)
//        } else if let doubleValue = jsonValue as? Double {
//            try container.encode(doubleValue)
//        } else if let arraayValue = jsonValue as? Array<AnyJSONType> {
//            try container.encode(arraayValue)
//        } else if let dictValue = jsonValue as? Dictionary<String, AnyJSONType> {
//            try container.encode(dictValue)
//        } else {
//            throw EncodingError.invalidValue(jsonValue, .init(codingPath: encoder.codingPath, debugDescription: "Unsupported JSON type"))
//        }
//    }
//
//}
//
//fileprivate extension AnyJSONType {
//    var mapValue: Any {
//        if let v = jsonValue as? Dictionary<String, AnyJSONType> {
//            return Dictionary(uniqueKeysWithValues: v.map { key, value in (key, value.mapValue) })
//        } else if let v = jsonValue as? Array<AnyJSONType> {
//            return v.map({ $0.mapValue })
//        } else {
//            return jsonValue
//        }
//    }
//}


extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
