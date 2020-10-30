//
//  MIPopUpVC.swift
//  MonsteriOS
//
//  Created by Anushka on 23/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIPopUpVC: MIBaseViewController {
    
    var card: Card!


    lazy var addPreferedLocationView: MIAddPreferredLocation={
        let prefferedLocation = MIAddPreferredLocation()
        prefferedLocation.viewController = self
        prefferedLocation.card = card
        return prefferedLocation
    }()
    
    lazy var addEducationView: MIAddEducationView={
        let addEducation = MIAddEducationView()
        addEducation.viewController = self
        addEducation.card = card
        return addEducation
    }()
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        switch card.text {
        case "PREFERRED_LOCATION":
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.USER_ENGAGEMENT_PREFERRED_LOCATION)
        case "EDUCATION":
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.USER_ENGAGEMENT_EDUCATION)

        default:
            break
        }

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setUp() {
        switch card.text {
          case "PREFERRED_LOCATION":
            self.navigationItem.rightBarButtonItem = nil
            
            self.view.addSubview(addPreferedLocationView)
            self.addPreferedLocationView.translatesAutoresizingMaskIntoConstraints=false
            
            NSLayoutConstraint.activate([self.addPreferedLocationView.topAnchor.constraint(equalTo:self.view.topAnchor),self.addPreferedLocationView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),self.addPreferedLocationView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),self.addPreferedLocationView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor)])
            
        case "EDUCATION":
            self.navigationItem.rightBarButtonItem = nil
            let view = addEducationView
            self.view.addSubview(view)
            self.addEducationView.translatesAutoresizingMaskIntoConstraints=false
            
            NSLayoutConstraint.activate([self.addEducationView.topAnchor.constraint(equalTo:self.view.topAnchor),self.addEducationView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),self.addEducationView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),self.addEducationView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor)])
        default:
            break
        }
        
    }
    

  
    

}
