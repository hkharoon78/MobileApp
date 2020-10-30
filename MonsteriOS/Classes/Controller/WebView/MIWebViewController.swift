//
//  MIWebViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import WebKit

enum OpenWebView {
    case fromHome
    case fromGleac
    case fromOthers
    case fromHomeGleacReport
}

class MIWebViewController: UIViewController,WKNavigationDelegate{
    
    @IBOutlet weak var progressView: UIProgressView!
    var webView: WKWebView!
    var url = ""
    var summary = ""
    var ttl = ""
    var isforResumeShow = false
    
    var openWebVC: OpenWebView = .fromOthers
    
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    var backToDashboardCallBack: ((Bool)->Void)?
    
    var gleacStaticURL  = "https://www.monsterindia.com/seeker/dashboard"
   // "https://www.monsterindia.com/seeker/dashboard"
    //"https://assessments.gleac.com/result/7b7e557c-1f09-40e8-a9c6-dc49f955d61c"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MICookieHelper.setUpCookiePolicyAndRegisterCookies(forurl: url)
        
        self.extendedLayoutIncludesOpaqueBars = false
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        webView.backgroundColor = .white
        progressView.progressTintColor = AppTheme.defaltBlueColor
        self.view.insertSubview(webView, belowSubview: progressView)
        self.webView.translatesAutoresizingMaskIntoConstraints=false
        
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        self.view.addConstraints([height,width])
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)


        
        if !isforResumeShow {
            if !summary.isEmpty {
                self.webView.loadHTMLString(summary, baseURL: nil)
            } else if URL(string: url) != nil {
                self.createURLRequestWithCookies()
            }
        }
        
        
        if (!MIReachability.isConnectedToNetwork()){
            self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
            self.nojobPopup.addFromTop(onView: self.view, topHeight: 180, onCompletion: nil)
        }
        
        //  self.title = ttl
        webView.setNeedsLayout()
        webView.layoutIfNeeded()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back_bl"), style: .done, target: self, action:#selector(MIWebViewController.backButtonAction(_:)))
        if openWebVC == .fromHome {
            self.navigationItem.backBarButtonItem = backBarBtn
        }else{
            self.navigationItem.leftBarButtonItem = backBarBtn
        }
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.title = self.ttl
        self.navigationItem.title = self.ttl
        
        if ttl == "Detail" {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.JOBDETAIL)
        }else if ttl == "Terms & Conditions" {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.TERMS_CONDITION_SCREEN)
        }else if ttl == "Privacy Policy" {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.PRIVACY_POLICY_SCREEN)

        } else if ttl == "Benchmark Yourself" {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.GLEAC_TEST_SCREEN)
        } else if ttl == "Benchmark Report" {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.GLEAC_VIEW_REPORT_SCREEN)
        }else {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName:"WEB_VIEW_SCREEN")
            
        }
        if isforResumeShow {
            
            //            if
            let urlMain = URL(baseUrl: kBaseUrl, path: "/\(url)", params: ["bucket":"seeker-temporary","path":"/resumes/6bec1aaa-d320-4501-afe7-cb394fbcbf9f/71716291/85872723/resume-1556604157895-1556604159355.pdf"], method: .get) //{
            var urlRequest  = URLRequest(url: urlMain)
          //  URLRequest(url: urlMain, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
            let header = MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: false, extraDic: nil)
            
            if let mHeader = header {
                for hEntity in mHeader {
                    urlRequest.setValue(hEntity.value, forHTTPHeaderField: hEntity.key)
                }
            }
            webView.load(urlRequest)
            //}
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if openWebVC == .fromHome {
            self.navigationItem.backBarButtonItem = nil
        }
         self.navigationItem.title = ""
    }
    
    deinit {
        guard let wb = webView else {return}
        wb.removeObserver(self, forKeyPath: "loading")
        wb.removeObserver(self, forKeyPath: "estimatedProgress")
        wb.removeObserver(self, forKeyPath: "URL")

    }
    
    @objc func backButtonAction(_ sender:UIBarButtonItem){

        if openWebVC == .fromHome {
            CommonClass.googleEventTrcking("covid_page", action: "back_button", label: "")
            self.navigationController?.popViewController(animated: true)
        } else if openWebVC == .fromGleac {
            self.gleacMarkReportApiCall()
            self.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func createURLRequestWithCookies() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
         //   self.url = "https://www.monsterindia.com/middleware/testRoute"
            if let urlpage =  URL(string: self.url) {
                var urlRequest = URLRequest(url: urlpage, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)
                //URLRequest(url:urlpage)
                if CommonClass.isLoggedin() {
                    urlRequest.httpShouldHandleCookies = true
                    urlRequest.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies ?? [])
                }
                self.webView.load(urlRequest)
            }
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
       
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        
        if isforResumeShow {
            webView.frame = CGRect(x: 0, y: 64, width: kScreenSize.width, height: kScreenSize.height-64)
        }
        
        print("Invoked when a main frame navigation completes.")
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        
        
        let url = navigationAction.request.url
        var newurlstr = url?.absoluteString
        newurlstr = newurlstr?.removingPercentEncoding ?? ""
        

        if openWebVC == .fromGleac  || openWebVC == .fromHomeGleacReport{
             self.backToDashboard(newurlstr ?? "") //  click on  gleac report back to dashboard
             //return
         }
 
        if newurlstr?.range(of: "career-advice") != nil {
            CommonClass.googleEventTrcking("covid_page", action: "covid_career-advice", label: "")
        }
        
        if newurlstr?.range(of: "jobTypes=") != nil {
            
            if let afterJobType = newurlstr?.range(of: "jobTypes=") {
                if let jobType = newurlstr?[afterJobType.upperBound...] {
                    
                    if let index = (jobType.range(of: "&")?.lowerBound) {
                        let type =  String(jobType.prefix(upTo: index))
                        
                        if type == "jobs for covid-19 layoffs" {
                            
                            CommonClass.googleEventTrcking("covid_page", action: "covid_support_view_all", label: "")
                            let vc = MISRPJobListingViewController()
                            vc.jobTypes = .covid19Layoffs
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        } else if type == "work from home" {
                            
                            CommonClass.googleEventTrcking("covid_page", action: "wfh_view_all", label: "")
                            let vc = MISRPJobListingViewController()
                            vc.jobTypes = .workFromHome
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        decisionHandler(.cancel)
                        return
                    }
                }
            }
        } else  if newurlstr?.range(of: "skills=") != nil {
             if let afterQueryType = newurlstr?.range(of: "skills=") {
                 if let queryType = newurlstr?[afterQueryType.upperBound...] {
                     
                     if let index = (queryType.range(of: "&")?.lowerBound) {
                         let type =  String(queryType.prefix(upTo: index))
                         
                         CommonClass.googleEventTrcking("covid_page", action: "top_skill", label: type)
                         
                         let vc = MISRPJobListingViewController()
                         //vc.selectedSkills = type
                         vc.skillsWeb = type
                         vc.openSRPVC = .fromwebview
                         self.navigationController?.pushViewController(vc, animated: false)
                         decisionHandler(.cancel)
                         return
                     }
                 }
             }
         } else  if newurlstr?.range(of: "companyId=") != nil {
            if let afterCompType = newurlstr?.range(of: "companyId=") {
                if let compType = newurlstr?[afterCompType.upperBound...] {
                    
                    if let index = (compType.range(of: "&")?.lowerBound) {
                        let compId =  String(compType.prefix(upTo: index))
                        
                        self.callCompanyDetails(compId)
                        
                        decisionHandler(.cancel)
                        return
                    }
                }
            }
        }
      
        
        switch navigationAction.navigationType {
        case .linkActivated:
            if navigationAction.targetFrame == nil {
                self.webView?.load(navigationAction.request)
            }
        default:
            break
        }
        
        decisionHandler(.allow)
        
    }
  
    
    func backToDashboard(_ newurlstr: String){
        if newurlstr == self.gleacStaticURL{
            if openWebVC != .fromHomeGleacReport {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PendingActionGleacCallBack"), object: nil)
                self.gleacMarkReportApiCall()
            }
              self.dismiss(animated: true, completion: nil)
        }
    }
    
}


extension MIWebViewController {
    
    func gleacMarkReportApiCall() {
        MIApiManager.hitGleacMarkReporttAPI { (success, response, error, code) in
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .pendingActionGleacCall, object: nil)
          }
      }
    
    }
    
    //compnay details API
    func callCompanyDetails(_ compId: String) {
        
        MIActivityLoader.showLoader()
        MIApiManager.hitCompanyDetailsAPI(compId) { (success, response, error, code) in
            
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                
                if let response = response as? JSONDICT {
                  let compDetail = Company.init(dictionary: response as NSDictionary)
                    
                    if error == nil{
                        let comData = MIRecruiterDetailsViewController()
                        comData.compOrRecId = compId
                        comData.recuterOrCompanyType = .company
                        
                         let jobData=JoblistingData()
                        jobData.company = compDetail
                        
                        comData.jobModel = jobData
                        comData.jobModel?.isCompanyFollow = compDetail?.isCompanyFollow
                        self.navigationController?.pushViewController(comData, animated: true)
                    }

                } else {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.toastView(messsage: ExtraResponse.noInternet)
                    }
                }
            }
        }
    }
    
}

 


