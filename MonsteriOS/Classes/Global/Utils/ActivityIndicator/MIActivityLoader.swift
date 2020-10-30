//
//  AKLoader.swift
//  
//


import UIKit

class MIActivityLoader {
    
    static func showLoader(){
        loader.start()
    }
    static func hideLoader(){
        loader.stop()
    }
}

private let loader = __Loader(frame: CGRect(x:0, y:0, width:0, height:0))
private class __Loader : UIView {
    
    lazy var activityIndicator: MIActivityIndicator = {
        let activity = MIActivityIndicator(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        activity.center = self.center
        self.addSubview(activity)
        return activity
    }()
    
    var isLoading = false
    
    override init(frame: CGRect) {
        super.init(frame: UIApplication.shared.keyWindow!.bounds)
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.50)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder has not been implemented")
    }
    
    func start() {
        
        if self.isLoading { return }
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.activityIndicator.startAnimating()
        
        self.isLoading = true
    }
    
    func stop() {
        
        self.activityIndicator.stopAnimating()
        self.removeFromSuperview()
        self.isLoading = false
    }
}

