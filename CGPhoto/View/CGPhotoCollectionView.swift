//
//  CGPhotoCollectionView.swift
//  CGPhoto
//
//  Created by DY on 2017/11/24.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class CGPhotoCollectionView: UIView {

    let collectionView : UICollectionView
    
    var estimatedImageSize : CGSize {
        
        return itemSize.scale()
    }
    
    fileprivate var itemSize : CGSize
    
    override convenience init(frame: CGRect) {
        
        let width       = frame.size.width
        let flowLayout  = UICollectionViewFlowLayout.init(itemSize: .init(width: width == 0 ? UIScreen.main.bounds.size.width : width, height: 50))
        self.init(frame: frame, layout: flowLayout)
    }
    
    init(frame: CGRect, layout: UICollectionViewLayout) {
        
        collectionView = UICollectionView.init(frame: .init(origin: .zero, size: frame.size), collectionViewLayout: layout)
        if let flowLayout = layout as? UICollectionViewFlowLayout {
            itemSize    = flowLayout.itemSize
        }else {
            itemSize    = CGSize.zero
        }
        
        super.init(frame: frame)
        
        self.addSubview(collectionView)
        
        self.setupContentViewLayout()
        
        collectionView.backgroundColor  = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置布局
fileprivate extension CGPhotoCollectionView {
    
    func setupContentViewLayout() {
        
        self.collectionView.cg_autoEdgesInsetsZeroToSuperview()
    }
}
