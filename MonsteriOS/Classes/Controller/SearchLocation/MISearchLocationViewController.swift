//
//  MISearchLocationViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 05/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import CoreLocation

protocol MISearchLocationDelegate:class {
    func locationSelected(locArray:[String])
    func preferLocationSelected()
}

class MILocationPreferenceInfo:NSObject {
    var imgName = ""
    var title   = ""
    init(with ttl:String,imgNm:String) {
        title = ttl
        imgName = imgNm
    }
}
class MISearchLocationViewController: MIBaseViewController,UITableViewDataSource,UITableViewDelegate {
    private var isAnotherDelegateCalled = false
    @IBOutlet weak private var tblView:UITableView!
   // @IBOutlet weak private var searchBar:UISearchBar!
    weak var delegate:MISearchLocationDelegate?
    private var locationCellId = "locationCell"
    private var locationPreferenceCellId = "locationPreferenceCell"
    private var locationArray = [MILocationInfo]()
    
    var selectedInfoArray = [String]()
    private var shouldShowLocationPreference = false
    private var locationPreferenceArray = [MILocationPreferenceInfo]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectedViewHeightConstraint: NSLayoutConstraint!
    
    lazy private var doneButton: UIBarButtonItem = {
        let image = UIImage(named: "right_tick_blue", in: bundle(), compatibleWith: nil)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(DoneLocation));
        button.tintColor = navigationController?.navigationBar.tintColor
//        let title = NSLocalizedString("mbdoccapture.done_button", tableName: nil, bundle: bundle(), value: "Done", comment: "")
//        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(DoneLocation))
//        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()
    
    //location
    let locationManager = CLLocationManager()
    var location: CLLocation?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var city: String?
    var country: String?
    var countryShortName: String?
    
    lazy var searchBar:MISearchBar = MISearchBar(frame:CGRect(x: 0, y: 0, width:Double(self.view.frame.size.width-60), height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        
    }
   
    override func viewWillDisappear(_ animated: Bool) {
//        self.delegate?.locationSelected(locArray: selectedInfoArray)
        if isAnotherDelegateCalled == false {
            self.delegate?.locationSelected(locArray: selectedInfoArray)
        }
    }
    
    func setUI() {
        //Search Location
//        self.callLocationService(locationkey: "in")
        self.navigationItem.titleView=searchBar
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
        
        locationArray.removeAll()
        self.tblView.register(UINib(nibName: "MILocationCell", bundle: nil), forCellReuseIdentifier: locationCellId)
        self.tblView.register(UINib(nibName: "MILocationPreferenceCell", bundle: nil), forCellReuseIdentifier: locationPreferenceCellId)
        self.tblView.tableFooterView = UIView()
        
        shouldShowLocationPreference = true
        var info = MILocationPreferenceInfo.init(with: "Current Location", imgNm: "current_location_icon")
        locationPreferenceArray.append(info)
        
        info = MILocationPreferenceInfo.init(with: "Preferred location", imgNm: "search_location_icon")
        
        if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
            var list =  tabBar.jobPreferenceInfo.preferredLocationList.map({$0.name})
            list = list.filter({$0 != ""})
            if list.count > 0 {
                locationPreferenceArray.append(info)
            }
        }
    
        self.tblView.reloadData()
        searchBar.delegate=self
        searchBar.returnKeyType = .done
        searchBar.placeholder = "Search Location"
        self.showSelection(list: self.selectedInfoArray)
    }
    
    func callLocationService(locationkey:String) {
        MIApiManager.callLocationService(key: locationkey) { [weak wSelf = self] (isSuccess, response, error, code) in
            DispatchQueue.main.async {
                wSelf?.locationArray.removeAll()
                if isSuccess, let res = response as? [String:Any], let data = res["data"] as? [[String:Any]] {
                    for location in data {
                        let locInfo = MILocationInfo.init(dic: location)
                        wSelf?.locationArray.append(locInfo)
                    }
                }
                wSelf?.tblView.reloadData()
            }
        }
    }
    
    func callAPIForJobSeekerEvent(type:String,data:[String:Any]) {
        
        MIApiManager.hitSeekerJourneyMapEvents(type, data: data, source: CONSTANT_SCREEN_NAME.SEARCH, destination: self.screenName) { (success, response, error, code) in
            
        }
    }
    
