//
//  MISelectCityPopup.swift
//  MonsteriOS
//
//  Created by Piyush on 19/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISelectCityPopup: MIPopupView,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    
    private var cities = ["Bangalore","Chennai","Delhi","Hyderabad","Mumbai","Agra","Greater Noida UP West 201303 Nearest to Noida","Mumbai"]
    var strArray = [String]()
    private var citiesInfo = [MILocationInfo]()
    private var cellId = "locationCell"
    
    class func popup() -> MISelectCityPopup {
        let header = UINib(nibName: "MISelectCityPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MISelectCityPopup
        header.setUI()
        return header
    }
    
    func setUI() {
        self.topView.roundCorner(0, borderColor: nil, rad: 8)
        self.nextBtn.roundCorner(0, borderColor: nil, rad: CornerRadius.btnCornerRadius)
        self.shouldRemoveOnTouch = false
        self.tblView.register(UINib(nibName: "MILocationCell", bundle: nil), forCellReuseIdentifier: cellId)
        citiesInfo.removeAll()
        for index in 0..<cities.count {
            let info = MILocationInfo(with: cities[index])
            citiesInfo.append(info)
        }
        self.tblView.reloadData()
    }
    
    @IBAction func closeClicked(_ sender: UIButton) {
        self.removeMe()
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MILocationCell {
            let info = citiesInfo[indexPath.row]
            cell.show(info: info)
            if strArray.contains(info.name) {
                cell.rightImgView.image = UIImage(named: "checkbox_clicked")
            } else {
                cell.rightImgView.image = UIImage(named: "checkbox_default")
            }
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = citiesInfo[indexPath.row]
        if strArray.contains(info.name) {
            self.delete(element: info.name)
        } else {
            strArray.append(info.name)
        }
        self.tblView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func delete(element: String) {
        strArray = strArray.filter() { $0 != element }
    }
}
