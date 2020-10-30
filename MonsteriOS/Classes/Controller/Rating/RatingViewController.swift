//
//  RatingViewController.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 08/02/19.
//  Copyright © 2018 Anupam Katiyar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MZFormSheetPresentationController

class RatingViewController: UIViewController, MZFormSheetPresentationContentSizing {
    
    @IBOutlet weak var textView: UITextView!
    
    var selectedRating: Int!
    private var userComment = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitButtonAction(_ sender: AKLoadingButton) {
        self.view.endEditing(true)
        
        self.callAPIForJeekerJourneyRatingFeedbackEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.SUBMIT])
        
        MIApiManager.hitReportBug("Rating",
                                  name: AppDelegate.instance.userInfo.fullName,
                                  email: AppDelegate.instance.userInfo.primaryEmail,
                                  mobileNumber: AppDelegate.instance.userInfo.mobileNumber,
                                  details: self.userComment)
        { (success, response, error, code) in
        }
        
        let vc = ThankuRatingPopupVC.instantiate(fromAppStoryboard: .Rating)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    func callAPIForJeekerJourneyRatingFeedbackEvent(data:[String:Any]) {
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.RATE_YOUR_EXPERIENCE, data: data, source: "", destination:self.screenName) { (success, response, error, code) in
            
        }
    }
}

extension RatingViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.userComment = newText
        
        return true
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        guard let cell = textView.tableViewCell()  else { return }
//
//        let newHeight = cell.frame.size.height + textView.contentSize.height
//        cell.frame.size.height = newHeight
//        updateTableViewContentOffsetForTextView()
//    }
//    // Animate cell, the cell frame will follow textView content
//    func updateTableViewContentOffsetForTextView() {
//        let currentOffset = ratingTableView.contentOffset
//        UIView.setAnimationsEnabled(false)
//        ratingTableView.beginUpdates()
//        ratingTableView.endUpdates()
//        UIView.setAnimationsEnabled(true)
//        ratingTableView.setContentOffset(currentOffset, animated: false)
//    }
}
