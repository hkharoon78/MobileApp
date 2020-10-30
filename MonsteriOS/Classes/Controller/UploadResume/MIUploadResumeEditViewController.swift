//
//  MIUploadResumeEditViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 13/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import Photos

protocol MIResumeEditDelegate{
    func resumeEditDone(images:[UIImage])
}

class MIUploadResumeEditViewController: UIViewController,MIImagePickerDelegate {
   
    
    @IBOutlet weak var darkView: UIView!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var uploadResumeButton: UIButton!
    @IBOutlet weak var cameraButtonAction: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate:MIResumeEditDelegate!
    var imageArray=[UIImage]()
    var resumeModeVia = "0" //0->Gallery & 1 -> Camera

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadResumeButton.showPrimaryBtn()
        cameraButtonAction.layer.cornerRadius=3
        cameraButtonAction.backgroundColor = AppTheme.defaltBlueColor
        collectionView.register(UINib(nibName: String(describing: MISelectedImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MISelectedImageCollectionViewCell.self))
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.isPagingEnabled=true
      //  let tapGes=UITapGestureRecognizer(target: self, action: #selector(MIUploadResumeEditViewController.dismissController(_:)))
//        tapGes.numberOfTapsRequired=1
//        darkView.addGestureRecognizer(tapGes)
     //   self.title = "Photos"
//        for url in imageUrlArray{
//            if let data = try? Data(contentsOf: url)
//            {
//                if let image: UIImage = UIImage(data: data){
//                    imageArray.append(image)
//                }
//            }
//        }
        self.collectionView.reloadData()
        
    }
//    @objc func dismissController(_ sender:UITapGestureRecognizer){
//        if sender.state == .ended {
//            
//            let touchLocation: CGPoint = sender.location(in: sender.view)
//        
////            if !self.innerView.frame.contains(touchLocation){
////                self.dismiss(animated: true, completion: nil)
////            }
//            
//        }
//        
//    }

    @IBAction func viewButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.dismiss(animated: true, completion: nil)
        case 1:
            var totalSize=0.0
            for img in imageArray{
                totalSize+=self.imageSizePerMB(image: img)
                
            }
            if imageArray.count >= 5{
                self.showAlert(title: "Error!", message: "You can add maximum 5 images.")
            }else{
                self.openCamera()
            }
        case 2:
            if let _dele=self.delegate{
                if self.imageArray.count>0{
                    var totalSize=0.0
                    for img in imageArray{
                        totalSize+=self.imageSizePerMB(image: img)
                    }
                    
                    self.dismiss(animated: true, completion: nil)

                    _dele.resumeEditDone(images: imageArray)
                }else{
                    self.showAlert(title: "", message: "Please add atleast one image for your resume.")
                }
            }
        //    self.callAPIForUploadResume()
            
        default:
            break
        }
    }
    
    func openCamera(){
        if self.resumeModeVia == "0" {
            let vc = MIImagePickerViewController()
            vc.delegate=self
            let nav =  UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }else{
            if UIImagePickerController.isSourceTypeAvailable(.camera){
//                let camera=UIImagePickerController()
//                camera.allowsEditing=false
//                camera.sourceType = .camera
//                camera.delegate=self
//                self.present(camera, animated: true, completion: nil)

            
            //Below commented code is for crop
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
                    
//                    AKAlertController.alert("", message: "You have to authorized Monster App to access camera from your iPhone/iPad. Go to settings and authorize Monster app.", buttons: ["Later","Setting"]) { (alertVC, alertAction, index) in
//                        
//                        if index == 1 {
//                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                                return
//                            }
//                            
//                            if UIApplication.shared.canOpenURL(settingsUrl) {
//                                if #available(iOS 10.0, *) {
//                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                                        print("Settings opened: \(success)") // Prints true
//                                    })
//                                } else {
//                                    // Fallback on earlier versions
//                                    UIApplication.shared.openURL(settingsUrl)
//
//                                }
//                            }
//                        }
//                    }
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
    }
   
    func doneButtonSelected(images:[UIImage]){
        if let img = images.first {
        //    self.imageArray.append(img)

           // Below commented code is for crop

            if #available(iOS 10.0, *) {
                let scanner = ImageScannerController(image: img, delegate: self)
                scanner.shouldScanTwoFaces = false
                present(scanner, animated: false)

            } else {
                // Fallback on earlier versions
                 self.imageArray.append(img)
            }
        }
        self.collectionView.reloadData()

      //  self.presentUpdateResume(images: images)
    }

    func cancelButtonPressed() {
        
    }
}
extension MIUploadResumeEditViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell=collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MISelectedImageCollectionViewCell.self), for: indexPath)as?MISelectedImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image=self.imageArray[indexPath.item]
        cell.deleteAction={
            self.imageArray.remove(at: indexPath.item)
//            if indexPath.item < self.imageUrlArray.count{
//                self.imageUrlArray.remove(at: indexPath.item)
//            }
            self.collectionView.reloadData()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height:70)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
extension MIUploadResumeEditViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image=info[UIImagePickerController.InfoKey.originalImage]as?UIImage{
//            self.imageArray.append(image)
//            self.collectionView.reloadData()
            if #available(iOS 10.0, *) {
                let scanner = ImageScannerController(image: image, delegate: self)
                scanner.shouldScanTwoFaces = false
                present(scanner, animated: false)
                
            } else {
                // Fallback on earlier versions
                self.imageArray.append(image)
            }
        }
        
//        if #available(iOS 11.0, *) {
//            if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
//              //  self.presentUpdateResume(images: [imgUrl])
//                self.imageUrlArray.append(imgUrl)
//            }
//        } else {
//            // Fallback on earlier versions
//            if  let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL{
//               self.imageUrlArray.append(imageURL)
//            }
//        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
@available(iOS 10.0, *)
extension MIUploadResumeEditViewController : ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true)
        if results.doesUserPreferEnhancedImage {
            if let enhanceImg = results.enhancedImage {
                self.imageArray.append(enhanceImg)
            }
        }else {
            self.imageArray.append(results.scannedImage)

        }
        self.collectionView.reloadData()

      //  self.presentUpdateResume(images: [results.scannedImage], imageTakenMode: "1")
        
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
