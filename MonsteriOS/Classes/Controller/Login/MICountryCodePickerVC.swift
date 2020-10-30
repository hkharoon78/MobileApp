//
//  MICountryCodePickerVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 10/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MICountryCodePickerVC: UIViewController {
    
    let tableView = UITableView()
    lazy var searchBar:MISearchBar = MISearchBar(frame:CGRect(x: 0, y: 0, width:Double(self.view.frame.size.width-60), height: 30))
    private var countryCodes = [CountryModel]()
    
    var countryCodeSeleted: ((CountryModel)->())?
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //   self.title = "Select Country"
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: String(describing: MICountryPickerTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MICountryPickerTableCell.self))
        tableView.delegate=self
        tableView.dataSource=self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search here..."
        searchBar.delegate = self
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        
        self.countryCodes = AppDelegate.instance.splashModel.countries ?? []

        if self.countryCodes.isEmpty {
            MIActivityLoader.showLoader()
            MIApiManager.splashMasterDataAPI(.COUNTRY) { (result, error) in
                MIActivityLoader.hideLoader()
                if let countries = result?.countries {
                    AppDelegate.instance.splashModel.countries = countries
                    AppDelegate.instance.splashModel.commit()
                    
                    self.countryCodes = countries
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
}

extension MICountryCodePickerVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MICountryPickerTableCell") as! MICountryPickerTableCell
        
        let rowData = self.countryCodes[indexPath.row]
        let name = (rowData.langOne?.first?.name ?? "")
        cell.nameLabel.text = [name + " - " + (rowData.isoCode)].joined(separator: "")
        cell.codeLabel.text = "+" + rowData.callPrefix.stringValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.countryCodeSeleted?(self.countryCodes[indexPath.row]   )
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension MICountryCodePickerVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        let predicate = NSCompoundPredicate(
//            type: .or,
//            subpredicates: [
//                NSPredicate(format: "langOne.name BEGINSWITH[cd] %@", searchText),
//                NSPredicate(format: "isoCode BEGINSWITH[cd] %@", searchText),
//                NSPredicate(format: "callPrefix CONTAINS[cd] %@", searchText)
//            ]
//        )
        
        if searchText.isEmpty {
            self.countryCodes = AppDelegate.instance.splashModel.countries ?? []
        } else {
            self.countryCodes = AppDelegate.instance.splashModel.countries?.filter({ (country) -> Bool in
                return (country.langOne?.first?.name ?? "").lowercased().hasPrefix(searchText.lowercased()) || (country.isoCode.lowercased().hasPrefix(searchText.lowercased())) || (country.callPrefix.stringValue.lowercased().hasPrefix(searchText.lowercased()))
            }) ?? []
        }
        self.tableView.reloadData()
        
        
        //self.getCountryData(searchText.isEmpty ? nil : predicate)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
