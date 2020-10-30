//
//  MINavigationViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 08/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MINavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set the color of the text for the back buttons.
        self.navigationBar.barTintColor = .white
        self.navigationBar.tintColor = AppTheme.defaltBlueColor //UIColor.colorWith(r: 74, g: 34, b: 137, a: 1)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.colorWith(r: 33, g: 43, b: 54, a: 1),NSAttributedString.Key.font: UIFont.customFont(type: .Semibold, size: 18)]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 16)], for: .normal)
       

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UINavigationController {
    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}
