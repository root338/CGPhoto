//
//  CGPhotoFetchOptions.swift
//  CGPhoto
//
//  Created by DY on 2017/11/30.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit
import Photos

class CGPhotoFetchOptions: NSObject {
    
    var assetCollectionType     = PHAssetCollectionType.smartAlbum
    var assetCollectionSubtype  = PHAssetCollectionSubtype.any
    
    /// 过滤 0 张的相册
    var disablePhotosCountIsZero    = true
    
//    /// 需要 相册的照片数
//    var needPhotoCount              = true
    
    var fetchOptions : PHFetchOptions?
}
