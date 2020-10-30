//
//  MIThankYouRatingVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 01/06/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit
import BottomPopup

class MIThankYouRatingVC: BottomPopupViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     override func getPopupHeight() -> CGFloat {
         return 335
     }
    
     override func getPopupCornerRadius() -> CGFloat {
         return 15
     }

    override func shouldPopupDismissInteractivelty() -> Bool {
        return false
    }

    @IBAction func submitButtonAction(_ sender: Any) {
        CommonClass.googleEventTrcking("App_Rating_Thankyou", action: "Done", label: "N/A")

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        CommonClass.googleEventTrcking("App_Rating_Thankyou", action: "Close", label: "N/A")

        self.dismiss(animated: true, completion: nil)
    }
}
