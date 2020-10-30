//
//  MIUploadResumeViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 13/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import MobileCoreServices.UTType
import Photos

class MIUploadResumeViewController: MIBaseViewController {
   
    @IBOutlet weak var mobileiCloudView: UIView!
    @IBOutlet weak var galleryCameraView: UIView!
    @IBOutlet var tapViewCollection: [UIView]!

    var flowVia  = FlowVia.ViaSignUp

    var resumeUploadedAction : ((Bool,String,[String:Any])->Void)?
    var resumePickFrom = "0" //0->Gallery & 1 -> Camera
   
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        mobileiCloudView.addShadow(opacity: 0.5)
        galleryCameraView.addShadow(opacity: 0.5)
      
        for view in tapViewCollection{
            view.isUserInteractionEnabled=true
            let tap=UITapGestureRecognizer(target: self, action: #selector(MIUploadResumeViewController.cellTapped(_:)))
            tap.numberOfTapsRequired=1
            view.addGestureRecognizer(tap)
        }
        self.galleryCameraView.isHidden = !CommonClass.showOCR
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

       // MIUserModel.resetUserResumeData()
        self.title = ControllerTitleConstant.uploadResume
    }

    @objc func cellTapped(_ sender:UITapGestureRecognizer){
        if let tappedTag=sender.view?.tag{
            
            var eventData = [
                "eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK,
                "chooseFile" : "1",
                ] as [String : Any]
            defer {
                if flowVia == .ViaRegister {
                    MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_PERSONAL, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_PERSONAL) { (success, response, error, code) in
                    }
                }
            }
            
            switch tappedTag{
            case 0:
                uploadResume()
                if flowVia == .ViaRegister {
                    CommonClass.googleEventTrcking("registration_screen", action: "upload_resume", label: "mobile")
                }else if flowVia == .ViaPendingResume {
                    CommonClass.googleEventTrcking("profile_screen", action: "upload_resume", label: "mobile")
                }
                eventData["cloudSource"] = "Mobile"

            case 1:
                uploadResume()
                if flowVia == .ViaRegister {
                    CommonClass.googleEventTrcking("registration_screen", action: "upload_resume", label: "icloud")
                }else if flowVia == .ViaPendingResume {
                    CommonClass.googleEventTrcking("profile_screen", action: "upload_resume", label: "icloud")
                }
                eventData["cloudSource"] = "iCloud"

            case 2:
                self.openGallary()
                if flowVia == .ViaRegister {
                    CommonClass.googleEventTrcking("registration_screen", action: "upload_resume", label: "gallery")
                }else if flowVia == .ViaPendingResume {
                    CommonClass.googleEventTrcking("profile_screen", action: "upload_resume", label: "gallery")
                }
                eventData["cloudSource"] = "Gallery"

            case 3:
                self.openCamera()
                if flowVia == .ViaRegister {
                    CommonClass.googleEventTrcking("registration_screen", action: "upload_resume", label: "camera")
                }else if flowVia == .ViaPendingResume {
                    CommonClass.googleEventTrcking("profile_screen", action: "upload_resume", label: "camera")
                }
                eventData["cloudSource"] = "Camera"

            default:
                break
            }
        }
    }
    func uploadResume(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: [ "com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document",kUTTypeRTFD as String ,kUTTypePDF as String], in: .import)
        
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        present(documentPicker, animated: true, completion: nil)
    }
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            DispatchQueue.main.async {
                self.openCustomGalleryController()
            }
        }
    }
    
    func openCustomGalleryController() {
        resumePickFrom = "0"
        let vc = MIImagePickerViewController()
        vc.delegate=self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func openGallary() {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
           self.openCustomGalleryController()
        }else if PHPhotoLibrary.authorizationStatus() == .denied {
            
            
            self.showPopUpView( message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.", primaryBtnTitle: "Setting", secondaryBtnTitle: "Later") { (isprimaryClicked) in
                if isprimaryClicked {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            }
            
            
//            AKAlertController.alert("", message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.", buttons: ["Later","Setting"]) { (alertVC, alertAction, index) in
//
//                if index == 1 {
//                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                        return
//                    }
//
//                    if UIApplication.shared.canOpenURL(settingsUrl) {
//                        if #available(iOS 10.0, *) {
//                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                                print("Settings opened: \(success)") // Prints true
//                            })
//                        } else {
//                            // Fallback on earlier versions
//                        }
//                    }
//                }
//            }
            //   self.showAlert(title: "", message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.")
            
        }else{
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)

        }
        
    }
    
    func openCamera() {
        resumePickFrom = "1"
        //Below commented code is for crop
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied  {
                
                self.showPopUpView( message: "You have to authorized Monster App to access camera from your iPhone/iPad. Go to settings and authorize Monster app.", primaryBtnTitle: "Setting", secondaryBtnTitle: "Later") { (isprimaryClicked) in
                    if isprimaryClicked {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                                UIApplication.shared.openURL(settingsUrl)

                            }
                        }
                    }
                }
                
                
