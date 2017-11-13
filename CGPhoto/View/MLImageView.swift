//
//  MLImageView.swift
//  CGPhoto
//
//  Created by DY on 2017/11/13.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class MLImageView: UIView {

    let imageView = UIImageView.init()
    
    let rotationGestureRecognizer : UIRotationGestureRecognizer
    
    override init(frame: CGRect) {
        
        rotationGestureRecognizer   = UIRotationGestureRecognizer.init()
        
        super.init(frame: frame)
        
        rotationGestureRecognizer.addTarget(self, action: #selector(handleRotationRecognizer(_:)))
        
        self.addSubview(imageView)
        
        self.addGestureRecognizer(rotationGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- action
    @objc fileprivate func handleRotationRecognizer(_ recognizer: UIRotationGestureRecognizer) {
        
        
    }
}
