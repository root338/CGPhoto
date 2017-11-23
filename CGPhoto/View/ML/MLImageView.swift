//
//  MLImageView.swift
//  CGPhoto
//
//  Created by DY on 2017/11/13.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

/// 图片视图协议
protocol MLImageViewProtocol: NSObjectProtocol {
    
    /// 图片视图长按事件
    func imageView(_ imageView: MLImageView, longPressGestureRecognizer: UILongPressGestureRecognizer)
    /// 图片视图多次事件 > 2
    func imageView(_ imageView: MLImageView, tapGestureRecognizer: UITapGestureRecognizer, numberOfTaps: Int)
    /// 单击
    func imageView(_ imageView: MLImageView, clickGestureRecognizer: UITapGestureRecognizer)
    /// 双击
    func imageView(_ imageView: MLImageView, doubleGestureRecognizer: UITapGestureRecognizer)
}

// MARK: - 对外属性设置
extension MLImageView {
    
    /// 缩放的最小值
    var minimumZoomScale : CGFloat {
        get {
            return self.scrollView.minimumZoomScale
        }
        set {
            self.scrollView.minimumZoomScale    = newValue
        }
    }
    
    /// 缩放的最大值
    var maximumZoomScale : CGFloat {
        get {
            return self.scrollView.maximumZoomScale
        }
        set {
            self.scrollView.maximumZoomScale    = newValue
        }
    }
}

//MARK:-
class MLImageView: UIView {
    
    //MARK:- 对外
    
    /// 滑动是否开启, 默认为 false
    var isScrollEnable : Bool = false {
        didSet {
            if isScrollEnable != self.scrollView.isScrollEnabled {
                
                self.scrollView.isScrollEnabled = isScrollEnable
            }
        }
    }
    
    weak var delegate : MLImageViewProtocol?
    
    /// 开启单击手势，默认为 false
    var enableClickGestureRecognizer  = false {
        didSet {
            self.setupGestureRecognizer(style: .click, isEnable: enableClickGestureRecognizer)
        }
    }
    /// 开启双击手势，默认为 false
    var enableDoubleClickGestureRecognizer  = false{
        didSet {
            self.setupGestureRecognizer(style: .doubleClick, isEnable: enableDoubleClickGestureRecognizer)
        }
    }
    /// 开启长按手势，默认为 false
    var enableLongPressGestureRecognizer    = false{
        didSet {
            self.setupGestureRecognizer(style: .longPress, isEnable: enableLongPressGestureRecognizer)
        }
    }
    
    /// 配置信息
    let imageViewConfig : MLImageViewConfig
    
    //MARK:- 对内
    
