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
        
        let clickButton = UIButton.init(type: .system)
        clickButton.setTitle("Go Photo Controller >>", for: .normal)
        self.view.addSubview(clickButton)
        clickButton.addTarget(self, action: #selector(handlePushPhotoViewController(sender:)), for: .touchUpInside)
        
        if #available(iOS 9.0, *) {
            
            _ = clickButton.cg_constraint(type1: .leading, targetView: self.view, type2: .leading, relation: .equal, multiplier: 1, constant: 15)
            _ = clickButton.cg_constraint(type1: .trailing, targetView: self.view, type2: .trailing, relation: .lessThanOrEqual, multiplier: 1, constant: 15)
            _ = clickButton.cg_y_constraint(anthorType1: .top, targetView: self.view, anthorType2: .top, relation: .equal, constant: 15)
            
//            _ = clickButton.cg_x_constraint(anthorType1: .leading, targetView: self.view, anthorType2: .leading, relation: .lessThanOrEqual, constant: 15)
//            _ = clickButton.cg_x_constraint(anthorType1: .trailing, targetView: self.view, anthorType2: .trailing, relation: .lessThanOrEqual, constant: 15)
//            _ = clickButton.cg_y_constraint(anthorType1: .top, targetView: self.view, anthorType2: .top, relation: .equal, constant: 15)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @objc func handlePushPhotoViewController(sender: Any) {
        
        let photoCollectionVC = CGPhotoCollectionViewController.init()
        self.navigationController?.pushViewController(photoCollectionVC, animated: true)
    }
}

