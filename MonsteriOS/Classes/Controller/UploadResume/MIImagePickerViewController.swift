//
//  MIImagePickerViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 13/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import Photos

protocol MIImagePickerDelegate{
    func doneButtonSelected(images:[UIImage])
    func cancelButtonPressed()
    
}
extension MIImagePickerDelegate{
    func doneButtonSelected(images:[UIImage]){}
}
class MIImagePickerViewController: MIBaseViewController {
    
    let manager = PHCachingImageManager()
    var selectedAssets = [String:PHAsset]() // = []
    var assetsCollection = PHAssetCollection()
    private var assets: [PHAsset] = []
//    {
//        willSet{
//            manager.stopCachingImagesForAllAssets()
//        }
//        didSet{
//            manager.startCachingImages(for: self.assets, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil)
//
//        }
//    }
    private var selectedImg: [UIImage]=[]

    var delegate:MIImagePickerDelegate!
    @IBOutlet weak var collectionView: UICollectionView!
    var totalSize=0.0
    var totalSelectedImgs = 0
    @IBOutlet weak var navigationItemCustom: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: String(describing: MIImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MIImageCollectionViewCell.self))
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.allowsMultipleSelection = true
        self.title = "Photos"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction(_:)))
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .done, target: self, action:#selector(cancelAction(_:)))
       // PHPhotoLibrary.shared().register(self)


    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            DispatchQueue.main.async {
                self.fetchAssets()
            }
        }
        else {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func fetchAssets() {
        self.assets.removeAll()
        //DispatchQueue.global(qos: .userInteractive).async {
            let options = PHFetchOptions()
            options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
            let results = PHAsset.fetchAssets(with: .image, options: options)
            results.enumerateObjects { (object, _, _) in
                
                self.assets.append(object)
            }
        
           self.collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationItemCustom.title=ControllerTitleConstant.photos
//        self.navigationItemCustom.leftBarButtonItem?.title=NavigationBarButtonTitle.cancel
//        self.navigationItemCustom.rightBarButtonItem?.title=NavigationBarButtonTitle.done
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
            fetchAssets()
        }
        else
        {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }

    @objc func doneAction(_ sender: Any) {
        if selectedAssets.count > 0 {
            
            var selectedImages = [UIImage]()
            
            let dispatchGroup = DispatchGroup()
            self.startActivityIndicator()
            for (_ , value) in selectedAssets {
                dispatchGroup.enter()
                self.getImageFromPhasset(asset: value, size: CGSize(width: 900, height: 900)) { (image) in
                    dispatchGroup.leave()
                    if let img = image {
                        selectedImages.append(img)
                    }
                }
                
            }
            dispatchGroup.notify(queue: DispatchQueue.main) {
                self.stopActivityIndicator()
                
                self.dismiss(animated: true, completion: nil)
                if let _dele=self.delegate{
                    if selectedImages.count>0{
                        _dele.doneButtonSelected(images: selectedImages)
                        
                    }
                }
            }
        }else{
            self.showAlert(title: "", message: "You have to select atleast one image.")

           
        }
        
        
   
    }
    
    @objc func cancelAction(_ sender: Any) {
        if let _dele=self.delegate{
            _dele.cancelButtonPressed()
        }
        self.dismiss(animated: true, completion: nil)
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
extension MIImagePickerViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell=collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MIImageCollectionViewCell.self), for: indexPath)as? MIImageCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.phAsset=self.assets[indexPath.item]

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        return CGSize(width: yourWidth, height:100.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        if totalSelectedImgs >= 1 {
//            self.showAlert(title: "Error!", message: "You can select maximum 5 images.")
//            return false
//        }
        
        if let cell=collectionView.cellForItem(at: indexPath)as?MIImageCollectionViewCell{
            if let imageurl=cell.imageView.image{
                if self.imageSizePerMB(image: imageurl) >= 6 {
                    return false
                }
                
            }
        }
        selectedAssets.removeAll()
        totalSelectedImgs = 0
        if let selectedItems = self.collectionView.indexPathsForSelectedItems {
            for indexPath in selectedItems {
                
                self.collectionView.deselectItem(at: indexPath, animated:true)
                
            }
        }
        return  true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        if totalSelectedImgs < 2 {
            if let cell=collectionView.cellForItem(at: indexPath)as?MIImageCollectionViewCell{
              // let phAssets =  self.assets[indexPath.item]
                selectedAssets["\(indexPath.row)"] = cell.phAsset
                if let imageurl=cell.imageView.image{
                    totalSize+=self.imageSizePerMB(image: imageurl)
                    totalSelectedImgs += 1
                    
                }
            }
        }else{
            self.showAlert(title: "Error!", message: "You can select maximum 5 images.")
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell=collectionView.cellForItem(at: indexPath)as?MIImageCollectionViewCell{
            selectedAssets.removeValue(forKey: "\(indexPath.row)")
            if let imageurl=cell.imageView.image{
                totalSize -= self.imageSizePerMB(image: imageurl)
                totalSelectedImgs -= 1
                
            }
        }
    }
    func getImageFromPhasset(asset:PHAsset,size:CGSize, completion: @escaping ((UIImage?)->Void) ) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            completion(result)
        })
    }
    
}

@available(iOS 10.0, *)
extension MIImagePickerViewController : ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true)
//        if results.doesUserPreferEnhancedImage {
//            if let enhanceImg = results.enhancedImage {
//                self.imageArray.append(enhanceImg)
//            }
//        }else {
//            self.imageArray.append(results.scannedImage)
//
//        }
//        self.collectionView.reloadData()
        
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

extension MIImagePickerViewController :  PHPhotoLibraryChangeObserver{
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        //changeInstance.changeDetails(for: assetsCollection)
    }
    
}
