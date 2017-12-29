//
//  CGAssetCollectionViewCell.swift
//  CGPhoto
//
//  Created by DY on 2017/12/7.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

/// 相片 cell
class CGAssetCollectionViewCell: UICollectionViewCell {

    let imageView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        
        self.setupContentSubviews()
        
        self.setupContentSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

fileprivate extension CGAssetCollectionViewCell {
    
    func setupContentSubviews() {
        
        imageView.setupContentMode(.scaleAspectFill)
    }
    
    func setupContentSubviewsLayout() {
        
        imageView.cg_autoEdgesInsetsZeroToSuperview()
    }
}
