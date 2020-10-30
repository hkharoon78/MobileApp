//
//  MISuggestionViewController.swift
//  MonsteriOS
//
//  Created by Monster on 17/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISuggestionViewController: MIBaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
    
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.collectionView.register(UINib(nibName: "MISuggestionCollectionCell", bundle: nil), forCellWithReuseIdentifier: "suggestioncell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 20, height: 20)
			flowLayout.minimumInteritemSpacing = 10
        }
		
		self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUI() {
        let sugView = MISuggestionView.suggestionView
	//	print("starting \(sugView.frame)")
        sugView.show(ttl: "Testing for iOS Developer")
		sugView.frame.size.width = sugView.titleLbl.frame.size.width + 40
	//	print(sugView.frame)
        testView.addSubview(sugView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "suggestioncell", for: indexPath) as! MISuggestionCollectionCell
        if indexPath.row == 0 {
            cell.show(ttl: "c sharp")
        } else if indexPath.row == 1{
            cell.show(ttl: "iOS")
        } else if indexPath.row == 2{
            cell.show(ttl: "")
        } else if indexPath.row == 3{
            cell.show(ttl: "C#")
        } else if indexPath.row == 4{
            cell.show(ttl: "Objective c")
        } else if indexPath.row == 7{
            cell.show(ttl: "swift")
        } else if indexPath.row == 5{
            cell.show(ttl: "iOS Swift Developer")
        } else {
            cell.show(ttl: ".Net")
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
	
}

