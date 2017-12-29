//
//  CGSizeExtension.swift
//  CGPhoto
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 DY. All rights reserved.
//

import Foundation

extension CGSize {
    
    func scale() -> CGSize {
        
        let scale = UIScreen.main.scale
        return self.scale(scale)
    }
    
    func scale(_ scale: CGFloat) -> CGSize {
        return CGSize.init(width: self.width * scale, height: self.height * scale)
    }
}
