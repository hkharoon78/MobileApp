//
//  MIStaticMasterDataViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 08/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MIStaticMasterDataSelectionDelegate:class {
    func staticMasterDataSelected(selectedData:[String],masterType:String)
}

class MIStaticMasterDataViewController: UIViewController {
    
    @IBOutlet weak var tblView : UITableView!
    
    private var masterCellId    = "defaultCell"
    var staticMasterDataArray = [String]()
    var selectedDataArray = [String]()
    var staticMasterType        = StaticMasterData.PASSINGYEAR
    weak var delagate : MIStaticMasterDataSelectionDelegate?
    var selectedData: ((String)->Void)?
    class var newInstance: MIStaticMasterDataViewController {
        get {
            return MIStaticMasterDataViewController()
        }
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = staticMasterType.staticMasterDataTitle
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.selectedDataArray.count > 0 {
            self.poptoPreviousController(value: self.selectedDataArray.first ?? "")
            
        }else{
            self.poptoPreviousController(value: "")
            
        }
    }
    //MARK: - Helper Methods
    func setUpView() {
        
        self.title = staticMasterType.staticMasterDataTitle
        self.tblView.register(UINib(nibName: "MIDefaultSelectionCell", bundle: nil), forCellReuseIdentifier: masterCellId)
        self.staticMasterDataArray = staticMasterType.dataListValues
        self.tblView.tableFooterView = UIView()
        
        if staticMasterType == .CURRENCY && self.staticMasterDataArray.isEmpty {
            self.updateCurrencyData()
        }
    }
    
    func removeSelectedObject(value:String) {
        selectedDataArray = selectedDataArray.filter({ ($0 != value)})
    }
    //MARK: - Button Actions Methods
    
    func updateCurrencyData() {
        MIActivityLoader.showLoader()
        MIApiManager.splashMasterDataAPI(.CURRENCY) { (result, error) in
            MIActivityLoader.hideLoader()
            if let currencies = result?.currencies {
                AppDelegate.instance.splashModel.currencies = currencies
                AppDelegate.instance.splashModel.commit()
                
                self.staticMasterDataArray = self.staticMasterType.dataListValues
                self.tblView.reloadData()
                
            }
        }
    }
}

extension MIStaticMasterDataViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staticMasterDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: masterCellId) as? MIDefaultSelectionCell {
            
            if staticMasterType == .SALARYINLAKH || staticMasterType == .SALARYINTHOUSAND {
                if self.staticMasterDataArray[indexPath.row].isNumeric {
                    if let value = Int(self.staticMasterDataArray[indexPath.row])?.formattedWithSeparator {
                        cell.textLabel?.text = value + " " + staticMasterType.masterDataUnit
                    }
                }
            }else{
                cell.textLabel?.text = "\(self.staticMasterDataArray[indexPath.row]) \(staticMasterType.masterDataUnit)"
                
            }
            cell.textLabel?.font = UIFont.customFont(type: .Regular, size: 14)
            cell.accessoryType = .none
            cell.tintColor = AppTheme.defaltBlueColor
            if self.selectedDataArray.contains(self.staticMasterDataArray[indexPath.row]) {
                cell.accessoryType = .checkmark
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let value = staticMasterDataArray[indexPath.row]
        if self.selectedDataArray.contains(value){
            self.selectedDataArray.removeAll()
            self.tblView.reloadData()
        }else{
            self.poptoPreviousController(value: value)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func poptoPreviousController(value: String) {
        self.selectedDataArray.removeAll()
        if !value.isEmpty {
            self.selectedDataArray.append(value)
        }
        self.selectedData?(value)
        if self.delagate != nil {
            self.delagate?.staticMasterDataSelected(selectedData: self.selectedDataArray, masterType: staticMasterType.rawValue)
        }
    }
}
