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
        
        self.itemSize   = itemSize
        self.scrollDirection    = .vertical
    }
    
    convenience init(maxWidth: CGFloat, count: Int) {
        self.init()
        
        let hSpace  = CGFloat(2)
        let vSpace  = CGFloat(2)
        
        let length  = (maxWidth - (hSpace * CGFloat(count - 1))) / CGFloat(count)
        
        self.itemSize   = .init(width: length, height: length)
        self.minimumInteritemSpacing    = hSpace
        self.minimumLineSpacing         = vSpace
    }
}
