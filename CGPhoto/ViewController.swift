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
        
        let result = PHAsset.fetchAssets(with: nil)
        result.enumerateObjects { (asset, idx, pointer) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

