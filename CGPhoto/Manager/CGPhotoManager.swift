//
//  CGPhotoManager.swift
//  CGPhoto
//
//  Created by DY on 2017/11/10.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit
import Photos

typealias CGPHImageRequestID      = PHImageRequestID
typealias CGPHImageResultHandler  = (UIImage?, Dictionary<AnyHashable, Any>?) -> Void

class CGPhotoManager: NSObject {

    static let defalutManager = CGPhotoManager.init()
    
//    var photoAuthorizationStatus : PHAuthorizationStatus {
//        return currentAuthorizationStatus
//    }
    
    //MARK:- 私有属性
//    fileprivate var currentAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    
//    fileprivate let photoLibrary = PHPhotoLibrary.shared()
    
    //MARK:- 公共方法
    let fetchOptions = CGPhotoFetchOptions.init()
    
}

// MARK: - 授权处理
extension CGPhotoManager {
    
    //MARK:- 权限处理
    func requestPhotoAuthorization(handle: @escaping (_ status: PHAuthorizationStatus) -> Void) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization(handle)
        }else {
            handle(status)
        }
    }
}

// MARK: - PHAssetCollection 处理
extension CGPhotoManager {
    
    //MARK:- 相册处理
    func photoCollection() -> Array<CGPhotoFetchResult> {
        
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: fetchOptions.assetCollectionType, subtype: fetchOptions.assetCollectionSubtype, options: fetchOptions.fetchOptions)
        
        var photoFetchResultArray   = [CGPhotoFetchResult]()
        fetchResult.enumerateObjects { (assetCollection, index, pointer) in
            
            let assetResult         = self.asset(assetCollection: assetCollection)
            
            if !self.fetchOptions.disablePhotosCountIsZero || assetResult.count > 0 {
                let photoFetchResult = CGPhotoFetchResult.init(assetCollection: assetCollection, assetResult: assetResult)
                photoFetchResultArray.append(photoFetchResult)
            }
        }
        
        return photoFetchResultArray
    }
    
}

// MARK: - PHAsset 处理
extension CGPhotoManager {
    
    //MARK:- 相片处理
    func asset() -> PHFetchResult<PHAsset> {
        
        let fetchResult = PHAsset.fetchAssets(with: nil)
        
        return fetchResult
    }
    
    func asset(assetCollection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        
        let fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
        return fetchResult
    }
}

extension CGPhotoManager {
    
    func requestImage(for asset: PHAsset, targetSize: CGSize, resultHandler: @escaping CGPHImageResultHandler) -> CGPHImageRequestID {
        
        return PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: resultHandler)
    }
    
}