//                AKAlertController.alert("", message: "You have to authorized Monster App to access camera from your iPhone/iPad. Go to settings and authorize Monster app.", buttons: ["Later","Setting"]) { (alertVC, alertAction, index) in
//
//                     if index == 1 {
//                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                            return
//                        }
//
//                        if UIApplication.shared.canOpenURL(settingsUrl) {
//                            if #available(iOS 10.0, *) {
//                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                                    print("Settings opened: \(success)") // Prints true
//                                })
//                            } else {
//                                // Fallback on earlier versions
//                                UIApplication.shared.openURL(settingsUrl)
//
//                            }
//                        }
//                    }
//                }
                //   self.showAlert(title: "", message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.")
                
            }else{
                if #available(iOS 10.0, *) {
                    let scanner = ImageScannerController(delegate: self )
                    scanner.shouldScanTwoFaces = false
                    present(scanner, animated: false)
                    
                } else {
                    //     Fallback on earlier versions
                    let camera=UIImagePickerController()
                    camera.allowsEditing=false
                    camera.sourceType = .camera
                    camera.delegate=self
                    present(camera, animated: true, completion: nil)
                }

            }
        }
      
    }
    
    func callAPIForUploadResume(url:URL) {
        MIActivityLoader.showLoader()
      
        
        var params = [String:Any]()
        if let data = try? Data(contentsOf: url){

            params["file"] = data
            params["parseResume"] = CommonClass.enableResumeParse

            let extenstion = url.pathExtension
            let fileName = url.lastPathComponent.components(separatedBy: ".").first ?? ""

            if !extenstion.isEmpty {
                MIApiManager.callAPIForUploadAvatarResume(path:APIPath.uploadResumeForDocParse , params: params, extenstion: extenstion, filename: fileName, customHeaderParams: [:] ) { (success, response, error, code) in
                    DispatchQueue.main.async {
                        MIActivityLoader.hideLoader()


                    if error == nil && (code >= 200) && (code <= 299){
                            if self.flowVia == .ViaPendingResume {
                                shouldRunProfileApi = true
                                JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.UPLOAD_RESUME]
                                if let action = self.resumeUploadedAction {
                                    if let result = response as? [String:Any] {
                                        action(true,fileName,result)
                                    }
                                }
                                
                                self.showAlert(title: "", message: "File uploaded successfully.", isErrorOccured: false) {
                                    shouldRunProfileApi = true
                                    self.navigationController?.popViewController(animated: true)

                                }
//                                self.showPopUpView(message: "File uploaded successfully.", primaryBtnTitle: "OK") { (_) in
//
//
//
//                                }
                                
//                                AKAlertController.alert("", message:"File uploaded successfully.", buttons: ["OK"]) { (_, _, index) in
//
//                                    shouldRunProfileApi = true
//                                    self.navigationController?.popViewController(animated: true)
//                                }

                            }else{
                                
                                if CommonClass.enableResumeParse {
                                    if let result = response as? [String:Any] {
                                        if let resumePraseData = result["data"] as? [String:Any] {
                                            MIUserModel.getResumeDataParse(data: resumePraseData)
                                        }
                                    }
                                }
                                
                                self.showAlert(title: "", message: "File uploaded successfully.", isErrorOccured: false) {
                                    if let action = self.resumeUploadedAction {
                                                                           if let result = response as? [String:Any] {
                                                                               action(true,(fileName+"."+extenstion),result)
                                                                           }
                                                                       }
                                                                       self.navigationController?.popViewController(animated: true)
                                }
                              
//                                self.showPopUpView(message: "File uploaded successfully.", primaryBtnTitle: "OK") { (_) in
//                                    if let action = self.resumeUploadedAction {
//                                                                           if let result = response as? [String:Any] {
//                                                                               action(true,(fileName+"."+extenstion),result)
//                                                                           }
//                                                                       }
//                                                                       self.navigationController?.popViewController(animated: true)
//                                }
                                
//                                AKAlertController.alert("", message:"File uploaded successfully.", buttons: ["OK"]) { (_, _, index) in
//                                   
//                                    if let action = self.resumeUploadedAction {
//                                        if let result = response as? [String:Any] {
//                                            action(true,(fileName+"."+extenstion),result)
//                                        }
//                                    }
//                                    self.navigationController?.popViewController(animated: true)
//                                  //  self.segueToResumeHeadLine()
//                                }

                            }
                    }else{
                        self.handleAPIError(errorParams: response, error: error)
                    }
                }
                }
            }else {
                self.showAlert(title: "", message: "File format is not correct.")

            }
           
        }else{
            MIActivityLoader.hideLoader()

            self.showAlert(title: "", message: "Please add file to upload.")
        }
    }
    
    func callAPIForUPloadResumeForOCR(images:[UIImage]) {
        MIActivityLoader.showLoader()

        let dataArr = images.map { (image) -> Data in
            MIActivityLoader.hideLoader()
            return image.resizeImage(500).jpegData(compressionQuality: 0.5)  ?? Data()
        }
        
       
        
        MIApiManager.callAPIToUploadMultipleImagesForOCRPDFOption(dataArr: dataArr,flowVia:self.flowVia ) { (sucess, response, error, code) in
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()

                if error == nil && (code >= 200) && (code <= 299){
                    if self.flowVia == .ViaPendingResume {
                        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.UPLOAD_RESUME]
                        shouldRunProfileApi = true
                        
                        if let action = self.resumeUploadedAction {
                            if let result = response as? [String:Any] {
                                action(true,"",result)
                            }
                        }
                        self.showAlert(title: "", message: ExtraResponse.resumeUploaded, isErrorOccured: false) {
                            self.navigationController?.popViewController(animated: true)

                        }
//                        self.showPopUpView(message: ExtraResponse.resumeUploaded, primaryBtnTitle: "OK") { (isPrimarBtnClicked) in
//                            if isPrimarBtnClicked {
//                                self.navigationController?.popViewController(animated: true)
//
//                            }
//                        }
                        
                        
//                        let vPopup = MIJobPreferencePopup.popup()
//                        vPopup.setViewWithTitle(title: "", viewDescriptionText:  ExtraResponse.resumeUploaded, or: "", primaryBtnTitle: "OK", secondaryBtnTitle: "")
//                         vPopup.completionHandeler = {
//                             self.navigationController?.popViewController(animated: true)
//
//                         }
//                         vPopup.cancelHandeler = {
//                                       //   completion(false)
//                                      }
//                         vPopup.addMe(onView: self.view, onCompletion: nil)

//                        AKAlertController.alert("", message:"File uploaded successfully.", buttons: ["OK"]) { (_, _, index) in
//
//                            shouldRunProfileApi = true
//                            self.navigationController?.popViewController(animated: true)
//
//                        }
                        
                        
                    }else{
                        if CommonClass.enableResumeParse {
                            if let result = response as? [String:Any] {
                                if let resumePraseData = result["data"] as? [String:Any] {
                                    MIUserModel.getResumeDataParse(data: resumePraseData)
                                    
                                }
                            }
                        }
                       

                        self.showPopUpView(message: ExtraResponse.resumeUploaded, primaryBtnTitle: "OK") { (isPrimarBtnClicked) in
                            if isPrimarBtnClicked {
                                if let action = self.resumeUploadedAction {
                                    if let result = response as? [String:Any] {
                                                                                action(true,"",result)
                                     }
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                
                            }
                        }
                        
                        
//                       let vPopup = MIJobPreferencePopup.popup()
//                       vPopup.setViewWithTitle(title: "", viewDescriptionText:  ExtraResponse.resumeUploaded, or: "", primaryBtnTitle: "OK", secondaryBtnTitle: "")
//                        vPopup.completionHandeler = {
//                            if let action = self.resumeUploadedAction {
//                                if let result = response as? [String:Any] {
//                                                                            action(true,"",result)
//                                 }
//                                }
//                                self.navigationController?.popViewController(animated: true)
//                            
//                        }
//                        vPopup.cancelHandeler = {
//                                      //   completion(false)
//                                     }
//                        vPopup.addMe(onView: self.view, onCompletion: nil)
                        
//
//
//                       let alert = UIAlertController.init(title: "", message: "File uploaded successfully.", preferredStyle: .alert)
//                        let okAlert = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                            if let action = self.resumeUploadedAction {
//                                if let result = response as? [String:Any] {
//                                    action(true,"",result)
//                                }
//                            }
//                            self.navigationController?.popViewController(animated: true)
//
//                        })
//                        alert.addAction(okAlert)
//                        self.present(alert, animated: true, completion: nil)

                    }
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
                
            }
        }
        
    }

    
}
extension MIUploadResumeViewController: UIDocumentPickerDelegate,MIImagePickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        controller.dismiss(animated: true, completion: nil)
        if self.sizePerMB(url: url) >= 6{
            self.showAlert(title:"Error!", message: "File Size should be less than 6 Mb")
        }else{
            self.callAPIForUploadResume(url: url)
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func doneButtonSelected(images:[UIImage]){
        //Below commented code is for crop

     //   self.presentUpdateResume(images: images, imageTakenMode: resumePickFrom)

        //For Crop feature
        if #available(iOS 10.0, *) {
            if images.first != nil {
                    let scanner = ImageScannerController(image: images.first, delegate: self)
                    scanner.shouldScanTwoFaces = false
                    present(scanner, animated: false)
            }

        } else {
            // Fallback on earlier versions
            self.presentUpdateResume(images: images, imageTakenMode: resumePickFrom)

        }
    }
    func cancelButtonPressed() {
        
    }
    func presentUpdateResume(images: [UIImage] , imageTakenMode:String){
        let vc = MIUploadResumeEditViewController()
        vc.imageArray=images
        vc.delegate=self
        vc.resumeModeVia = imageTakenMode
        vc.modalPresentationStyle = .overCurrentContext
        if self.flowVia == .ViaPendingResume {
            if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
                tabBar.present(vc, animated: true, completion: nil)
            }
        }else{
            self.present(vc, animated: true, completion: nil)
        }
       // self.present(vc, animated: true, completion: nil)
    }
