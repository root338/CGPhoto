//
//  ViewController.swift
//  CGPhoto
//
//  Created by DY on 2017/11/10.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        test_addCGPhoto()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- 测试
    
    func test_addMLImageView() {
        
        let image = UIImage.init(named: /*"笑脸.png"*/ "1.jpg")
        let imageView = MLImageView.init(image: image)
        imageView.imageContentMode          = .scaleAspectFit
        imageView.isScrollEnable            = true
        imageView.maximumZoomScale          = 10.0
        imageView.minimumZoomScale          = 0.1
        imageView.enableDoubleClickGestureRecognizer    = true
        imageView.enableLongPressGestureRecognizer      = true
        
        self.view.addSubview(imageView)
        
        imageView.cg_autoEdgesInsetsZero(to: self)
    }
    
    func test_addCGPhoto() {
        
        
    }
}

