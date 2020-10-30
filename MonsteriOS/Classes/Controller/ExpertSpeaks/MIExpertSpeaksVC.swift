//
//  MIExpertSpeaksVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 02/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIExpertSpeaksVC: UIViewController {

    let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName:String(describing: MIExpertSpeaksTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIExpertSpeaksTableCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.showsVerticalScrollIndicator=false
        
        self.title = "Expert Speaks"
    }
    
}


extension MIExpertSpeaksVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MIExpertSpeaksTableCell", for: indexPath) as! MIExpertSpeaksTableCell
        
        let tempURL = "https://img.youtube.com/vi/q7SBRS5jrwU/0.jpg"
        cell.speakersImageView.setImage(with: tempURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = YTPlayerVC.instantiate(fromAppStoryboard: .Main)
        vc.videoID = "q7SBRS5jrwU"
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
}
