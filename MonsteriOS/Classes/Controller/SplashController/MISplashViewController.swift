//
//  MISplashViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 27/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISplashViewController: MIBaseViewController {
    
    
    var landingNavigation = MINavigationViewController(rootViewController:MILandingViewController())
    
    override func initUI() {
        //self.navigationController?.navigationBar.isHidden = true
        
        if let res = self.loadJson(filename: "MasterLocal"), let data = res["data"] as? [[String:Any]] {
            GlobalVariables.masterDataTypeArray = MIMasterDataTypeInfo.modelsFromDictionaryArray(array: data)
        }
        landingNavigation.modalPresentationStyle = .fullScreen
        self.present(landingNavigation, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.fetchCountrySitesData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationObserved), name: .LocationFetched, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .LocationFetched, object: nil)
    }
    
    @objc func locationObserved() {
        self.manageCountrySelection()
    }
    
    func manageCountrySelection() {
        
        let sites = AppDelegate.instance.splashModel.sites
        guard sites.count > 0 else { return }
        
        if AppDelegate.instance.site == nil {
            let isoCode = MIAppLocationManager.locationManagerSharedInstance.isoCode
            
            CommonClass.selectCountry(for: isoCode)
        
            self.openCountryCodeSelection()
        }
    }
    
    func openCountryCodeSelection() {
        let vc=MISettingHomeViewController()
        vc.selectedSettingType = .changecountry
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen
        landingNavigation.present(nav, animated: true, completion: nil)
        vc.title = "Select Country"
    }
    
}


extension MISplashViewController {
    
//    func fetchCountrySitesData() {
//        if AppDelegate.instance.site == nil {
//            MIActivityLoader.showLoader()
//        }
//        MIApiManager.splashAPI { (result, error) in
//            MIActivityLoader.hideLoader()
//            guard var data = result else { return }
//            
//            let siteArr = data.sites.map({ (site) -> Site in
//                var s = site
//                s.selected = (site.defaultCountryDetails.isoCode == AppDelegate.instance.site?.defaultCountryDetails.isoCode)
//                return s
//            })
//            
//            data.sites = siteArr
//            data.commit()
//            
//            AppDelegate.instance.splashModel = data
//            
//            let ios = AppDelegate.instance.site?.defaultCountryDetails.isoCode
//            AppDelegate.instance.site = data.sites.filter({ $0.defaultCountryDetails.isoCode == ios}).first
//            AppDelegate.instance.site?.commit()
//            
//            if MIAppLocationManager.locationManagerSharedInstance.status != .notDetermined {
//                self.manageCountrySelection()
//            }
//        }
//    }
    
}
