//
//  DFStatuesListViewModel.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/27.
//  Copyright © 2016年 dfd. All rights reserved.
//

import Foundation
import YYModel


// 上拉刷新的最大尝试次数
private let maxPullupTryTimes = 3

class DFStatuesListViewModel {
    
    /// 总的数据源
    lazy var statuesList = [DFStatue]()
    
    // 上拉刷新的错误次数
    fileprivate var pullupErrorTimes = 0
    
    /// 加载表格数据
    ///
    /// - Parameter complection: 是否完成  是否成功， 是否需要刷新列表
    func loadStatus(pullup : Bool, complection:@escaping (_ isSuccess:Bool,_ shouldRefresh:Bool)->()){
        
        if pullupErrorTimes > maxPullupTryTimes {
            
            complection(false, false)
            
            return
        }
        
        
        // 最新的数据也就是时间最大的
        let since_id : Int64 = (pullup ? 0 : (statuesList.first?.id ?? 0))
        
        let max_id   : Int64 = (!pullup ? 0: (statuesList.last?.id ?? 0))
        
        
        DFNetwokrManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            guard let array = NSArray.yy_modelArray(with: DFStatue.self, json: (list ?? [])) as? [DFStatue]  else {
                // 到这里说明转换失败了，isSuccess 是 false
                complection(isSuccess, false)
                
                return
            }
            
            print("刷新了\(array.count)条数据 \(array)")
            
            if pullup {
                
                self.statuesList += array
                
            }else {
                
                self.statuesList = array + self.statuesList
            }
            
            
            if pullup && array.count == 0 {
            
                self.pullupErrorTimes += 1
                
                complection(isSuccess, false)
            }
            else {
                complection(isSuccess, true)
            }
            
            
        }
    
    }
    
    
}
