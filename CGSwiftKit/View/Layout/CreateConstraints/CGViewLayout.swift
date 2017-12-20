//
//  CGViewLayout.swift
//  CGPhoto
//
//  Created by DY on 2017/11/27.
//  Copyright © 2017年 DY. All rights reserved.
//

/**
 // 创建约束
 // 添加到视图
 */

import Foundation

@available(iOS 9.0, *)

// MARK: - NSLayoutXAxisAnchor 类型约束
extension UIView {
    
    func cg_x_constraint(anthorType1: CGViewLayoutXAxisAnchorType, targetView: UIView, anthorType2: CGViewLayoutXAxisAnchorType, relation: CGViewLayoutRelation, constant: CGFloat) -> NSLayoutConstraint {
        
        self.setupSupportAutoLayout()
        
        var axisAnchor1 = self.cg_layoutXAxisAnchor(type: anthorType1)
        var axisAnchor2 : NSLayoutXAxisAnchor
        
        let constraint : NSLayoutConstraint
        
        if #available(iOS 11.0, *) {
            
            axisAnchor2 = targetView.safeAreaLayoutGuide.cg_layoutXAxisAnchor(type: anthorType2)
        } else {
            
            axisAnchor2 = targetView.cg_layoutXAxisAnchor(type: anthorType2)
        }
        
        if anthorType1 == .trailing || anthorType1 == .right {
            
            swap(&axisAnchor1, &axisAnchor2)
        }
        
        switch relation {
        case .lessThanOrEqual:
            constraint  = axisAnchor1.constraint(lessThanOrEqualTo: axisAnchor2, constant: constant)
        case .equal:
            constraint  = axisAnchor1.constraint(equalTo: axisAnchor2, constant: constant)
        case .greaterThanOrEqual:
            constraint  = axisAnchor1.constraint(greaterThanOrEqualTo: axisAnchor2, constant: constant)
        }
        
        constraint.isActive = true
        
        return constraint
    }
}

@available (iOS 9.0, *)
// MARK: - NSLayoutYAxisAnchor 类型约束
extension UIView {
    
    func cg_y_constraint(anthorType1: CGViewLayoutYAxisAnchorType, targetView: UIView, anthorType2: CGViewLayoutYAxisAnchorType, relation: CGViewLayoutRelation, constant: CGFloat) -> NSLayoutConstraint {
        
        self.setupSupportAutoLayout()
        
        var axisAnchor1 = self.cg_layoutYAxisAnchor(type: anthorType1)
        var axisAnchor2 : NSLayoutYAxisAnchor
        
        let constraint : NSLayoutConstraint
        
        if #available(iOS 11.0, *) {
            
            axisAnchor2 = targetView.safeAreaLayoutGuide.cg_layoutYAxisAnchor(type: anthorType2)
        } else {
            
            axisAnchor2 = targetView.cg_layoutYAxisAnchor(type: anthorType2)
        }
        
        if anthorType1 == .bottom {
            swap(&axisAnchor1, &axisAnchor2)
        }
        
        switch relation {
        case .lessThanOrEqual:
            constraint  = axisAnchor1.constraint(lessThanOrEqualTo: axisAnchor2, constant: constant)
        case .equal:
            constraint  = axisAnchor1.constraint(equalTo: axisAnchor2, constant: constant)
        case .greaterThanOrEqual:
            constraint  = axisAnchor1.constraint(greaterThanOrEqualTo: axisAnchor2, constant: constant)
        }
        
        constraint.isActive = true
        
        return constraint
    }
}

@available (iOS 9.0, *)
// MARK: - NSLayoutDimension 类型约束
extension UIView {
    
