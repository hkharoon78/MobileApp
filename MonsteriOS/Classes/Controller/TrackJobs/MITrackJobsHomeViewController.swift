//
//  MITrackJobsHomeViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 14/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol JobDetailsNavigationDelegate {
    func navigateToJobDetails(jobId:String)
}
class MITrackJobsHomeViewController: ButtonBarPagerTabStripViewController {
    
    //MARK:Life Cycle Method
    var selectedControllerType:TrackJobsType = .applied
   
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = AppTheme.defaltBlueColor//UIColor.init(hex: "5c4aae")
        settings.style.buttonBarItemFont = UIFont.customFont(type: .Medium, size: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.init(hex: "637381")
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
           
            guard self != nil else { return }
            
            guard changeCurrentIndex == true else {
                
                if oldCell == nil && newCell == nil {            if JobSeekerSingleton.sharedInstance.dataArray?.last != CONSTANT_SCREEN_NAME.APPLIED_SCREEN {
                    JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.APPLIED_SCREEN)

                    }
                }
                return
                
            }
            if oldCell != nil && newCell != nil {
                self?.hitTrackItemSelectedevent(title: newCell?.label.text ?? "")
            }
            oldCell?.label.textColor = UIColor.init(hex: "637381")
            newCell?.label.textColor = AppTheme.defaltBlueColor//UIColor.init(hex: "5c4aae")
           // kActivityIndicator.stopAnimating()
            
        }
    
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen

        self.title = ControllerTitleConstant.trackJobs
        self.navigationItem.title = ControllerTitleConstant.trackJobsTitle
       
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }


    //MARK:Override Mathod for Adding View Controllers
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let appliedVc=MIAppliedSavedNetworkViewController()
        appliedVc.controllerType = .applied
        appliedVc.delegate=self
        
        let savedVc=MISavedJobViewController()
        savedVc.delegate=self
        savedVc.controllerType = .saved
        
        let networkVc=MINetworkJobsViewController()
        networkVc.delegate=self
        networkVc.controllerType = .viewed
       
        return [appliedVc,savedVc,networkVc]
        //return [appliedVc,savedVc]
    }
    
    func hitTrackItemSelectedevent(title:String) {
//        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.TRACK_JOB, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.SAVED], source: "", destination: CONSTANT_SCREEN_NAME.SAVED_SCREEN) { (success, response, error, code) in
//                     }
//
//        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.TRACK_JOB, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.APPLIED], source: "", destination: CONSTANT_SCREEN_NAME.APPLIED_SCREEN) { (success, response, error, code) in
//                           }
//
//        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.TRACK_JOB, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.NETWORK], source: "", destination: CONSTANT_SCREEN_NAME.NETWORK_SCREEN) { (success, response, error, code) in
//               }
        
        var data = [String:String]()
        var des = ""
       
        if title == "Saved" {
            if JobSeekerSingleton.sharedInstance.dataArray?.last != CONSTANT_SCREEN_NAME.SAVED_SCREEN {
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.SAVED_SCREEN)

            }
            data["eventValue"] = CONSTANT_JOB_SEEKER_EVENT_VALUE.SAVED
            des = CONSTANT_SCREEN_NAME.SAVED_SCREEN
        }else if title == "Applied" {
            if JobSeekerSingleton.sharedInstance.dataArray?.last != CONSTANT_SCREEN_NAME.APPLIED_SCREEN {
                 JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.APPLIED_SCREEN)

            }
            data["eventValue"] = CONSTANT_JOB_SEEKER_EVENT_VALUE.APPLIED
            des = CONSTANT_SCREEN_NAME.APPLIED_SCREEN
        }else if title == "Network" {
            if JobSeekerSingleton.sharedInstance.dataArray?.last != CONSTANT_SCREEN_NAME.NETWORK_SCREEN {
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.NETWORK_SCREEN)

            }
            data["eventValue"] = CONSTANT_JOB_SEEKER_EVENT_VALUE.NETWORK
            des = CONSTANT_SCREEN_NAME.NETWORK_SCREEN
        }
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.TRACK_JOB, data: data, source: "", destination: des) { (success, response, error, code) in

        }

    }

}

//MARK:Navigation Delegation Method
extension MITrackJobsHomeViewController:JobDetailsNavigationDelegate{
    func navigateToJobDetails(jobId:String) {
        let detailsPage=MIJobDetailsViewController()
        detailsPage.jobId=jobId
        detailsPage.delegate=self
        self.navigationController?.pushViewController(detailsPage, animated: true)
    }
}

extension MITrackJobsHomeViewController:JobsAppliedOrSaveDelegate{
    func jobApplied(model: JoblistingData?) {
        
    }
    
    func jobSaveUnsave(model: JoblistingData?, isSaved: Bool) {
        
    }
    
}

