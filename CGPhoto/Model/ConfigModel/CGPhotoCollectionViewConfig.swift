//
//  CGPhotoCollectionViewConfig.swift
//  CGPhoto
//
//  Created by DY on 2017/11/30.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

enum CGPhotoCollectionViewCellStyle {
    case `default`
}

struct CGPhotoCollectionViewConfig {
    
    var title : String  = "照片"
    
    var leftTitle : String?
    var rightTitle : String?
    
    var photoCollectionViewCellConfig: CGPhotoCollectionViewCellConfig?
}

/// 相片相册视图的配置
struct CGPhotoCollectionViewCellConfig {
    
    var style = CGPhotoCollectionViewCellStyle.default
    
    var titleFont   : UIFont?
    var titleColor  : UIColor?
    
    var photoCountFont  : UIFont?
    var photoCountColor : UIColor?
    
    var imageContentMode    = UIViewContentMode.scaleAspectFill
    var cornerRadius        = CGFloat(0)
}