    func cg_constraint(dimensionType1: CGViewLayoutDimension, targetView: UIView, dimensionType2: CGViewLayoutDimension, relation: CGViewLayoutRelation, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        
        self.setupSupportAutoLayout()
        
        let dimension1 = self.cg_layout(dimension: dimensionType1)
        let dimension2 : NSLayoutDimension
        
        let constraint : NSLayoutConstraint
        
        if #available(iOS 11.0, *) {
            
            dimension2 = targetView.safeAreaLayoutGuide.cg_layout(dimension: dimensionType2)
        } else {
            
            dimension2 = targetView.cg_layout(dimension: dimensionType2)
        }
        
        switch relation {
        case .lessThanOrEqual:
            constraint  = dimension1.constraint(lessThanOrEqualTo: dimension2, multiplier: multiplier, constant: constant)
        case .equal:
            constraint  = dimension1.constraint(equalTo: dimension2, multiplier: multiplier, constant: constant)
        case .greaterThanOrEqual:
            constraint  = dimension1.constraint(greaterThanOrEqualTo: dimension2, multiplier: multiplier, constant: constant)
        }
        
        constraint.isActive = true
        
        return constraint
    }
}

@available (iOS 6.0, *)
// MARK: - 直接使用 NSLayoutConstraint
extension UIView {
    
    /// 使用 NSLayoutConstraint 类来处理约束
    func cg_constraint(type1: CGViewLayoutAnchorType, targetView: UIView, type2: CGViewLayoutAnchorType, relation: CGViewLayoutRelation, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint? {
        
        guard let commonView = self.cg_searchCommonSuperview(with: targetView) else {
            assert(false, "视图self和targetView需要公共视图")
            return nil
        }
        
        self.setupSupportAutoLayout()
        
        let constraint = self.cg_constraint(type1: type1, targetObject: targetView, type2: type2, relation: relation, multiplier: multiplier, constant: constant)
        commonView.addConstraint(constraint)
        
        return constraint
    }
}

// MARK: - 一般在 iOS 7 到 iOS 11

@available(iOS, introduced: 7.0, deprecated: 11.0)
// MARK: - 设置UIView 与 UIViewController 之间的约束
extension UIView {
    
    enum CGLayoutGuideType {
        case top
        case bottom
    }
    
    func cg_layoutGuide(type: CGLayoutGuideType, viewController: UIViewController, relation: CGViewLayoutRelation, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint? {
        
        guard let commonView = self.cg_searchCommonSuperview(with: viewController.view) else {
            return nil
        }
        
        self.setupSupportAutoLayout()
        
        let layoutGuide : Any
        let type2 : CGViewLayoutAnchorType
        if type == .top {
            layoutGuide = viewController.topLayoutGuide
            type2       = .bottom
        }else {
            layoutGuide = viewController.bottomLayoutGuide
            type2       = .top
        }
        
        let constraint = self.cg_constraint(type1: .top, targetObject: layoutGuide, type2: type2, relation: relation, multiplier: multiplier, constant: constant)
        commonView.addConstraint(constraint)
        
        return constraint
    }
}

fileprivate extension UIView {
    
    func cg_constraint(type1: CGViewLayoutAnchorType, targetObject: Any, type2: CGViewLayoutAnchorType, relation: CGViewLayoutRelation, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        
        let attribute1  = type1.layoutAttribute()
        let attribute2  = type2.layoutAttribute()
        
        let constantValue : CGFloat
        var relationValue   = relation.relation()
        
        if attribute1 == .trailing || attribute1 == .right || attribute1 == .bottom {
            
            constantValue   = constant * -1
            if relationValue != .equal {
                relationValue   = (relationValue == .greaterThanOrEqual ? .lessThanOrEqual : .greaterThanOrEqual)
            }
        }else {
            
            constantValue   = constant
        }
        
        let constraint  = NSLayoutConstraint.init(item: self, attribute: attribute1, relatedBy: relationValue, toItem: targetObject, attribute: attribute2, multiplier: multiplier, constant: constantValue)
        
        return constraint
    }
}

extension UIView {
    
    func setupSupportAutoLayout() {
        if self.translatesAutoresizingMaskIntoConstraints {
            self.translatesAutoresizingMaskIntoConstraints  = false
        }
    }
}
