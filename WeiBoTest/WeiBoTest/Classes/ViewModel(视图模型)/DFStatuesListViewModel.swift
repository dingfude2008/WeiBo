//
//  DFStatuesListViewModel.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/27.
//  Copyright © 2016年 dfd. All rights reserved.
//

import Foundation
import YYModel

class DFStatuesListViewModel {
    
    
    /// 总的数据源
    lazy var statuesList = [DFStatue]()
    
    /// 加载表格数据
    ///
    /// - Parameter complection: 是否完成
    func loadStatus(pullup : Bool, complection:@escaping (_ isSuccess:Bool)->()){
    
        // 最新的数据也就是时间最大的
        let since_id : Int64 = (pullup ? 0 : (statuesList.first?.id ?? 0))
        
        let max_id   : Int64 = (!pullup ? 0: (statuesList.last?.id ?? 0))
        
        
        DFNetwokrManager.shard.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            guard let array = NSArray.yy_modelArray(with: DFStatue.self, json: (list ?? [])) as? [DFStatue]  else {
                // 到这里说明转换失败了，isSuccess 是 false
                complection(isSuccess)
                
                return
            }
            
            print("刷新了\(array.count)条数据")
            
            if pullup {
                
                self.statuesList += array
                
            }else {
                
                self.statuesList = array + self.statuesList
            }
            
            
            complection(isSuccess)
        }
    
    }
    
    
}
