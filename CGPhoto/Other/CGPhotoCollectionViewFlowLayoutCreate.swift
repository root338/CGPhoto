//
//  CGPhotoCollectionViewFlowLayoutCreate.swift
//  CGPhoto
//
//  Created by apple on 2017/12/27.
//  Copyright © 2017年 DY. All rights reserved.
//

import Foundation

extension UICollectionViewFlowLayout {
    
    convenience init(maxWidth: CGFloat, count: Int) {
        
        let hSpace  = CGFloat(2)
        let vSpace  = CGFloat(2)
        
        let length  = (maxWidth - (hSpace * CGFloat(count - 1))) / CGFloat(count)
        
        self.init(itemSize: .init(width: length, height: length), sectionInset: .zero, minLineSpace: vSpace, minInteritemSpace: hSpace)
    }
    
    convenience init(maxWidth: CGFloat, insets: UIEdgeInsets) {
        
        let width           = maxWidth == 0 ? UIScreen.main.bounds.size.width : maxWidth
        var count           = 4
        var itemWidth       = CGFloat(0)
        let availableWidth  = width - insets.left - insets.right
        
        let hSpace          = CGFloat(2)
        let vSpace          = CGFloat(2)
        
        while true {
            
            itemWidth = (availableWidth - (CGFloat(count) - 1) * hSpace) / CGFloat(count)
            if itemWidth < 105 {
                break
            }else {
                count += 1
            }
        }
        
        self.init(itemSize: .init(width: itemWidth, height: itemWidth), sectionInset: insets, minLineSpace: vSpace, minInteritemSpace: hSpace)
    }
}
