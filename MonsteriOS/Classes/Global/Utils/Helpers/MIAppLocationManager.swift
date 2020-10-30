//
//  MIAppLocationManager.swift
//  MonsteriOS
//
//  Created by Rakesh on 10/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import CoreLocation
//import CleverTapSDK

class MIAppLocationManager: NSObject {
    
    static let locationManagerSharedInstance = MIAppLocationManager.init()
    var locationManager : CLLocationManager?
    var currentLocation : CLLocation?
    var localAddress = ""
    var currentCity = ""
    var currentState = ""
    var currentCountry = ""
    var isoCode = ""
    var status: CLAuthorizationStatus = .notDetermined
    
    private override init() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func appStartUpdatingLocation() {
        MIAppLocationManager.locationManagerSharedInstance.locationManager?.delegate = self
        MIAppLocationManager.locationManagerSharedInstance.locationManager?.startUpdatingLocation()
    }
    func appStopUpdatingLocation() {
        MIAppLocationManager.locationManagerSharedInstance.locationManager?.stopUpdatingLocation()
    }
}

extension MIAppLocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastUpdatePoint = locations.last!
        if lastUpdatePoint.horizontalAccuracy < 0 {
            return
        }
        
        if MIAppLocationManager.locationManagerSharedInstance.currentLocation == nil || MIAppLocationManager.locationManagerSharedInstance.currentLocation!.horizontalAccuracy >= lastUpdatePoint.horizontalAccuracy {
            MIAppLocationManager.locationManagerSharedInstance.currentLocation = locations.last
           // self.appStopUpdatingLocation()
        }
        if let location = MIAppLocationManager.locationManagerSharedInstance.currentLocation {
           // CleverTap.setLocation(location.coordinate)
            self.getAddressFromCoordinates(location)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        MIAppLocationManager.locationManagerSharedInstance.appStopUpdatingLocation()
        NotificationCenter.default.post(name: .LocationFetched, object: nil, userInfo: nil)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        if status == .authorizedWhenInUse {
           // print("Loction Allowed")
        } else if status == .denied {
            NotificationCenter.default.post(name: .LocationFetched, object: nil, userInfo: nil)
           // print("Loction Denied")
        }
    }
}

extension MIAppLocationManager {
    
    func getAddressFromCoordinates(_ location: CLLocation, completion: (()->Void)? = nil) {
        
        CLGeocoder().reverseGeocodeLocation(location) { (placeMarks,error) in
            
            if error == nil {
                if (placeMarks?.count)! > 0 {
                    let place = placeMarks?.first
                    
                    if let city = place!.locality, !city.isEmpty {
                        MIAppLocationManager.locationManagerSharedInstance.currentCity = city
                    }
                    if let state = place!.administrativeArea, !state.isEmpty {
                        MIAppLocationManager.locationManagerSharedInstance.currentState = state
                    }
                    if let country = place!.country, !country.isEmpty {
                        MIAppLocationManager.locationManagerSharedInstance.currentCountry = country
                    }
                    if let isoCode = place?.isoCountryCode {
                        MIAppLocationManager.locationManagerSharedInstance.isoCode = isoCode
                    }

                    NotificationCenter.default.post(name: .LocationFetched, object: nil, userInfo: nil)
                    completion?()
                }
            }
        }
    }
}


extension Notification.Name {
    static let LocationFetched = Notification.Name("LocationFetched")
    static let CountryChanged  = Notification.Name("CountryChanged")
    static let invalidAuth = Notification.Name("INVALID_AUTH")
    static let userEngagementSPL = Notification.Name("UserEngagementSPL")
    static let sessionId = Notification.Name("SessionId")
    static let JobAppliedNotification  = Notification.Name("JobAppliedNotification")
    static let pendingActionGleacCall  = Notification.Name("PendingActionGleacCallBack")
    static let refreshJobList  = Notification.Name("RefreshJobList")

    
}