    @objc private func DoneLocation() {
        self.delegate?.locationSelected(locArray: selectedInfoArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowLocationPreference {
            return locationPreferenceArray.count
        }
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shouldShowLocationPreference, let cell = tblView.dequeueReusableCell(withIdentifier: locationPreferenceCellId) as? MILocationPreferenceCell {
                cell.show(info: locationPreferenceArray[indexPath.row])
                return cell
        }
        
        if let cell = tblView.dequeueReusableCell(withIdentifier: locationCellId) as? MILocationCell {
            let locInfo = locationArray[indexPath.row]
            cell.tintColor = AppTheme.defaltBlueColor
            if selectedInfoArray.contains(locInfo.name) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.show(info: locInfo)
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowLocationPreference {
            if indexPath.row == 0 {
                if let city = self.city {
                    self.callAPIForJobSeekerEvent(type: CONSTANT_JOB_SEEKER_TYPE.CURRENT_LOCATION, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK])
                    isAnotherDelegateCalled = true
                    self.delegate?.locationSelected(locArray: [city])
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.callAPIForJobSeekerEvent(type: CONSTANT_JOB_SEEKER_TYPE.CURRENT_LOCATION, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK,"validationErrorMessages":[["field":"current_location","message":"location not enable"]]])

                    if !CLLocationManager.locationServicesEnabled() {
                        self.showLocationDisabledpopUp()
                    } else {
                        showAlert(title: "", message: "Please check location in phone setting")
                    }
                }
            }
            else if indexPath.row == 1 {
                isAnotherDelegateCalled = true
               
                if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
                    var list =  tabBar.jobPreferenceInfo.preferredLocationList.map({$0.name})
                    list = list.filter({$0 != ""})
                    
                }
                self.callAPIForJobSeekerEvent(type: CONSTANT_JOB_SEEKER_TYPE.PREF_LOCATION, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK])

                self.delegate?.preferLocationSelected()
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            searchBar.text = ""
            shouldShowLocationPreference = true
            let locInfo = locationArray[indexPath.row]
            var isAppending = false
            if self.selectedInfoArray.contains(locInfo.name) {
                self.delete(element: locInfo.name)
            } else {
                isAppending = true
                selectedInfoArray.append(locInfo.name)
            }
            self.showSelection(list: selectedInfoArray,isAppending: isAppending)
            self.tblView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension MISearchLocationViewController:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let searchString = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        if searchString.count <= 1 {
            shouldShowLocationPreference = true
        } else  {
            shouldShowLocationPreference = false
            self.callLocationService(locationkey: searchString)
        }
        self.tblView.reloadData()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isAnotherDelegateCalled = true
        self.delegate?.locationSelected(locArray: selectedInfoArray)
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MISearchLocationViewController:CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
      //  printDebug("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let latestLocation = locations.last!
        
        // here check if no need to continue just return still in the same place
        if latestLocation.horizontalAccuracy < 0 {
            return
        }
        
        if location == nil || location!.horizontalAccuracy > latestLocation.horizontalAccuracy {
            
            location = latestLocation
            // stop location manager
            stopLocationManager()
            
            // Here is the place you want to start reverseGeocoding
            geocoder.reverseGeocodeLocation(latestLocation, completionHandler: { (placemarks, error) in
                // always good to check if no error
                // also we have to unwrap the placemark because it's optional
                // I have done all in a single if but you check them separately
                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                    self.placemark = placemark.last
                }
                // a new function where you start to parse placemarks to get the information you need
                self.parseLocation()
                
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied){
            showLocationDisabledpopUp()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print the error to see what went wrong
      //  print("didFailwithError\(error)")
        // stop location manager if failed
        //stopLocationManager()
    }
    
    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func showLocationDisabledpopUp() {
        self.showAlert(title: NSLocalizedString("", comment: ""), message: NSLocalizedString("Your location is disabled please enable", comment: ""))
    }
    
    func parseLocation() {
            if let _ = location {
                // unwrap the placemark
                if let placemark = placemark {
                    // wow now you can get the city name. remember that apple refers to city name as locality not city
                    // again we have to unwrap the locality remember optionalllls also some times there is no text so we check that it should not be empty
                    if let city = placemark.locality, !city.isEmpty {
                        // here you have the city name
                        // assign city name to our iVar
                        self.city = city
                    }
                    // the same story optionalllls also they are not empty
                    if let country = placemark.country, !country.isEmpty {
                        
                        self.country = country
                    }
                    // get the country short name which is called isoCountryCode
                    if let countryShortName = placemark.isoCountryCode, !countryShortName.isEmpty {
                        
                        self.countryShortName = countryShortName
                    }
                    
                }
                
                
            } else {
                // add some more check's if for some reason location manager is nil
            }
    }
}

extension MISearchLocationViewController:UIScrollViewDelegate,MIMasterDataSelectionViewDelegate {
    func removeListItem(item: String) {
        if !item.isEmpty {
            self.delete(element: item)
            self.showSelection(list: selectedInfoArray)
            self.tblView.reloadData()
        }
    }
    
    func removeAll()
    {
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func delete(element: String) {
        self.selectedInfoArray = selectedInfoArray.filter() { $0 != element }
    }
    
    func showSelection(list:[String], isAppending:Bool = false) {
        var xOrigin = 10
        if !isAppending {
            self.removeAll()
        }
        if list.count == 0 {
            self.selectedViewHeightConstraint.constant = 0
        } else {
            self.selectedViewHeightConstraint.constant = 50
        }
        
        for index in 0..<list.count {
            let sugView = MIMasterDataSelectionView.selectedView
            sugView.show(ttl: list[index])
            sugView.frame.size.width = sugView.titleLbl.frame.size.width + 50
            sugView.frame = CGRect(x: CGFloat(xOrigin), y: 12.0, width: sugView.frame.size.width, height: sugView.frame.size.height-10)
            sugView.delegate = self
            xOrigin = Int(sugView.frame.maxX + 10)
            self.scrollView.addSubview(sugView)
            
            self.scrollView.contentSize = CGSize(width: xOrigin + 10, height: 0)
        }
        
        let scrollWidth = kScreenSize.width
        let totalWidth = self.scrollView.contentSize.width - scrollWidth
        let xIndex = (totalWidth/(scrollWidth))
        if xIndex > 0 {
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(xIndex)*CGFloat(scrollWidth), y: 0), animated: isAppending)
        }
    }
}