    fileprivate lazy var imageView : UIImageView = {
        return UIImageView.init()
    }()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.delegate = self
        return scrollView
    }()
    
    /// 支持的手势集合
    fileprivate var supportGestureRecognizers: [CGGestureRecognizerStyle: UIGestureRecognizer]?
    
    override var bounds: CGRect {
        didSet{
            if bounds != oldValue {
                self.resetImageViewLayout()
            }
        }
    }
    
    override convenience init(frame: CGRect) {
        
        self.init(frame: frame, config: MLImageViewConfig.init())
    }
    
    init(frame: CGRect, config: MLImageViewConfig) {
        
        imageViewConfig = config
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    //MARK:- 对外方法
    func zoom(to rect: CGRect, animated: Bool) {
        self.scrollView.zoom(to: rect, animated: animated)
    }
    
    func setZoomScale(_ scale: CGFloat, animated: Bool) {
        self.scrollView.setZoomScale(scale, animated: animated)
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
        self.scrollView.isScrollEnabled                 = self.isScrollEnable
        
        self.addSubview(self.scrollView)
        self.scrollView.cg_autoDimensionEqualView(self)
        self.scrollView.cg_autoEdgesInsetsZeroToSuperviewEdges(with: .leftTop)
        
        self.scrollView.addSubview(imageView)
        resetImageViewLayout()
    }
    
    /// 重置 imageView 的 frame
    func resetImageViewLayout() {
        
        self.scrollView.setZoomScale(1.0, animated: true)
        let contentMode = self.imageView.contentMode
        let targetSize  = self.size
        guard self.shouldSetupViewContentLayout(contentMode: contentMode, targetSize: targetSize) else {
            return
        }
        
        self.setupResetViewsSize(contentMode: contentMode, targetSize: targetSize)
        
    }
    
    /// 设置重置相关视图
    private func setupResetViewsSize(contentMode: UIViewContentMode, targetSize: CGSize) {
        
        var imageViewSize : CGSize
        
        guard let loadImage = self.imageView.image else {
            return
        }
        
        switch contentMode {
        case .scaleToFill:
            
            imageViewSize   = targetSize
        case .scaleAspectFit:
            
            imageViewSize   = loadImage.cg_calculateScaleAspectFitSize(withTargetSize: self.size)
        case .scaleAspectFill:
            
            imageViewSize   = loadImage.cg_calculateScale(.sizeForScaleAspectFill, aspectFitSizeWithTargetSize: targetSize)
        default:
            imageViewSize   = loadImage.size
        }
        
        let imageViewPoints = self.calculateImageViewPoint(targetContentMode: contentMode, imageViewSize: imageViewSize, targetSize: targetSize)
        
        let contentSize = imageViewSize
        
        let contentOffset = CGPoint.init(x: imageViewPoints.originPoint.x * -1, y: imageViewPoints.originPoint.y * -1)
        
        self.imageView.frame = .init(origin: imageViewPoints.imageViewPoint, size: imageViewSize)
        
        self.resetImageViewScrollArea(contentSize: contentSize, contentOffset: contentOffset)
    }
    
    /// 重置 scrollView 的 contentSize 和 contentOffset
    func resetImageViewScrollArea(contentSize: CGSize, contentOffset: CGPoint) {
        
        self.scrollView.contentSize     = contentSize
        self.scrollView.setContentOffset(contentOffset, animated: false)
    }
    
    /// 计算imageView自身大小，相对于指定大小，在不同加载类型下的坐标
    func calculateImageViewPoint(targetContentMode: UIViewContentMode, imageViewSize: CGSize, targetSize: CGSize) -> (imageViewPoint: CGPoint, originPoint: CGPoint) {
        
        let minX = (targetSize.width - imageViewSize.width) / 2.0
        let minY = (targetSize.height - imageViewSize.height) / 2.0
        
        let maxX = targetSize.width - imageViewSize.width
        let maxY = targetSize.height - imageViewSize.height
        
        let zeroX = CGFloat(0)
        let zeroY = CGFloat(0)
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        
        switch targetContentMode {
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
        
        let originPoint         = CGPoint.init(x: x, y: y)
        let imageViewPoint      = CGPoint.init(x: imageViewSize.width < targetSize.width ? x : 0, y: imageViewSize.height < targetSize.height ? y : 0)
        
        return (imageViewPoint, originPoint)
    }
    
    /// 验证是否可以设置相关视图
    func shouldSetupViewContentLayout(contentMode: UIViewContentMode, targetSize: CGSize) -> Bool {
        guard contentMode != .redraw else {
            return false
        }
        
        if self.imageView.image == nil {
            return false
        }
        
        guard targetSize != .zero else {
            return false
        }
        return true
    }
}

// MARK: - UIScrollViewDelegate 处理
extension MLImageView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        self.setupImageViewPoint()
    }
    
    func setupImageViewPoint() {
        
        let contentSize     = CGSize.init(width: max(self.scrollView.contentSize.width, self.scrollView.width), height: max(self.scrollView.contentSize.height, self.scrollView.height))
        let contentMode     = self.imageView.contentMode
        guard self.shouldSetupViewContentLayout(contentMode: contentMode, targetSize: contentSize) else {
            return
        }
        
        let imageViewSize   = self.imageView.size
        
        let imageViewPoint  = self.calculateImageViewPoint(targetContentMode: contentMode, imageViewSize: imageViewSize, targetSize: contentSize).imageViewPoint
        
        self.imageView.origin   = imageViewPoint
    }
    
    func getCenterPoint(points: [CGPoint]) -> CGPoint? {
        var centerPoint = points.first
        for (index, point) in points.enumerated() {
            if index == 0 {
                continue
            }else {
                
                centerPoint = CGPoint.cg_centerPoint(point1: point, point2: centerPoint!)
            }
        }
        return centerPoint
    }
    
    func getCenterPoint(gesture: UIGestureRecognizer,in view: UIView?) ->CGPoint? {
        var points = [CGPoint]()
        for i in 0 ..< gesture.numberOfTouches {
            points.append(gesture.location(ofTouch: i, in: view))
        }
        return self.getCenterPoint(points: points)
    }
}

