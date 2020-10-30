//
//  MICustomTagCollectionVC.swift
//  MonsteriOS
//
//  Created by Rakesh on 16/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MICustomTagCollectionVC: UIViewController {

    @IBOutlet weak var collection_View:UICollectionView!
    @IBOutlet weak var tbl_View:UITableView!
   
    let dataSource = ["UICollectionView","UITableView","UIViewController","UITableViewDataSource","UITableViewDelegate","UITableViewDelegateweew"]
    var dataSorceSelected = [String]()
    
    private var masterCellId    = "defaultCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpOnLoad()
        // Do any additional setup after loading the view.
    }

    func setUpOnLoad() {
        self.tbl_View.register(UINib(nibName: "MIDefaultSelectionCell", bundle: nil), forCellReuseIdentifier: masterCellId)
        self.collection_View.register(UINib.init(nibName: "MICarrerTipCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MICarrerTipCollectionViewCell")
        

    }

}

extension MICustomTagCollectionVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: masterCellId) as? MIDefaultSelectionCell {
            cell.textLabel?.text = self.dataSource[indexPath.row]
            cell.accessoryType = .none
            cell.tintColor = AppTheme.defaltBlueColor

            if self.dataSorceSelected.contains(self.dataSource[indexPath.row]) {
                cell.accessoryType = .checkmark
                
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSorceSelected.contains(self.dataSource[indexPath.row]) {
            let index = self.dataSorceSelected.firstIndex{$0 == self.dataSource[indexPath.row]}
            self.delete(element:self.dataSource[indexPath.row])

            if self.dataSorceSelected.count > index! {
                self.collection_View.reloadData()
                UIView.animate(withDuration: 2, animations: { [weak self] in
                    self?.collection_View.scrollToItem(at: IndexPath(item:index!+1, section: 0), at: .left, animated: false)
                })

            }
            
        }else{
            self.dataSorceSelected.append(self.dataSource[indexPath.row])
            if self.dataSorceSelected.count > 0 {
                self.collection_View.reloadData()
                UIView.animate(withDuration: 1, animations: { [weak self] in
                    self?.collection_View.scrollToItem(at: IndexPath(item: (self?.dataSorceSelected.count)!-1, section: 0), at: .centeredHorizontally, animated: false)
                })

                
            }
        }
       
    }
    
    func delete(element: String) {
        self.dataSorceSelected = self.dataSorceSelected.filter() { $0 != element }
    }
}

extension MICustomTagCollectionVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSorceSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MICarrerTipCollectionViewCell", for: indexPath) as? MICarrerTipCollectionViewCell {
            cell.carrerTip_Btn.setTitle(dataSorceSelected[indexPath.item], for: .normal)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let obj = dataSorceSelected[indexPath.item]
        return CGSize(width: obj.width(withConstrainedHeight: 40, font: UIFont.customFont(type: .Regular, size: 12))+40, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
