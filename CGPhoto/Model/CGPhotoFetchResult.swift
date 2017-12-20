//
//  CGPhotoFetchResult.swift
//  CGPhoto
//
//  Created by DY on 2017/12/4.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit
import Photos

/// 筛选的结果返回
class CGPhotoFetchResult: NSObject {
    
    /// 相册
    let assetCollection: PHAssetCollection
    
    /// 相册对应的图片筛选结果
    let assetResult     : PHFetchResult<PHAsset>
    
    /// 相册的图片
    var assetCount : Int {
        return assetResult.count
    }
    
    /// 相册封面
    var assetCollectionCover : UIImage?
    
    
    init(assetCollection: PHAssetCollection, assetResult: PHFetchResult<PHAsset>) {
        
        self.assetCollection    = assetCollection
        self.assetResult        = assetResult
        super.init()
    }
    
    /// 获取指定大小的封面图片
    func assetCollectionCover(targetSize: CGSize, resultHandle: @escaping CGPHImageResultHandler) -> Void {
        
        guard assetCollectionCover == nil else {
            
            resultHandle(assetCollectionCover, nil)
            return
        }
        
        if let asset = assetResult.firstObject {
            
            _ = CGPhotoManager.defalutManager.requestImage(for: asset, targetSize: targetSize, resultHandler: { [weak weakself = self] (assetImage, resultDict) in
                
                weakself?.assetCollectionCover   = assetImage
                resultHandle(assetImage, resultDict)
            })
        }
    }
    
    
}
