//
//  CGAssetCollectionViewCell.swift
//  CGPhoto
//
//  Created by DY on 2017/12/7.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class CGAssetCollectionViewCell: UIView {

    let imageView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        
        self.setupContentSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CGAssetCollectionViewCell {
    
    func setupContentSubviewsLayout() {
        
        imageView.cg_autoEdgesInsetsZeroToSuperview()
    }
}
