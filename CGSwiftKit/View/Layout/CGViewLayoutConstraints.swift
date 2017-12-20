//
//  CGViewLayoutConstraints.swift
//  CGPhoto
//
//  Created by DY on 2017/11/29.
//  Copyright © 2017年 DY. All rights reserved.
//

import Foundation

typealias CGLayoutConstraintsReturnValue = Dictionary<CGViewLayoutAnchorType, NSLayoutConstraint>

@available(iOS 9.0, *)
// MARK: - 设置 UIView 相关约束
extension UIView {
    
    func cg_Layout(targetView: UIView, edgeOptions: CGViewLayoutAnchorOptions) -> CGLayoutConstraintsReturnValue {
        return self.cg_layout(targetView: targetView, edgeOptions: edgeOptions, insets: .zero, relation: .equal)
    }
    
    func cg_layout(targetView: UIView, edgeOptions: CGViewLayoutAnchorOptions, insets: UIEdgeInsets, relation: CGViewLayoutRelation) -> CGLayoutConstraintsReturnValue {
        
        var constraints = [CGViewLayoutAnchorType: NSLayoutConstraint]()
        
        if edgeOptions.contains(.top) {
            
            let constraint = self.cg_y_constraint(anthorType1: .top, targetView: targetView, anthorType2: .top, relation: relation, constant: insets.top)
            constraints.updateValue(constraint, forKey: .top)
        }
        
        if edgeOptions.contains(.bottom) {
            
            let constraint = self.cg_y_constraint(anthorType1: .bottom, targetView: targetView, anthorType2: .bottom, relation: relation, constant: insets.bottom)
            constraints.updateValue(constraint, forKey: .bottom)
        }
        
        if edgeOptions.contains(.left) {
            let constraint = self.cg_x_constraint(anthorType1: .left, targetView: targetView, anthorType2: .left, relation: relation, constant: insets.left)
            constraints.updateValue(constraint, forKey: .left)
        }
        
        if edgeOptions.contains(.leading) {
            
            let constraint = self.cg_x_constraint(anthorType1: .leading, targetView: targetView, anthorType2: .leading, relation: relation, constant: insets.left)
            constraints.updateValue(constraint, forKey: .leading)
        }
        
        if edgeOptions.contains(.right) {
            
            let constraint = self.cg_x_constraint(anthorType1: .right, targetView: targetView, anthorType2: .right, relation: relation, constant: insets.right)
            constraints.updateValue(constraint, forKey: .right)
        }
        
        if edgeOptions.contains(.trailing) {
            
            let constraint = self.cg_x_constraint(anthorType1: .trailing, targetView: targetView, anthorType2: .trailing, relation: relation, constant: insets.right)
            constraints.updateValue(constraint, forKey: .trailing)
        }
        
        return constraints
    }
    
    
}
