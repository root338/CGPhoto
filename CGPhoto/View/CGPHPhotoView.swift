//
//  CGPHPhotoView.swift
//  CGPhoto
//
//  Created by DY on 2017/12/5.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class CGPHPhotoView: UIView {

    let collectionView : UICollectionView
    
    let style   = CGPHAssetCollectionStyle.default
    
    var estimatedImageSize : CGSize {
        
        return itemSize.scale()
    }
    
    fileprivate var itemSize            = CGSize.zero
    fileprivate var didCalculateWidth   = CGFloat(0)
    fileprivate var sectionInset        = UIEdgeInsets.zero
    
    override convenience init(frame: CGRect) {
        
        var width       = frame.size.width
        if width == 0 {
            width = UIScreen.main.bounds.size.width
        }
        let flowLayout  = UICollectionViewFlowLayout.init(maxWidth: width, insets: .zero)
        self.init(frame: frame, layout: flowLayout)
        
        didCalculateWidth   = width
    }
    
    init(frame: CGRect, layout: UICollectionViewLayout) {
        
        collectionView = UICollectionView.init(frame: .init(origin: .zero, size: frame.size), collectionViewLayout: layout)
        
        if let flowLayout = layout as? UICollectionViewFlowLayout {
            itemSize    = flowLayout.itemSize
        }
        
        super.init(frame: frame)
        
        self.addSubview(collectionView)
        
        self.setupContentSubviewsLayout()
        collectionView.backgroundColor  = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetAssetListFlowLayout() {
        
        guard self.style == .default else {
            return
        }
        
        let width = self.bounds.width
        var insets  = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            insets  = self.safeAreaInsets
        }
        
        if width != didCalculateWidth || insets != sectionInset {
            
            let flowLayout  = UICollectionViewFlowLayout.init(maxWidth: width, insets: insets)
            collectionView.setCollectionViewLayout(flowLayout, animated: false, completion: { (isFinished) in
                
            })
            
            didCalculateWidth   = width
            sectionInset        = insets
        }
    }
    
    //MARK:- 重写系统方法
    
    override func safeAreaInsetsDidChange() {
        
        if #available(iOS 11.0, *) {
            super.safeAreaInsetsDidChange()
            self.resetAssetListFlowLayout()
        }
        
    }
    
    override var bounds: CGRect {
        didSet {
            self.resetAssetListFlowLayout()
        }
    }
    
    
}

fileprivate extension CGPHPhotoView {
    
    func setupContentSubviewsLayout() {
        
        if self.style == .default {
            
            collectionView.cg_autoEdgesInsetsZeroToSuperview()
        }
    }
    
    
}
