//
//  CZEmoticonLayout.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/22.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit
/*
 表情集合视图的布局
 */
class CZEmoticonLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
        
        // 设定滚动方向
        // 水平方向滚动，cell 垂直方向布局
        // 垂直布局，   cell 水平方向布局
        scrollDirection = .horizontal
    }
}
