//
//  MLImageView.swift
//  CGPhoto
//
//  Created by DY on 2017/11/13.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

class MLImageView: UIView {
    
    /// 开启缩放手势
    var enableDoubleClickGesture = false {
        willSet {
            
        }
    }
    
    fileprivate lazy var imageView : UIImageView = {
        return UIImageView.init()
    }()
    
    fileprivate lazy var scrollView : UIScrollView = {
        return UIScrollView.init()
    }()
    
    fileprivate lazy var rotationGestureRecognizer : UIRotationGestureRecognizer = {
        return UIRotationGestureRecognizer.init()
    }()
    
    override var bounds: CGRect {
        didSet{
            if bounds != oldValue {
                self.resetImageViewLayout()
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.clipsToBounds  = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- action
    @objc fileprivate func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        
        
    }
}

// MARK: - 对外接口扩展
extension MLImageView {
    //MARK:- 对外属性
    
    var image : UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image    = newValue
            if imageView.superview == nil {
                addImageView()
            }
        }
    }
    
    var imageContentMode : UIViewContentMode {
        get {
            return imageView.contentMode
        }
        set {
            imageView.contentMode = newValue
            if self.imageView.image != nil {
                self.resetImageViewLayout()
            }
        }
    }
    
    //MARK:- 初始化方法
    convenience init(image: UIImage?) {
        
        self.init(frame: .zero)
        
        self.image  = image
    }
}

// MARK: - 私有具体实现方法
fileprivate extension MLImageView {
    
    
    
    //MARK:- 图片处理
    func addImageView() {
        
        self.scrollView.showsVerticalScrollIndicator    = false
        self.scrollView.showsHorizontalScrollIndicator  = false
        
        self.addSubview(self.scrollView)
        self.scrollView.cg_autoDimensionEqualView(self)
        self.scrollView.cg_autoEdgesInsetsZeroToSuperviewEdges(with: .leftTop)
        
        self.scrollView.addSubview(imageView)
        resetImageViewLayout()
    }
    
    /// 重置 imageView 的 frame
    func resetImageViewLayout() {
        
        let contentMode = self.imageView.contentMode
        guard contentMode != .redraw else {
            return
        }
        
        guard let loadImage = self.imageView.image else {
            return
        }
        
        let targetSize = self.size
        guard targetSize != .zero else {
            return
        }
        
        var imageViewSize : CGSize
        var imageViewPoint = CGPoint.zero
        
        switch contentMode {
        case .scaleToFill:
            
            imageViewSize   = targetSize
            imageViewPoint  = .zero
        case .scaleAspectFit:
            
            imageViewSize   = loadImage.cg_calculateScaleAspectFitSize(withTargetSize: self.size)
        case .scaleAspectFill:
            
            imageViewSize   = loadImage.cg_calculateScale(.sizeForScaleAspectFill, aspectFitSizeWithTargetSize: self.size)
        default:
            imageViewSize   = loadImage.size
        }
        
        let minX = (targetSize.width - imageViewSize.width) / 2.0
        let minY = (targetSize.height - imageViewSize.height) / 2.0
        
        let maxX = targetSize.width - imageViewSize.width
        let maxY = targetSize.height - imageViewSize.height
        
        let zeroX = CGFloat(0)
        let zeroY = CGFloat(0)
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        
        switch contentMode {
        case .top:
            x = minX
            y = zeroY
            
        case .topLeft:
            x = zeroX
            y = zeroY
        case .left:
            x = zeroX
            y = minY
        case .bottomLeft:
            x = zeroX
            y = maxY
        case .bottom:
            x = minX
            y = maxY
        case .bottomRight:
            x = maxX
            y = maxY
        case .right:
            x = maxX
            y = minY
        case .topRight:
            x = maxX
            y = zeroY
        case .center:
            x = minX
            y = minY
        case .scaleToFill:
            x = zeroX
            y = zeroY
        case .scaleAspectFit:
            fallthrough
        case .scaleAspectFill:
            if imageViewSize.width == targetSize.width {
                x = zeroX
                y = minY
            }else {
                x = minX
                y = zeroY
            }
        case .redraw:
            break
        }
        imageViewPoint  = .init(x: x, y: y)
        
        let contentSize = imageViewSize
        let contentOffset = CGPoint.init(x: imageViewPoint.x * -1, y: imageViewPoint.y * -1)
        
        self.imageView.frame = CGRect.init(origin: .init(x: imageViewSize.width < targetSize.width ? imageViewPoint.x : 0, y: imageViewSize.height < targetSize.height ? imageViewPoint.y : 0), size: imageViewSize)
        
        self.resetImageViewScrollArea(contentSize: contentSize, contentOffset: contentOffset)
    }
    
    //MARK:- 滑动处理
    func enableImageScroll() {
        
        let isShouldScroll = self.enableDoubleClickGesture
        
        self.scrollView.isScrollEnabled = isShouldScroll
    }
    
    /// 重置 scrollView 的 contentSize 和 contentOffset
    func resetImageViewScrollArea(contentSize: CGSize, contentOffset: CGPoint) {
        
        self.scrollView.contentSize     = contentSize
        self.scrollView.setContentOffset(contentOffset, animated: false)
    }
}
