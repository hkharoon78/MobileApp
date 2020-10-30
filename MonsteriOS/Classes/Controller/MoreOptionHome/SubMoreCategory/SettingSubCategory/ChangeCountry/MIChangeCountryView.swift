//
//  MIChangeCountryView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIChangeCountryView: UIView {

    //MARK:Outlets and Variable
    @IBOutlet weak var tableView: UITableView!
    
    var viewController: MISettingHomeViewController?

    var selectedCountry = ""
    
    var tableData = [Site]()
    
    //MARK:Initialiser
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configure()
    }

    func configure(){
        CommonClass.googleAnalyticsScreen(self) //GA for Screen

        self.selectedCountry = AppDelegate.instance.site?.defaultCountryDetails.isoCode ?? ""
        self.tableData = AppDelegate.instance.splashModel.sites

        if AppUserDefaults.value(forKey: .PreviousCountry, fallBackValue: "").stringValue.isEmpty {
            AppUserDefaults.save(value: self.selectedCountry, forKey: .PreviousCountry)
        }
        
        tableView.delegate=self
        tableView.dataSource=self
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.bounces=true
        tableView.tableFooterView=UIView(frame: .zero)
    }


}

//MARK:Table View Delegate and Data Source Implementation
extension MIChangeCountryView:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
            cell?.textLabel?.font = UIFont.customFont(type: .Regular, size: 16)
            cell?.tintColor = Color.colorDefault
            cell?.textLabel?.textColor = UIColor.init(hex: "060606")
        }
        
        let name = self.tableData[indexPath.row].defaultCountryDetails.langOne?.first?.name
        cell?.textLabel?.text = name
        
        let isoCode = self.tableData[indexPath.row].defaultCountryDetails.isoCode
        cell?.accessoryType = (isoCode == self.selectedCountry) ? .checkmark : .none
        cell?.tintColor = AppTheme.defaltBlueColor

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let lbl = AppDelegate.instance.site?.defaultCountryDetails.langOne?.first?.name ?? ""
        CommonClass.googleEventTrcking("settings_screen", action: "change_country", label: lbl) //GA
        
        if CommonClass.isLoggedin() && self.tableData[indexPath.row].defaultCountryDetails.isoCode != self.selectedCountry {
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.CHANGE_COUNTRY, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_CHANGE], source: "", destination: CONSTANT_SCREEN_NAME.CHANGE_COUNTRY) { (success, response, error, code) in
            }
        }else{
            if self.tableData[indexPath.row].defaultCountryDetails.isoCode != self.selectedCountry {
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.CHANGE_COUNTRY, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_CHANGE], destination: CONSTANT_SCREEN_NAME.CHANGE_COUNTRY) { (success, response, error, code) in
                }
            }
            
        }
        
        self.selectedCountry = self.tableData[indexPath.row].defaultCountryDetails.isoCode
        tableView.reloadData()
        
        viewController?.doneNaviButtonAction()
        
        


    }
    
}