//    func segueToResumeHeadLine(){
//        if MIUserModel.userSharedInstance.userProfessionalType == .Fresher {
//            let vc = MIEducationDetailViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        }else{
//            let vc = MIEmploymentDetailViewController.newInstance
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//    }
}

extension MIUploadResumeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image=info[UIImagePickerController.InfoKey.originalImage]as?UIImage{
            self.presentUpdateResume(images: [image], imageTakenMode: resumePickFrom)

        }

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension MIUploadResumeViewController:MIResumeEditDelegate{
    func resumeEditDone(images: [UIImage]) {
        self.callAPIForUPloadResumeForOCR(images: images)
    }
 
}


extension UIViewController{
    func imageSizePerMB(image: UIImage?) -> Double {
        guard let img = image  else {
            return 0.0
        }
        let data = img.jpegData(compressionQuality: 1)
        let imgSize = data?.count ?? 0
    
        return  Double(imgSize/1000000)
    }
    
    func sizePerMB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
}

@available(iOS 10.0, *)
extension MIUploadResumeViewController : ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true)
        if results.doesUserPreferEnhancedImage {
            if let img = results.enhancedImage  {
                self.presentUpdateResume(images: [img], imageTakenMode: resumePickFrom)

            }
        }else {
            self.presentUpdateResume(images: [results.scannedImage], imageTakenMode: resumePickFrom)

        }
        
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithPage1Results page1Results: ImageScannerResults, andPage2Results page2Results: ImageScannerResults) {
        scanner.dismiss(animated: true)

    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)

    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        scanner.dismiss(animated: true)

    }
    
}
