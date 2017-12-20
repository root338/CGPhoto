//
//  CGPHPhotoView.swift
//  CGPhoto
//
//  Created by DY on 2017/12/5.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class CGPHPhotoView: UIView {

    let collectionView : UICollectionView
    
    override convenience init(frame: CGRect) {
        
        let width       = frame.size.width
        let flowLayout  = UICollectionViewFlowLayout.init(maxWidth: width == 0 ? UIScreen.main.bounds.size.width : width, count: 4)
        self.init(frame: frame, flowLayout: flowLayout)
    }
    
    init(frame: CGRect, flowLayout: UICollectionViewFlowLayout) {
        
        collectionView = UICollectionView.init(frame: .init(origin: .zero, size: frame.size), collectionViewLayout: flowLayout)
        super.init(frame: frame)
        
        self.setupContentSubviewsLayout()
        collectionView.backgroundColor  = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CGPHPhotoView {
    
    func setupContentSubviewsLayout() {
        
        collectionView.cg_autoEdgesInsetsZeroToSuperview()
    }
}
