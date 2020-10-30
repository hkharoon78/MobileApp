//
//  MINearByJobMapView.swift
//  MonsteriOS
//
//  Created by Rakesh on 10/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import  MapKit


protocol NearByMapRadiusDelegate:class {
    func  distanceRangeSelected(range:Float)
}

class MINearByJobMapView: UIView {
    
    weak var delegate:NearByMapRadiusDelegate?
    @IBOutlet weak var mkMap_View : MKMapView!
    @IBOutlet weak var currentLocationAddress_Lbl : UILabel!  {
        didSet {
            currentLocationAddress_Lbl?.font = UIFont.customFont(type: .Regular, size: 15)
            currentLocationAddress_Lbl.text = ""
            currentLocationAddress_Lbl.roundCorner(1, borderColor: .white, rad: 5)
        }
    }
    
    @IBOutlet weak var distanceRange_Lbl : UILabel! {
        didSet {
            distanceRange_Lbl?.font = UIFont.customFont(type: .light, size: 16)
        }
    }
    @IBOutlet weak var distanceSlider : UISlider!
    @IBOutlet weak var cancel_Btn : UIButton! {
        didSet {
            cancel_Btn.titleLabel?.font = UIFont.customFont(type: .Medium, size: 15)
            cancel_Btn.setTitleColor(AppTheme.grayColor, for: .normal
            )
        }
    }
    
    @IBOutlet weak var apply_Btn : UIButton! {
        didSet {
            apply_Btn.showPrimaryBtn(fontSize: 15)
        }
    }
    
    class var mapHeaderView : MINearByJobMapView {
        return UINib(nibName: "MINearByJobMapView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MINearByJobMapView
    }
    
    //MARK: - Show/Hide Map View
    func showHideMapViewOnController(parentView:UIView,show:Bool) {
        if show {
            var ht : CGFloat = 64.0
            if #available(iOS 11.0, *) {
                ht =  (kAppDelegate.window?.topViewController()?.view.safeAreaInsets.top)!
            }
            let mapViewFrame = CGRect(x: 0, y:ht, width: parentView.frame.size.width, height:  parentView.frame.size.height)
            self.frame = mapViewFrame
            self.mkMap_View.delegate = self
            if CLLocationManager.locationServicesEnabled() {
                MIAppLocationManager.locationManagerSharedInstance.appStartUpdatingLocation()
            }
            self.showUserCurrentAddress()
            distanceRange_Lbl.text = "Within \(Int(self.distanceSlider.value)) kms"
            parentView.addSubview(self)
            
        }else{
            self.removeFromSuperview()
        }
    }
    
    func showUserCurrentAddress() {
        var address = ""
        if !MIAppLocationManager.locationManagerSharedInstance.currentCity.isEmpty {
            address = "   \(MIAppLocationManager.locationManagerSharedInstance.currentCity)"
        }
        if !MIAppLocationManager.locationManagerSharedInstance.currentState.isEmpty {
            address = "\(address), \(MIAppLocationManager.locationManagerSharedInstance.currentState)"
        }
        if !MIAppLocationManager.locationManagerSharedInstance.currentCountry.isEmpty {
            address = "\(address), \(MIAppLocationManager.locationManagerSharedInstance.currentCountry)   "
        }
        if !address.isEmpty {
            self.currentLocationAddress_Lbl.text = address
        }
    }
    func showCircleWithRadius(radius:Double,coordinate:CLLocationCoordinate2D,circleColor:UIColor,location:String) {
        DispatchQueue.main.async {
            self.mkMap_View.addOverlay(MIMapCustomCircle(locationName: location, circleColor: circleColor, coordinates: coordinate, circleRadius: radius*1000))
        }
        
        if location == "outerCircle" {
            // MKCoordinateRegion(center: <#T##CLLocationCoordinate2D#>, span: <#T##MKCoordinateSpan#>)
            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius*2000, longitudinalMeters: radius*2000)
            self.mkMap_View.setRegion(coordinateRegion, animated: true)
        }
        self.showUserCurrentAddress()
        
    }
    
    //MARK: - IBAction Methods
    @IBAction func applyBtnClicekd(_ sender : UIButton) {
        self.removeFromSuperview()
        if self.delegate != nil {
            self.delegate?.distanceRangeSelected(range: self.distanceSlider.value)
        }
    }
    @IBAction func cancelBtnClicked(_ sender : UIButton) {
        self.removeFromSuperview()
    }
    
    //MARK: - UISlider Action
    @IBAction func sliderValueUpdated(_ sender: UISlider) {
        self.distanceRange_Lbl.text = "Within \(Int(sender.value)) kms"
        if MIAppLocationManager.locationManagerSharedInstance.currentLocation != nil {
            if sender.value >= 50 {
                let overlays = self.mkMap_View.overlays
                if overlays.count > 0 {
                    DispatchQueue.main.async {
                        self.mkMap_View.removeOverlays(overlays)
                    }
                }
                self.showCircleWithRadius(radius:Double(sender.value/100.0), coordinate: (MIAppLocationManager.locationManagerSharedInstance.currentLocation?.coordinate)!, circleColor: UIColor(hex: "FF9900"), location: "innerCircle")
                self.showCircleWithRadius(radius:Double(sender.value), coordinate:(MIAppLocationManager.locationManagerSharedInstance.currentLocation?.coordinate)!, circleColor: UIColor(hex: "FFCC66"), location: "outerCircle")
            }
        }
    }
}

extension MINearByJobMapView : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let character = overlay as? MIMapCustomCircle {
            let circleView = MKCircleRenderer(overlay: character)
            circleView.strokeColor = UIColor.clear
            circleView.fillColor = character.color
            if character.name == "outerCircle" {
                circleView.alpha = 0.5
            }else{
                circleView.alpha = 0.8
            }
            return circleView
        }
        return MKOverlayRenderer()
    }
}

