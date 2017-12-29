//
//  CGPhotoCollectionListProtocol.swift
//  CGPhoto
//
//  Created by DY on 2017/11/30.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit
import Photos

typealias CGPhotoCollectionModel = CGPhotoFetchResult

protocol CGPhotoCollectionListDelegate : NSObjectProtocol {
    
    func photoCollectionList(obj: CGPhotoCollectionListProtocol, didSelectItemAt indexPath: IndexPath, assetCollection: CGPhotoCollectionModel?)
}

/// 相册列表数据处理
class CGPhotoCollectionListProtocol: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var photoDataSource : Array<CGPhotoCollectionModel>?
    
    let cellIdentifier: String
    weak var delegate: CGPhotoCollectionListDelegate?
    
    var estimatedImageSize = CGSize.zero
    
    init(cellIdentifier: String, delegate: CGPhotoCollectionListDelegate?) {
        
        self.cellIdentifier = cellIdentifier
        self.delegate       = delegate
        super.init()
    }
    
    //MARK:- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        if let photoCollectionViewCell = cell as? CGPhotoCollectionViewCell, let photoCollectionModel = self.photoDataSource?[indexPath.row] {
            
            photoCollectionViewCell.titleLabel.text         = photoCollectionModel.assetCollection.localizedTitle
            photoCollectionViewCell.photoTotalLabel.text    = "(\(photoCollectionModel.assetResult.count))"
            
            var targetSize = photoCollectionViewCell.imageView.size.scale()
            if targetSize.equalTo(.zero) {
                
                targetSize  = estimatedImageSize
            }
            photoCollectionModel.assetCollectionCover(targetSize: targetSize, resultHandle: { (image, resultDict) in
                photoCollectionViewCell.imageView.image = image
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
    }
    
    //MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let photoCollectionModel = self.photoDataSource?[indexPath.row] {
            self.delegate?.photoCollectionList(obj: self, didSelectItemAt: indexPath, assetCollection: photoCollectionModel)
        }
    }
}

// MARK: - 数据处理
//extension CGPhotoCollectionListProtocol {
//
//    func reset(photoDataSource: Array<CGPhotoCollectionModel>) {
//        self.photoDataSource = photoDataSource
//    }
//
//    func add(photoCollectionList: Array<CGPhotoCollectionModel>) {
//
//        self.photoDataSource.append(contentsOf: photoCollectionList)
//    }
//
//}

