//
//  MIInterestedModel.swift
//  MonsteriOS
//
//  Created by Rakesh on 26/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIInterestedModel: NSObject {

    var title = ""
    var value = ""
    
    init(placeHolderTitle:String,data:String = "") {
        self.title = placeHolderTitle
        self.value = data
    }
}
