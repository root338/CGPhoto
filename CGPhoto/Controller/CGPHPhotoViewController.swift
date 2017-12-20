//
//  CGPHPhotoViewController.swift
//  CGPhoto
//
//  Created by DY on 2017/12/5.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class CGPHPhotoViewController: UIViewController {

    var assetCollectionDataSource: CGPhotoFetchResult!
    
    fileprivate let assetsView = CGPHPhotoView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if assetsView.superview == nil {
            self.view.addSubview(assetsView)
            if #available(iOS 11.0, *) {
                _ = assetsView.cg_Layout(targetView: self.view, edgeOptions: .allEdge)
            } else {
                // Fallback on earlier versions
                assetsView.cg_autoEdgesInsetsZero(to: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
