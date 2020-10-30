//
//  MIMapCustomCircle.swift
//  MonsteriOS
//
//  Created by Rakesh on 10/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import MapKit

class MIMapCustomCircle: MKCircle {

    var color : UIColor?
    var name : String?
    
    convenience init(locationName:String,circleColor:UIColor,coordinates:CLLocationCoordinate2D,circleRadius:Double) {
        
        self.init(center: coordinates, radius: circleRadius)
        self.color = circleColor
        self.name = locationName
    }
}
