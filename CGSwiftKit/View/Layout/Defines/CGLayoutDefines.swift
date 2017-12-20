//
//  CGLayoutDefines.swift
//  CGPhoto
//
//  Created by DY on 2017/11/27.
//  Copyright © 2017年 DY. All rights reserved.
//

import Foundation

//@available(iOS 9.0, *)
//enum CGViewLayoutType : Int {
//    case none
//}

/// 添加约束返回的值
typealias CGLayoutReturnValue = (layoutType: CGViewLayoutAnchorType, constraint: NSLayoutConstraint)

enum CGViewLayoutXAxisAnchorType : Int {
    
    case leading
    case trailing
    
    case left
    case right
    
    case centerX
}

enum CGViewLayoutYAxisAnchorType : Int {
    
    case top
    case bottom
    
    case centerY
    case firstBaseLine
    case lastBaseLine
}

enum CGViewLayoutDimension : Int {
    
    case width
    case height
}

enum CGViewLayoutAnchorType : Int {
    
    case top
    case bottom
    
    case leading
    case left
    case trailing
    case right
    
    func layoutAttribute() -> NSLayoutAttribute {
        
        let attribute : NSLayoutAttribute
        switch self {
        case .top:
            attribute   = .top
        case .bottom:
            attribute   = .bottom
        case .leading:
            attribute   = .leading
        case .left:
            attribute   = .left
        case .trailing:
            attribute   = .trailing
        case .right:
            attribute   = .right
        }
        return attribute
    }
}

enum CGViewLayoutRelation : Int {
    
    case lessThanOrEqual        = -1
    case equal                  = 0
    case greaterThanOrEqual     = 1
    
    func relation() ->NSLayoutRelation {
        let relation: NSLayoutRelation
        switch self {
        case .lessThanOrEqual:
            relation = .lessThanOrEqual
        case .equal:
            relation = .equal
        case .greaterThanOrEqual:
            relation = .greaterThanOrEqual
        }
        return relation
    }
}

struct CGViewLayoutAnchorOptions : OptionSet {
    
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    
    static let top      = CGViewLayoutAnchorOptions.init(rawValue: 1 << 0)
    static let leading  = CGViewLayoutAnchorOptions.init(rawValue: 1 << 1)
    static let left     = CGViewLayoutAnchorOptions.init(rawValue: 1 << 2)
    static let bottom   = CGViewLayoutAnchorOptions.init(rawValue: 1 << 3)
    static let trailing = CGViewLayoutAnchorOptions.init(rawValue: 1 << 4)
    static let right    = CGViewLayoutAnchorOptions.init(rawValue: 1 << 5)
    
    static let vertical     : CGViewLayoutAnchorOptions = [top, bottom]
    static let horizontal   : CGViewLayoutAnchorOptions = [leading, trailing]
    static let horizontal1  : CGViewLayoutAnchorOptions = [left, right]
    
    static let leadingTop   : CGViewLayoutAnchorOptions = [leading, top]
    static let leadingBottom : CGViewLayoutAnchorOptions = [leading, bottom]
    static let trailingTop  : CGViewLayoutAnchorOptions = [trailing, top]
    static let trailingBottom : CGViewLayoutAnchorOptions = [trailing, bottom]
    
    static let allEdge      : CGViewLayoutAnchorOptions = [vertical, horizontal]
    
    static let edgeExcludingTop     : CGViewLayoutAnchorOptions = [leading, bottom, trailing]
    static let edgeExcludingLeading : CGViewLayoutAnchorOptions = [top, bottom, trailing]
    static let edgeExcludingBottom  : CGViewLayoutAnchorOptions = [top, leading, trailing]
    static let edgeExcludingTrailing : CGViewLayoutAnchorOptions = [top, leading, bottom]
    
    func viewLayoutAnthorType() -> Array<CGViewLayoutAnchorType> {
        
        var types = [CGViewLayoutAnchorType]()
        
        if self.contains(.top) {
            types.append(.top)
        }
        if self.contains(.leading) {
            types.append(.leading)
        }
        if self.contains(.left) {
            types.append(.left)
        }
        if self.contains(.bottom) {
            types.append(.bottom)
        }
        if self.contains(.trailing) {
            types.append(.trailing)
        }
        if self.contains(.right) {
            types.append(.right)
        }
        
        return types
    }
}
