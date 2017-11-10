//
//  CGPhotoManager.swift
//  CGPhoto
//
//  Created by DY on 2017/11/10.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit
import Photos

class CGPhotoManager: NSObject {

    static let defalutManager = CGPhotoManager.init()
    
//    var photoAuthorizationStatus : PHAuthorizationStatus {
//        return currentAuthorizationStatus
//    }
    
    //MARK:- 私有属性
//    fileprivate var currentAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    
//    fileprivate let photoLibrary = PHPhotoLibrary.shared()
    
    //MARK:- 公共方法
    
    //MARK:- 权限处理
    func requestPhotoAuthorization(handle: @escaping (_ status: PHAuthorizationStatus) -> Void) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization(handle)
        }else {
            handle(status)
        }
    }
    
    //MARK:- 相册处理
    func photoCollection() -> PHFetchResult<PHAssetCollection> {
        
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: .any, options: nil)
        return fetchResult
    }
    
    //MARK:- 相片处理
    func assetList() -> PHFetchResult<PHAsset> {
        
        let fetchResult = PHAsset.fetchAssets(with: nil)
        return fetchResult
    }
}
