//
//  MISalaryModel.swift
//  MonsteriOS
//
//  Created by Rakesh on 18/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISalaryModel: NSObject {

    static var optionSelectionData =   ["minOptionSelection": ["titleSelectedIndex":-1,"subTitleSelectedIndex":-1] ,"maxOptionSelection" : ["titleSelectedIndex":-1,"subTitleSelectedIndex":-1]]

    var titleValue = ""
    var subTitleValue = ""
 
    init(title:String,subTitle:String) {
        self.titleValue = title
        self.subTitleValue = subTitle
    }

}
