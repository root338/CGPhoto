//
//  CGPhotoCollectionView.swift
//  CGPhoto
//
//  Created by DY on 2017/11/24.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class CGPhotoCollectionView: UIView {

    fileprivate let collection : UICollectionView
    
    override convenience init(frame: CGRect) {
        
        let flowLayout = CGPhotoCollectionView.createPhotoCollectionViewFlowLayout(width: frame.size.width)
        self.init(frame: frame, layout: flowLayout)
    }
    
    init(frame: CGRect, layout: UICollectionViewLayout) {
        
        collection = UICollectionView.init(frame: .init(origin: .zero, size: frame.size), collectionViewLayout: layout)
        super.init(frame: frame)
        
        self.addSubview(collection)
        
        self.setupContentViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 对外接口属性设置
extension CGPhotoCollectionView {
    
    class func createPhotoCollectionViewFlowLayout(width: CGFloat) ->UICollectionViewFlowLayout {
        
        let flowLayout  = UICollectionViewFlowLayout.init()
        
        flowLayout.minimumLineSpacing       = 2
        flowLayout.minimumInteritemSpacing  = 2
        
        let count       = CGFloat(4)
        let itemLength  = (width - (count - 1) * flowLayout.minimumInteritemSpacing) / count
        
        flowLayout.itemSize                 = CGSize.init(width: itemLength, height: itemLength)
        flowLayout.scrollDirection          = .vertical
        
        return flowLayout
    }
    
    var collectionViewLayout : UICollectionViewLayout {
        set {
            self.collection.setCollectionViewLayout(newValue, animated: true)
        }
        get {
            return self.collection.collectionViewLayout
        }
    }
    
    weak var delegate : UICollectionViewDelegate? {
        
        set {
            self.collection.delegate = newValue
        }
        get {
            return self.collection.delegate
        }
    }
    
    weak var dataSource : UICollectionViewDataSource? {
        set {
            self.collection.dataSource  = newValue
        }
        get {
            return self.collection.dataSource
        }
    }
}


// MARK: - 设置布局
fileprivate extension CGPhotoCollectionView {
    
    func setupContentViewLayout() {
        
        self.collection.cg_autoEdgesInsetsZeroToSuperview()
    }
}
