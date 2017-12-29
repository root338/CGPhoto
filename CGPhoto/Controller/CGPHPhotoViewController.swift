//
//  CGPHPhotoViewController.swift
//  CGPhoto
//
//  Created by DY on 2017/12/5.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class CGPHPhotoViewController: CGBaseViewController, CGAssetCollectionListDelegate {

    var assetCollectionDataSource: CGPhotoFetchResult!
    let assetCollectionProtocolManager = CGAssetCollectionListProtocol.init(cellIdentifier: NSStringFromClass(CGAssetCollectionViewCell.self), delegate: nil)
    
    fileprivate let assetsView = CGPHPhotoView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if assetsView.superview == nil {
            self.view.addSubview(assetsView)
            assetsView.cg_autoEdgesInsetsZero(toSuperviewExcludingEdge: .top)
            if #available(iOS 11.0, *) {
                
                _ = assetsView.cg_Layout(targetView: self.view, edgeOptions: .top)
            } else {
                
                assetsView.cg_topLayoutGuide(of: self)
            }
        }
        
        assetCollectionProtocolManager.delegate             = self
        assetCollectionProtocolManager.estimatedImageSize   = assetsView.estimatedImageSize
        assetCollectionProtocolManager.photoDataSource      = assetCollectionDataSource
        
        assetsView.collectionView.delegate      = assetCollectionProtocolManager
        assetsView.collectionView.dataSource    = assetCollectionProtocolManager
        
        assetsView.collectionView.register(CGAssetCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CGAssetCollectionViewCell.self))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- CGAssetCollectionListProtocol
    func assetCollectionView(manager: CGPhotoCollectionListProtocol, didSelectItemAt indexPath: IndexPath, asset: Any?) {
        
    }
    
}
