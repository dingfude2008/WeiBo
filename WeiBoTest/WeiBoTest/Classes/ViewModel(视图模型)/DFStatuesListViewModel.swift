//
//  DFStatuesListViewModel.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/27.
//  Copyright © 2016年 dfd. All rights reserved.
//

import Foundation
import YYModel
import SDWebImage


// 上拉刷新的最大尝试次数
private let maxPullupTryTimes = 3

class DFStatuesListViewModel {
    
    /// 总的数据源  包含的是单条的视图模型
    lazy var statuesList = [DFStatesViewModel]()
    
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
        let since_id : Int64 = (pullup ? 0 : (statuesList.first?.status.id ?? 0))
        
        let max_id   : Int64 = (!pullup ? 0: (statuesList.last?.status.id ?? 0))
        
        
        DFNetwokrManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            // 网络失败就返回
            if !isSuccess {
                complection(false, false)
                return
            }
            
            var array = [DFStatesViewModel]()
            
            for dict in list ?? []{
                
                guard let model = DFStatue.yy_model(with: dict) else{
                
                    continue
                }
                
                array.append(DFStatesViewModel(model: model))
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
                
                self.cacheSingleImage(list: array, finished: { (isSuccess, shouldRefresh) in
                    
                })
                
                complection(isSuccess, true)
            }
        }
    
    
    }
    
    
    /// 缓存本次下载微博数据中的单张图像   -----> 因为要对单张的图片进行等比例显示，需要缓存后才能获取尺寸
    ///
    /// - Parameters:
    ///   - list: 本次下载的视图模型数组
    ///   - finished: 完成的回调
    fileprivate func cacheSingleImage(list: [DFStatesViewModel], finished: (_ isSuccess: Bool,  _ shouldRefresh: Bool)->()) {
        
        // 调度组
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        
        // 数组中存放的是视图模型
        for vm in list {
            
            let picCount = vm.picURLs?.count
            
            if picCount != 1 || picCount == nil{
            
                continue
            }
            
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL(string: pic) else{
                
                continue
            }
            
            print("要缓存的图片 :\(url)")
            
            
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                
                if let image = image,
                    let data = UIImagePNGRepresentation(image){
                
                    length += data.count
                }
                
                print("缓存图片\(image)的长度为: \(length)")
                
            })
            
        }
        
    }
    
    
}
