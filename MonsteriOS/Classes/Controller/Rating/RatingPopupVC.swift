//
//  RatingPopupVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 08/02/19.
//  Copyright © 2018 Anupam Katiyar. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class RatingPopupVC: UIViewController, MZFormSheetPresentationContentSizing {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var ratingButton: [UIButton]!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ratingButtonAction(_ sender: UIButton) {
        for btn in ratingButton {
            if btn.tag <= sender.tag {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        
        self.ratingLabel.text = "\(sender.tag) of 5"
    }
    
    @IBAction func ratingButtonTouchUpAction(_ sender: UIButton) {
        self.callAPIForJeekerJourneyRateEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK])

        let count = AppUserDefaults.value(forKey: .LaunchCount, fallBackValue: 0).intValue
        
        if sender.tag == 1 {
            CommonClass.googleEventTrcking("rate_your_experience", action: "rating_1", label: "\(count)")
        } else if sender.tag == 2 {
            CommonClass.googleEventTrcking("rate_your_experience", action: "rating_2", label: "\(count)")
        } else if sender.tag == 3 {
           CommonClass.googleEventTrcking("rate_your_experience", action: "rating_3", label: "\(count)")
        } else if sender.tag == 4 {
            CommonClass.googleEventTrcking("rate_your_experience", action: "rating_4", label: "\(count)")
        } else if  sender.tag == 5 {
            CommonClass.googleEventTrcking("rate_your_experience", action: "rating_5", label: "\(count)")
        }
        
        if sender.tag >= CommonClass.starRatingValue {
            if let url = URL(string: ShareAppURL.rateAppUrl) {
                UIApplication.shared.open(url)
                AppUserDefaults.save(value: true, forKey: .RatingSubmitted)
                
                self.dismiss(animated: true, completion: nil)
            }
            
        } else {
            let vc = RatingViewController.instantiate(fromAppStoryboard: .Rating)
            vc.selectedRating = sender.tag
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    @IBAction func skipButtonAction(_ sender: Any) {
        CommonClass.googleEventTrcking("rate_your_experience", action: "skip", label: "rating_pop_up")
        self.callAPIForJeekerJourneyRateEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.NOTNOW])
        self.dismiss(animated: true, completion: nil)
    }
    
    func shouldUseContentViewFrame(for presentationController: MZFormSheetPresentationController!) -> Bool {
        return true
    }
    
    func contentViewFrame(for presentationController: MZFormSheetPresentationController!, currentFrame: CGRect) -> CGRect {
        var frame = currentFrame
        frame.size.width = 300
        frame.size.height = 250
        return frame
    }

    
    func callAPIForJeekerJourneyRateEvent(data:[String:Any]) {
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.RATE_YOUR_EXPERIENCE, data: data, source: "", destination:self.screenName) { (success, response, error, code) in
        
        }
    }
}
