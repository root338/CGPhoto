//
//  CGCollectionProtocolManager.swift
//  CGPhoto
//
//  Created by DY on 2017/11/27.
//  Copyright © 2017年 DY. All rights reserved.
//

import UIKit

/// UICollectionView 必须的动态参数
protocol CGCollectionProtocolDelegate : NSObjectProtocol {
    
    /// UICollectionView 加载的数据类型
//    associatedtype CGCollectionDataSourceModel
    /// 注册的 UICollectionViewCell 的类型， 适合注册单个cell， 多个时可以设置为UICollectionViewCell
//    associatedtype CGRegisterCellView: UICollectionViewCell
    
    /// UICollectionView 加载的数据列表
    ///
    /// - Returns: 返回需要加载的数据列表
    func collectionProtocolDataSourceList(manager: CGCollectionProtocolManager) -> Array<AnyObject>
    
    /// 注册 UICollectionView 需要加载的cell
    ///
    /// - Returns: 返回需要注册的cell类型数组
//    func collectionProtocolRegisterCell(manager: CGCollectionProtocolManager) -> Array< UICollectionViewCell.Type>
    
    /// 设置已加载的cell
    ///
    /// - Parameters:
    ///   - cell: 需要设置的cell
    func collectionProtocol(manager: CGCollectionProtocolManager, cell: UICollectionViewCell, indexPath: IndexPath)
    
    /// 返回注册 cell 的标识
    func collectionProtocol(manager: CGCollectionProtocolManager, cellIdentifierForItemAt indexPath: IndexPath) -> String
}

/// 实现 UICollectionViewDataSurce, UICollectionViewDelegate 协议
class CGCollectionProtocolManager: NSObject, UICollectionViewDataSource {
    
    weak var delegate: CGCollectionProtocolDelegate?
    
    
    
    //MARK:- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let list : [Any] = delegate?.collectionProtocolDataSourceList(manager: self) else {
            return 0
        }
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cellIdentifier = self.delegate?.collectionProtocol(manager: self, cellIdentifierForItemAt: indexPath) else {
            
            assertionFailure("必须有可用加载的cell")
            return UICollectionViewCell.init()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        self.delegate?.collectionProtocol(manager: self, cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    
}
