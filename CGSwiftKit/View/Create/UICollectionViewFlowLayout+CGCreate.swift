//
//  UICollectionViewFlowLayout+CGCreate.swift
//  CGPhoto
//
//  Created by DY on 2017/12/6.
//  Copyright © 2017年 DY. All rights reserved.
//

import Foundation

extension UICollectionViewFlowLayout {
    
    convenience init(itemSize: CGSize) {
        self.init()
        
        self.itemSize           = itemSize
        self.scrollDirection    = .vertical
    }
    
    convenience init(itemSize: CGSize, sectionInset: UIEdgeInsets, minLineSpace: CGFloat, minInteritemSpace: CGFloat) {
        
        self.init(itemSize: itemSize)
        
        self.sectionInset               = sectionInset
        self.minimumLineSpacing         = minLineSpace
        self.minimumInteritemSpacing    = minInteritemSpace
    }
    
}
