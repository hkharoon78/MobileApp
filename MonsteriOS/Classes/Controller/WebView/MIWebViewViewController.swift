//
//  MIWebViewViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 11/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import WebKit
class MIWebViewViewController: MIBaseViewController {
    
    var webView:WKWebView!
    var url = ""
    var summary = ""
    var ttl = ""
    var youtubeVideo=false
    lazy var  activityIndicator:UIActivityIndicatorView={
        let activity=UIActivityIndicatorView()
        activity.hidesWhenStopped=true
        activity.color = AppTheme.defaltTheme
        return activity
    }()
    override func loadView() {
        super.loadView()
        webView=WKWebView()
        webView.navigationDelegate=self
        webView.allowsBackForwardNavigationGestures=true
        self.view=webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.setUI()
        
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .done, target: self, action:#selector(MIWebViewViewController.backButtonAction(_:)))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress < 1{
                activityIndicator.startAnimating()
            }else{
                activityIndicator.stopAnimating()
            }
        }
    }
    deinit {
        self.webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    @objc func backButtonAction(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    func setUI()  {
        self.view.backgroundColor = UIColor.white
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
        if !summary.isEmpty {
          self.webView.loadHTMLString(summary, baseURL: nil)
        } else if let httpUrl = URL(string: url) {
                self.webView.load(URLRequest(url: httpUrl))
            
        }
        self.title = ttl
    }
    
    
   
   
}

extension MIWebViewViewController:WKNavigationDelegate{
   
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       self.activityIndicator.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
    }
    
}


