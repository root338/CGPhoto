//
//  CGPhotoCollectionViewController.swift
//  CGPhoto
//
//  Created by DY on 2017/11/24.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class CGPhotoCollectionViewController: UIViewController, CGPhotoCollectionListDelegate {
    
    fileprivate let photoCollectionView     = CGPhotoCollectionView.init()
    fileprivate let photoCollectionProtocol = CGPhotoCollectionListProtocol.init(cellIdentifier: NSStringFromClass(CGPhotoCollectionViewCell.self), delegate: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if self.photoCollectionView.superview == nil {
            
            self.view.addSubview(self.photoCollectionView)
            
            if #available(iOS 11.0, *) {
                _ = self.photoCollectionView.cg_Layout(targetView: self.view, edgeOptions: .allEdge)
            } else {
                // Fallback on earlier versions
                self.photoCollectionView.cg_autoEdgesInsetsZero(to: self)
            }
        }
        
        self.photoCollectionView.collectionView.dataSource = photoCollectionProtocol
        self.photoCollectionView.collectionView.delegate   = photoCollectionProtocol
        
        self.loadPhotoCollection()
        self.view.backgroundColor   = UIColor.white
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
        
    }
}
