//
//  CGImageViewExtension.swift
//  CGPhoto
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 DY. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func setupContentMode(_ contentMode: UIViewContentMode) {
        
        self.contentMode    = contentMode
        if contentMode != .scaleAspectFit && contentMode != .scaleToFill {
            if self.clipsToBounds != true {
                self.clipsToBounds  = true
            }
        }
    }
}
