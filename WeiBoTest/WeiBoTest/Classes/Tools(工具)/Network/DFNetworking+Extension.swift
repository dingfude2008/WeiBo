//
//  DFNetworking+Extension.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/26.
//  Copyright © 2016年 dfd. All rights reserved.
//

import Foundation


// MARK: - 封装具体的业务请求
extension DFNetwokrManager {

    func statusList(since_id : Int64 = 0, max_id : Int64 = 0, complection:@escaping (_ list:[[String: Any]]?, _ isSuccess: Bool)->()){
        let urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        
        
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        
        let parameters = ["since_id":"\(since_id)",
                          "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        
        DFNetwokrManager.shard.tokenRequest(URLString: urlString, parameters: parameters as [String : AnyObject]?) { (json, isSuccess) in
            print(json ?? "")
            
            guard let jsonDic = json as? [String : AnyObject],
                let list = jsonDic["statuses"] as? [[String : AnyObject]] else {
                return
            }

            complection(list, isSuccess)
        }
        
    }

}
