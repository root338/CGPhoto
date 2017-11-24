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
        // 需要先还原下 UIScrollView 的缩放值，否则在之后的 contentSize 中的计算会出现问题
        self.scrollView.setZoomScale(1.0, animated: true)
        let contentMode = self.imageView.contentMode
        let targetSize  = self.size
        guard self.shouldSetupViewContentLayout(contentMode: contentMode, targetSize: targetSize) else {
            return
        }
        
        self.setupResetViewsSize(contentMode: contentMode, targetSize: targetSize, loadImage: self.imageView.image!)
        
    }
    
    /// 设置重置相关视图
    private func setupResetViewsSize(contentMode: UIViewContentMode, targetSize: CGSize, loadImage: UIImage) {
        
        let imageViewSize = self.calculateImageViewSize(targetContentMode: contentMode, loadImage: loadImage, targetSize: targetSize)
        
        let imageViewPoints = self.calculateImageViewPoint(targetContentMode: contentMode, imageViewSize: imageViewSize, targetSize: targetSize)
        
        let contentSize = imageViewSize
        
        let contentOffset = imageViewPoints.contentOffset
        
        let imageViewFrame  = CGRect.init(origin: imageViewPoints.imageViewPoint, size: imageViewSize)
        var duration        = 0.3
        if self.imageView.frame == CGRect.zero {
            
            duration                = 0
            self.imageView.frame    = imageViewFrame
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            if !self.imageView.frame.equalTo(imageViewFrame) {
                self.imageView.frame = imageViewFrame
            }
        }) { (finishes) in
            self.resetImageViewScrollArea(contentSize: contentSize, contentOffset: contentOffset)
        }
    }
    
    /// 重置 scrollView 的 contentSize 和 contentOffset
    func resetImageViewScrollArea(contentSize: CGSize, contentOffset: CGPoint) {
        
        self.scrollView.contentSize     = contentSize
        self.scrollView.setContentOffset(contentOffset, animated: false)
        
    }
    
    ///
    
    /// 计算imageView自身大小相对于指定大小，在不同加载类型下的坐标
    ///
    /// - Parameters:
    ///   - targetContentMode: imageView 加载的类型
    ///   - imageViewSize: 图片的大小
    ///   - targetSize: 固定的目标大小
    /// - Returns: 返回一个元祖 (imageViewPoint: 图片的坐标, contentOffset: scrollView 需要偏移的坐标)
    func calculateImageViewPoint(targetContentMode: UIViewContentMode, imageViewSize: CGSize, targetSize: CGSize) -> (imageViewPoint: CGPoint, contentOffset: CGPoint) {
        
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
            
            if imageViewSize.width == targetSize.width {
                // 在.scaleToFill类型下 imageViewSize == targetSize 所以只判断一个值来处理
                x = zeroX
                y = zeroY
            }else {
                // 在缩放的过程中 targetSize 也许不会与视图等同，所以指定在 .scaleToFill 加载类型下 使用居中的类型处理
                x = minX
                y = minY
            }
            
        case .scaleAspectFit:
            fallthrough
        case .scaleAspectFill:
            
            if imageViewSize.width == targetSize.width {
                x = zeroX
                y = minY
            }else if imageViewSize.height == targetSize.height {
                x = minX
                y = zeroY
            }else {
                // 在缩放的过程中 targetSize 也许不会与视图等同，所以指定在 .scaleAspectFit .scaleAspectFill 加载类型下 使用居中的类型处理
                x = minX
                y = minY
            }
        case .redraw:
            break
        }
        
        let originPoint     = CGPoint.init(x: x, y: y)
        let imageViewPoint  = CGPoint.init(x: originPoint.x >= 0 ? x : 0, y: originPoint.y >= 0 ? y : 0)
        let contentOffset   = CGPoint.init(x: originPoint.x < 0 ? abs(originPoint.x) : 0, y: originPoint.y < 0 ? abs(originPoint.y) : 0)
        
        return (imageViewPoint, contentOffset)
    }
    
    /// 计算imageView大小
    func calculateImageViewSize(targetContentMode: UIViewContentMode, loadImage: UIImage, targetSize: CGSize) ->CGSize {
        
        var imageViewSize : CGSize
        switch targetContentMode {
        case .scaleToFill:
            
            imageViewSize   = targetSize
        case .scaleAspectFit:
            
            imageViewSize   = loadImage.cg_calculateScaleAspectFitSize(withTargetSize: targetSize)
        case .scaleAspectFill:
            
            imageViewSize   = loadImage.cg_calculateScale(.sizeForScaleAspectFill, aspectFitSizeWithTargetSize: targetSize)
        default:
            imageViewSize   = loadImage.size
        }
        
        return imageViewSize
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
                doubleClickGestureRecognizer.numberOfTapsRequired       = 2
                gestureRecognizers  = doubleClickGestureRecognizer
                
            case .longPress:    // 长按
                
                let longPressGestureRecognizer  = UILongPressGestureRecognizer.init(target: self, action: #selector(handle(longPressGestureRecognizer:)))
                longPressGestureRecognizer.allowableMovement    = imageViewConfig.allowableMovement
                longPressGestureRecognizer.minimumPressDuration = imageViewConfig.minimumLongPressDuration
                longPressGestureRecognizer.numberOfTapsRequired = 0
                longPressGestureRecognizer.numberOfTouchesRequired  = 1
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
        
        let state = longPressGestureRecognizer.state
        guard state == .began else {
            // 只有在才识别到时才触发功能，移动，结束等其他状态都不进行处理
            return
        }
        
        guard ((self.delegate?.imageView(self, longPressGestureRecognizer: longPressGestureRecognizer)) == nil) else {
            return
        }
        
        self.handle(style: .longPress, targetGestureRecognizer: longPressGestureRecognizer, tool: imageViewConfig.defalutLongPressTool)
    }
    
}

