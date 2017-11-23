//
//  MLImageViewConfig.swift
//  CGPhoto
//
//  Created by DY on 2017/11/23.
//  Copyright © 2017年 DY. All rights reserved.
//

import Foundation

/// MLImageView功能类型
///
/// - none: 空
/// - zoom: 缩放
/// - actionSheet: 显示操作表
enum MLImageViewToolType {
    case none
    case zoom
    case actionSheet
}

/// MLImageView 功能配置
struct MLImageViewConfig {
    
    //MARK:- 默认代理实现功能
    /// 单击
    var defalutClickTool        = MLImageViewToolType.none
    /// 双击
    var defalutDoubleTool       = MLImageViewToolType.zoom
    /// 显示操作表
    var defalutLongPressTool    = MLImageViewToolType.actionSheet
    
    /// 长按最少时间
    var minimumLongPressDuration = CFTimeInterval.init(1)
    
    /// 默认缩放的比例
    var defalutZoomScale = CGFloat(3.0)
    
    /// 隐藏缩放的动画
    var hideZoomScaleAnimated = false
}
