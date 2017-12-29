//
//  CGPhotoCollectionViewCell.swift
//  CGPhoto
//
//  Created by DY on 2017/11/30.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

/// 相册列表 cell
class CGPhotoCollectionViewCell: UICollectionViewCell {
    
    let imageView       = UIImageView.init()
    let titleLabel      = UILabel.init()
    let photoTotalLabel = UILabel.init()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setupContentSubviews()
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(photoTotalLabel)
        
        self.setupContentSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置布局 样式
extension CGPhotoCollectionViewCell {
    
    func setupContentSubviews() {
        
        guard let config = CGPhotoLibrarySettingConfig.defalutConfig.photoCollectionConfig?.photoCollectionViewCellConfig else {
            
            photoTotalLabel.textColor   = UIColor.lightGray
            imageView.setupContentMode(.scaleAspectFill)
            
            return
        }
        
        let titleFont   = config.titleFont
        let titleColor  = config.titleColor
        
        let photoTotalFont  = config.photoCountFont
        let photoTotalColor = config.photoCountColor ?? UIColor.lightGray
        
        titleLabel.cg_setup(with: titleFont, textColor: titleColor)
        photoTotalLabel.cg_setup(with: photoTotalFont, textColor: photoTotalColor)
        
        imageView.cornerRadius  = config.cornerRadius
        imageView.contentMode   = config.imageContentMode
    }
    
    func setupContentSubviewsLayout() {
        
        let style = CGPhotoLibrarySettingConfig.defalutConfig.photoCollectionConfig?.photoCollectionViewCellConfig?.style ?? .default
        
        if style == .default {
            
            imageView.cg_autoEdgesInsetsZero(toSuperviewExcludingEdge: .trailing)
            imageView.cg_autoDimensionWidthEqualHeight()
            
            titleLabel.cg_autoConstrain(toSuperviewAttribute: .centerY)
            titleLabel.cg_autoInverseAttribute(.leading, toItem: imageView, constant: 8)
            
            photoTotalLabel.cg_attribute(.centerY, toItem: titleLabel)
            photoTotalLabel.cg_autoInverseAttribute(.leading, toItem: titleLabel, constant: 8)
            photoTotalLabel.cg_autoConstrain(toSuperviewAttribute: .trailing, withOffset: 30, relation: .greaterThanOrEqual)
        }
    }
}
