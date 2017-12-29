//
//  CGAssetCollectionListProtocol.swift
//  CGPhoto
//
//  Created by DY on 2017/12/7.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

typealias CGAssetFetchResultModel = CGPhotoFetchResult

protocol CGAssetCollectionListDelegate : NSObjectProtocol {
    
    func assetCollectionView(manager: CGPhotoCollectionListProtocol, didSelectItemAt indexPath: IndexPath, asset: Any?)
}

/// 相片数据处理
class CGAssetCollectionListProtocol: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var photoDataSource : CGAssetFetchResultModel?
    
    let cellIdentifier : String
    weak var delegate : CGAssetCollectionListDelegate?
    
    var estimatedImageSize = CGSize.zero
    
    init(cellIdentifier: String, delegate: CGAssetCollectionListDelegate?) {
        
        self.cellIdentifier = cellIdentifier
        self.delegate       = delegate
        
        super.init()
    }
    
    //MARK:- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataSource?.assetResult.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath)
        if let assetViewCell = cell as? CGAssetCollectionViewCell {
            
            var targetSize = assetViewCell.imageView.size.scale()
            if targetSize.equalTo(.zero) {
                targetSize  = estimatedImageSize
            }
            
            photoDataSource?.getAsset(index: indexPath.row, targetSize: targetSize, resultHandle: { (assetImage, resultDict) in
                
                assetViewCell.imageView.image   = assetImage
            })
        }
        
        return cell
    }
    
    //MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

