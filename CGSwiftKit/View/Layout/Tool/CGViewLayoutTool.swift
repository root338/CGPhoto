//
//  CGViewLayoutTool.swift
//  CGPhoto
//
//  Created by DY on 2017/11/29.
//  Copyright © 2017年 DY. All rights reserved.
//

import Foundation

@available(iOS 9.0, *)
extension UIView {
    
    func cg_layoutXAxisAnchor(type: CGViewLayoutXAxisAnchorType) -> NSLayoutXAxisAnchor {
        
        let axisAnchor : NSLayoutXAxisAnchor
        switch type {
        case .leading:
            axisAnchor  = self.leadingAnchor
        case .left:
            axisAnchor  = self.leftAnchor
        case .trailing:
            axisAnchor  = self.trailingAnchor
        case .right:
            axisAnchor  = self.rightAnchor
        case .centerX:
            axisAnchor  = self.centerXAnchor
        }
        return axisAnchor
    }
    
    func cg_layoutYAxisAnchor(type: CGViewLayoutYAxisAnchorType) -> NSLayoutYAxisAnchor {
        
        let axisAnchor : NSLayoutYAxisAnchor
        switch type {
        case .top:
            axisAnchor  = self.topAnchor
        case .bottom:
            axisAnchor  = self.bottomAnchor
        case .centerY:
            axisAnchor  = self.centerYAnchor
        case .firstBaseLine:
            axisAnchor  = self.firstBaselineAnchor
        case .lastBaseLine:
            axisAnchor  = self.lastBaselineAnchor
        }
        
        return axisAnchor
    }
    
    func cg_layout(dimension: CGViewLayoutDimension) -> NSLayoutDimension {
        
        let layoutDimension : NSLayoutDimension
        switch dimension {
        case .width:
            layoutDimension = self.widthAnchor
        case .height:
            layoutDimension = self.heightAnchor
        }
        return layoutDimension
    }
}

@available(iOS 9.0, *)
extension UILayoutGuide {
    
    func cg_layoutXAxisAnchor(type: CGViewLayoutXAxisAnchorType) -> NSLayoutXAxisAnchor {
        
        let axisAnchor : NSLayoutXAxisAnchor
        switch type {
        case .leading:
            axisAnchor  = self.leadingAnchor
        case .left:
            axisAnchor  = self.leftAnchor
        case .trailing:
            axisAnchor  = self.trailingAnchor
        case .right:
            axisAnchor  = self.rightAnchor
        case .centerX:
            axisAnchor  = self.centerXAnchor
        }
        return axisAnchor
    }
    
    func cg_layoutYAxisAnchor(type: CGViewLayoutYAxisAnchorType) -> NSLayoutYAxisAnchor {
        
        let axisAnchor : NSLayoutYAxisAnchor
        switch type {
        case .top:
            axisAnchor  = self.topAnchor
        case .bottom:
            axisAnchor  = self.bottomAnchor
        case .centerY:
            axisAnchor  = self.centerYAnchor
        default:
            
            assert(false, "UILayoutGuide 不支持 \(type)")
            axisAnchor  = NSLayoutYAxisAnchor.init()
        }
        
        return axisAnchor
    }
    
    func cg_layout(dimension: CGViewLayoutDimension) -> NSLayoutDimension {
        
        let layoutDimension : NSLayoutDimension
        switch dimension {
        case .width:
            layoutDimension = self.widthAnchor
        case .height:
            layoutDimension = self.heightAnchor
        }
        return layoutDimension
    }
}


