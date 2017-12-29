//
//  CGPhotoCollectionViewController.swift
//  CGPhoto
//
//  Created by DY on 2017/11/24.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class CGPhotoCollectionViewController: CGBaseViewController, CGPhotoCollectionListDelegate {
    
    fileprivate let photoCollectionView     = CGPhotoCollectionView.init()
    fileprivate let photoCollectionProtocol = CGPhotoCollectionListProtocol.init(cellIdentifier: NSStringFromClass(CGPhotoCollectionViewCell.self), delegate: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if self.photoCollectionView.superview == nil {
            
            self.view.addSubview(self.photoCollectionView)
            
            photoCollectionView.cg_autoEdgesInsetsZero(toSuperviewExcludingEdge: .top)
            if #available(iOS 11.0, *) {
                
                _ = photoCollectionView.cg_Layout(targetView: self.view, edgeOptions: .top)
            } else {
                // Fallback on earlier versions
                photoCollectionView.cg_topLayoutGuide(of: self)
            }
        }
        
        photoCollectionProtocol.estimatedImageSize          = photoCollectionView.estimatedImageSize
        photoCollectionProtocol.delegate                    = self
        
        self.photoCollectionView.collectionView.dataSource  = photoCollectionProtocol
        self.photoCollectionView.collectionView.delegate    = photoCollectionProtocol
        
        self.photoCollectionView.collectionView.register(CGPhotoCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CGPhotoCollectionViewCell.self))
        
        self.loadPhotoCollection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPhotoCollection() {
        
        let photoCollectionResult = CGPhotoManager.defalutManager.photoCollection()
        
        self.photoCollectionProtocol.photoDataSource    = photoCollectionResult
    }
    
    //MARK:- CGPhotoCollectionListDelegate
    func photoCollectionList(obj: CGPhotoCollectionListProtocol, didSelectItemAt indexPath: IndexPath, assetCollection: CGPhotoCollectionModel?) {
        
        let assetCollectionVC = CGPHPhotoViewController.init()
        assetCollectionVC.assetCollectionDataSource = assetCollection
        self.navigationController?.pushViewController(assetCollectionVC, animated: true)
    }
}