// MARK: - 手势添加移除处理
fileprivate extension MLImageView {
    
    /// 设置页面手势
    ///
    /// - Parameters:
    ///   - style: 需要设置的类型
    ///   - isEnable: 手势是否开启
    func setupGestureRecognizer(style: CGGestureRecognizerStyle, isEnable: Bool) {
        
        func createGestureRecognizer(style: CGGestureRecognizerStyle) -> UIGestureRecognizer? {
            
            var gestureRecognizers: UIGestureRecognizer?
            
            switch style {
            case .click:    // 单击
                
                let clickGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handle(clickGestureRecognizer:)))
                clickGestureRecognizer.numberOfTapsRequired     = 1
                clickGestureRecognizer.numberOfTouchesRequired  = 1
                gestureRecognizers = clickGestureRecognizer
                
            case .doubleClick:  // 双击
                
                let doubleClickGestureRecognizer  = UITapGestureRecognizer.init(target: self, action: #selector(handle(doubleClickGestureRecognizer:)))
                doubleClickGestureRecognizer.numberOfTouchesRequired    = 1
                doubleClickGestureRecognizer.numberOfTapsRequired       = 1
                gestureRecognizers  = doubleClickGestureRecognizer
                
            case .longPress:    // 长按
                
                let longPressGestureRecognizer  = UILongPressGestureRecognizer.init(target: self, action: #selector(handle(longPressGestureRecognizer:)))
                gestureRecognizers  = longPressGestureRecognizer
                
            }
            
            return gestureRecognizers
        }
        
        if let targetGestureRecognizer = supportGestureRecognizers?[style] {
            
            if targetGestureRecognizer.isEnabled != isEnable {
                targetGestureRecognizer.isEnabled   = isEnable
            }
        }else if isEnable {
            
            if supportGestureRecognizers == nil {
                supportGestureRecognizers = [:]
            }
            
            if let targetGestureRecognizers = createGestureRecognizer(style: style) {
                
                self.addGestureRecognizer(targetGestureRecognizers)
                for (_, obj) in supportGestureRecognizers! {
                    targetGestureRecognizers.require(toFail: obj)
                }
                supportGestureRecognizers!.updateValue(targetGestureRecognizers, forKey: style)
                
            }
        }
    }
    
    @objc private func handle(clickGestureRecognizer: UITapGestureRecognizer) {
        
        guard ((self.delegate?.imageView(self, clickGestureRecognizer: clickGestureRecognizer)) == nil) else {
            return
        }
        
        self.handle(style: .click, targetGestureRecognizer: clickGestureRecognizer, tool: imageViewConfig.defalutClickTool)
    }
    
    @objc private func handle(doubleClickGestureRecognizer: UITapGestureRecognizer) {
        
        guard ((self.delegate?.imageView(self, doubleGestureRecognizer: doubleClickGestureRecognizer)) == nil) else {
            return
        }
        
        self.handle(style: .doubleClick, targetGestureRecognizer: doubleClickGestureRecognizer, tool: imageViewConfig.defalutDoubleTool)
    }
    
    @objc private func handle(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        guard ((self.delegate?.imageView(self, longPressGestureRecognizer: longPressGestureRecognizer)) == nil) else {
            return
        }
        
        self.handle(style: .longPress, targetGestureRecognizer: longPressGestureRecognizer, tool: imageViewConfig.defalutLongPressTool)
    }
    
    func handle(style: CGGestureRecognizerStyle, targetGestureRecognizer: UIGestureRecognizer, tool: MLImageViewToolType) {
        
        switch tool {
        case .zoom:
            let point = targetGestureRecognizer.location(in: self.scrollView)
            self.handleImageViewZoomScale(zoomScaleCenter: point)
        case .actionSheet:
            self.handleShowActionSheet()
        case .none:
            break
        }
    }
    
    /// 处理图片缩放
    ///
    /// - Parameter center: 缩放的中心点
    func handleImageViewZoomScale(zoomScaleCenter: CGPoint) {
        
        if self.scrollView.zoomScale == 1 {
            
        }else {
            self.resetImageViewLayout()
        }
    }
    
    /// 处理显示操作表
    func handleShowActionSheet() {
        
    }
}
