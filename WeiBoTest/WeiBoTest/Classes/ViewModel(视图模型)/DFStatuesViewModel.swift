//
//  DFStatuesViewModel.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/7.
//  Copyright © 2017年 dfd. All rights reserved.
//

import Foundation

/// 单条微博的视图模型
class DFStatesViewModel {
    
    /// 微博模型
    var status : DFStatue
    
    /// 构造函数
    ///
    /// - Parameter model: 视图模型
    init(model : DFStatue) {
        self.status = model
    }
    
}
