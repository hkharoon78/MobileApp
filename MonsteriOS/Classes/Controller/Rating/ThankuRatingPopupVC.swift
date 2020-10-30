//
//  ThankuRatingPopupVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 08/02/19.
//  Copyright © 2018 Anupam Katiyar. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class ThankuRatingPopupVC: UIViewController, MZFormSheetPresentationContentSizing {

    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var rateSkipContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.rateSkipContainer.isHidden = !rateMore
        AppUserDefaults.save(value: true, forKey: .RatingSubmitted)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        self.callAPIForJeekerJourneyRatingThankYouEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CANCEL])
        
        self.dismiss(animated: true, completion: {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.HOME)

        })
    }
    
    @IBAction func shareAppAction(_ sender: Any) {
        self.dismiss(animated: true) {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.HOME)

            let shareUrl = URL(string: ShareAppURL.appStoreUrl)!
            
            let shareAll = [shareUrl] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            if let senderbtn = sender as? UIButton {
                activityViewController.popoverPresentationController?.sourceRect = senderbtn.frame
            }

            AppDelegate.instance.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func shouldUseContentViewFrame(for presentationController: MZFormSheetPresentationController!) -> Bool {
        return true
    }
    
    func contentViewFrame(for presentationController: MZFormSheetPresentationController!, currentFrame: CGRect) -> CGRect {
        var frame = currentFrame
        frame.size.width = 300
        frame.size.height = 300
        return frame
    }
    func callAPIForJeekerJourneyRatingThankYouEvent(data:[String:Any]) {
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.RATE_YOUR_EXPERIENCE, data: data, source: "", destination:self.screenName) { (success, response, error, code) in
            
        }
    }
}
