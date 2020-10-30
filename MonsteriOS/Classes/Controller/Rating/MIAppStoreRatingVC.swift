//
//  MIAppStoreRatingVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 01/06/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit
import StoreKit
import BottomPopup

class MIAppStoreRatingVC: BottomPopupViewController {

    @IBOutlet var ratingButton: [UIButton]!

    var rating = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        for btn in ratingButton {
            if btn.tag <= rating {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }

    }
    
     override func getPopupHeight() -> CGFloat {
        return UIScreen.width * 1.55//640
     }
    
     override func getPopupCornerRadius() -> CGFloat {
         return 15
     }

    override func shouldPopupDismissInteractivelty() -> Bool {
        return false
    }
    
    @IBAction func notNowButtonAction(_ sender: UIButton) {
        let action = (sender.currentTitle==nil) ? "Close" : "Not_Now"
        CommonClass.googleEventTrcking("App_Rating_Store", action: action, label: "N/A")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateNowButtonAction(_ sender: Any) {
        CommonClass.googleEventTrcking("App_Rating_Store", action: "Rate_Now", label: "N/A")

//        if #available(iOS 10.3, *) {
//            SKStoreReviewController.requestReview()
//        } else {
            if let url = URL(string: ShareAppURL.rateAppUrl) {
                UIApplication.shared.open(url)
            }
//        }
        
        self.dismiss(animated: true, completion: nil)

    }
    
}
