//
//  MISplashModel.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 04/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//
// To parse the JSON
//
//  let newJSONDecoder = JSONDecoder()
//  let df = DateFormatter.dateFormatter
//  df.dateFormat = "yyyy-MM-dd HH:mm:ss" //- "2018-09-27 08:49:02"
//  newJSONDecoder.dateDecodingStrategy = .formatted(df)
//  let model = try? newJSONDecode.decode(SplashModel.self, from: jsonData)


import Foundation

struct SplashModel: Codable {
    var deviceName: String
    var sites: [Site]
    var countries: [CountryModel]? //Removed in v2
    var currencies: [CurrencyModel]? //Removed in v2
}

struct SplashCountryCurrencyModel: Codable {
    var countries: [CountryModel]?
    var currencies: [CurrencyModel]?
}

extension SplashModel {
    static func blankInit() -> SplashModel {
        return SplashModel.init(deviceName: "", sites: [], countries: [], currencies: [] )
    }
}

struct CountryModel: Codable {
    let id, zoneID: Int
    let isoCode: String
    let currencyID, callPrefix, containsStates, needIdentificationNumber: Int
    let needZipCode: Int
    let zipCodeFormat: String
    let displayTaxLabel: Int
    let createdAt, updatedAt, deletedAt: Date?
    let langOne: [LangOne]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case zoneID = "zone_id"
        case isoCode = "iso_code"
        case currencyID = "currency_id"
        case callPrefix = "call_prefix"
        case containsStates = "contains_states"
        case needIdentificationNumber = "need_identification_number"
        case needZipCode = "need_zip_code"
        case zipCodeFormat = "zip_code_format"
        case displayTaxLabel = "display_tax_label"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case langOne = "lang"
    }
}

struct CurrencyModel: Codable {
    let id: Int
    let name: String
    let isoCode: String
    let isoCodeNum: String
    let sign: String
    let blank, format, decimals: Int
    let conversionRate: String
    let createdAt, updatedAt, deletedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case isoCode = "iso_code"
        case isoCodeNum = "iso_code_num"
        case sign, blank, format, decimals
        case conversionRate = "conversion_rate"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct LangOne: Codable {
    let countryID, langID: Int
    let name: String
    let createdAt, updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case countryID = "country_id"
        case langID = "lang_id"
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Site: Codable {
    let id: Int
    let name: String
    let categoryID, themeID, tenantID, langID: Int
    let defaultCountryID, underMaintenance: Int
    let domain, context, favicon: String
    let langCount: Int?
    let createdAt, updatedAt, deletedAt: Date?
    let defaultCountryDetails: CountryModel
    let defaultCurrencyDetails: DefaultCurrencyDetails
    let supportedCurrencies: [DefaultCurrencyDetails]
    let lang: [Lang]
    let siteProps: [SiteProp]
    
    var selected: Bool? = false

    enum CodingKeys: String, CodingKey {
        case id, name
        case categoryID = "category_id"
        case themeID = "theme_id"
        case tenantID = "tenant_id"
        case langID = "lang_id"
        case defaultCountryID = "default_country_id"
        case underMaintenance = "under_maintenance"
        case domain, context, favicon
        case langCount = "lang_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case defaultCountryDetails = "default_country_details"
        case defaultCurrencyDetails = "default_currency_details"
        case supportedCurrencies = "supported_currencies"
        case lang
        case siteProps = "site_props"
        case selected
    }
}

struct SiteProp: Codable {
    let id, siteID, tenantID: Int
    let name, value: String
    let siteGroup: String
    let createdAt, updatedAt, deletedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case siteID = "site_id"
        case tenantID = "tenant_id"
        case name, value
        case siteGroup = "site_group"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct Lang: Codable {
    let siteID, langID: Int
    let title: String
    let createdAt, updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case siteID = "site_id"
        case langID = "lang_id"
        case title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct DefaultCurrencyDetails: Codable {
    let currencyID, siteID: Int
    let conversionRate: String
    let markup: Int
    let markupType: String
    let currency: CurrencyModel?
    
    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
        case siteID = "site_id"
        case conversionRate = "conversion_rate"
        case markup
        case markupType = "markup_type"
        case currency
    }
}

struct WelcomeMessage: Codable {
    let text, type: String
}

extension SplashModel {
    func commit() {
        guard let data = try? JSONEncoder().encode(self) else {
            return
        }
        guard let splashData = String(data: data, encoding: .utf8) else { return }
        AppUserDefaults.save(value: splashData, forKey: .SplashData, archieve: true)
    }
}

extension Site {
    func commit() {
        guard let data = try? JSONEncoder().encode(self) else {
            return
        }
        guard let siteData = String(data: data, encoding: .utf8) else { return }
        AppUserDefaults.save(value: siteData, forKey: .SelectedSite, archieve: true)
        
        DispatchQueue.main.async {
            AppDelegate.instance.initializeFBSDK(self)
        }
    }
}

struct ForceUpdate: Codable {
    let currentVersion, softUpdateTill: Int
    let updateMessage: String
}

