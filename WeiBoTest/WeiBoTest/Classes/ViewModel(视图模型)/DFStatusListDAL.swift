//
//  DFStatusListDAL.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/23.
//  Copyright © 2017年 dfd. All rights reserved.
//

import Foundation


/*
    DAL - Data Access Layer 数据访问层
    使命：负责处理数据库和网络数据，给ListViewModel返回微博的 字典数组
    在调整系统的时候，尽量做最小的调整
 */
class DFStatusListDAL {

    /// 从本地数据库或者网络数据库加载数据
    ///
    /// - Parameters:
    ///   - since_id: 下拉刷新id
    ///   - max_id: 上拉刷新id
    ///   - complection: 完成回调（微博的字典数组， 是否成功）
    class func loadStatus(since_id : Int64 = 0, max_id : Int64 = 0, complection:@escaping (_ list:[[String: AnyObject]]?, _ isSuccess: Bool)->()){
        
        // 0, 检测用户Id
        guard let userId = DFNetwokrManager.shared.userAccount.uid else {
            return
        }
        
        // 1, 检查本地数据，如果有就直接返回
        let array = CZSQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        if array.count > 0 {
            
            complection(array, true)
            return
        }
        
        // 2, 加载网络数据
        DFNetwokrManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if !isSuccess {
            
                complection(nil, false)
                return
            }
            
            guard let list = list else {
                
                complection(nil, isSuccess)
                return
            }
            
            // 3, 加载完成之后，将网络数据[字典数组], 写入数据库
            CZSQLiteManager.shared.updateStatus(userId: userId, array: list as [[String : AnyObject]])
            
            // 4, 返回网络数据
            complection(list, isSuccess)
        }
    }
    
    
}
