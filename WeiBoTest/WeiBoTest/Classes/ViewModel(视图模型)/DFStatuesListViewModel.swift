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
    fileprivate func cacheSingleImage(list: [DFStatesViewModel], finished: @escaping (_ isSuccess: Bool,  _ shouldRefresh: Bool)->()) {
        
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
            
            
            // 3> 下载图像
            // 1) downloadImage 是 SDWebImage 的核心方法
            // 2) 图像下载完成之后，会自动保存在沙盒中，文件路径是 URL 的 md5
            // 3) 如果沙盒中已经存在缓存的图像，后续使用 SD 通过 URL 加载图像，都会加载本地沙盒地图像
            // 4) 不会发起网路请求，同时，回调方法，同样会调用！
            // 5) 方法还是同样的方法，调用还是同样的调用，不过内部不会再次发起网路请求！
            // *** 注意点：如果要缓存的图像累计很大，要找后台要接口！
            
            
            // 入组
            group.enter()
            
            
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                
                if let image = image,
                    let data = UIImagePNGRepresentation(image){
                
                    length += data.count
                }
                
                print("缓存图片\(image)的长度为: \(length)")
                
                // 出组。  一定要放在bolck中的最后一句，保证出组
                group.leave()
            })
            
        }
        
        
        group.notify(queue: DispatchQueue.main, execute: {
            
            print("图片缓存完成 大小:\(length / 1024) K")
            
            finished(true, true)
        })
    }
    
    
}