// MARK: - 默认手势功能
fileprivate extension MLImageView {
    
    func handle(style: CGGestureRecognizerStyle, targetGestureRecognizer: UIGestureRecognizer, tool: MLImageViewToolType) {
        
        switch tool {
        case .zoom:
            let point = targetGestureRecognizer.location(in: self)
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
            
            var zoomScale = imageViewConfig.defalutZoomScale
            if zoomScale <= 0 || zoomScale > self.maximumZoomScale {
                zoomScale   = self.maximumZoomScale
            }
            
            let zoomRect = self.zoomRect(scale: zoomScale, targetPoint: zoomScaleCenter, originSize: self.imageView.size)
            self.zoom(to: zoomRect, animated: !imageViewConfig.hideZoomScaleAnimated)
            
            self.scrollView.zoomScale = zoomScale
        }else {
            
            self.resetImageViewLayout()
        }
    }
    
    /// 处理显示操作表
    func handleShowActionSheet() {
        print("\(MLImageView.self) 长按已生效")
    }
    
    func setZoomScale(_ scale: CGFloat, animated: Bool) {
        self.scrollView.setZoomScale(scale, animated: animated)
    }
    
    /// 计算缩放的区域
    ///
    /// - Parameters:
    ///   - scale: 缩放的比例
    ///   - targetPoint: 目标坐标,需要MLImageView内的坐标系
    ///   - originSize: 需要缩放的大小
    /// - Returns: 返回指定缩放比例下的CGRect
    func zoomRect(scale: CGFloat, targetPoint: CGPoint, originSize: CGSize) ->CGRect {
        
        // 计算目标视图缩放后的大小
        let width   = originSize.width / scale
        let height  = originSize.height / scale
        
        let x = max(targetPoint.x - targetPoint.x / scale, 0)
        let y = max(targetPoint.y - targetPoint.y / scale, 0)
        
        let zoomRect    = CGRect.init(x: x, y: y, width: width, height: height)
        return zoomRect
    }
}
