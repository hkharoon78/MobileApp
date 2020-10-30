//
//  Ext_UILabel.swift
//  BusinessApp
//
//  Created by Piyush Dwivedi on 12/01/18.
//  Copyright © 2018 PayTm. All rights reserved.
//

import Foundation
import UIKit

extension ActiveLabel {
    
    func addLink(linkColor:UIColor, linkTxt:[String],
                                  completion:((_ substring: String?) -> Void?)?) {
        
        for customString in linkTxt {
            let customType = ActiveType.custom(pattern: "\\s\(customString)\\b")
            self.enabledTypes.append(customType)
            self.customColor[customType] = linkColor
            self.handleCustomTap(for: customType) { (substring) in
                if let block = completion {
                    block(substring)
                }
            }
        }
        self.customize { label in
            self.text = self.text
        }
    }
}
