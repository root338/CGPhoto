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
        
        test_addMLImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- 测试
    
    func test_addMLImageView() {
        
        let image = UIImage.init(named: "1.jpg")
        let imageView = MLImageView.init(image: image)
        imageView.imageContentMode  = .bottom
        
        self.view.addSubview(imageView)
        
        imageView.cg_autoEdgesInsetsZero(to: self)
    }
    
    func test_addCGPhoto() {
        
        let result = PHAsset.fetchAssets(with: nil)
        result.enumerateObjects { (asset, idx, pointer) in
            
        }
    }
}

