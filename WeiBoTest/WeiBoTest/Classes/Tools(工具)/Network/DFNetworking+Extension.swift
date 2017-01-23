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

    
    /// 获取首页微博数据
    ///
    /// - Parameters:
    ///   - since_id: 最大的id
    ///   - max_id: 最小的id
    ///   - complection: 回调， list: 微博数据， isSuccess:是否成功
    func statusList(since_id : Int64 = 0, max_id : Int64 = 0, complection:@escaping (_ list:[[String: AnyObject]]?, _ isSuccess: Bool)->()){
        
        let urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        
        
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        
        let parameters = ["since_id":"\(since_id)",
                          "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        
        DFNetwokrManager.shared.tokenRequest(URLString: urlString, parameters: parameters as [String : AnyObject]?) { (json, isSuccess) in
            print(json ?? "")
            
            guard let jsonDic = json as? [String : AnyObject],
                let list = jsonDic["statuses"] as? [[String : AnyObject]] else {
                return
            }

            complection(list, isSuccess)
        }
        
    }
    
    func unreadCount(complection:@escaping (_ count:Int) -> ()){
    
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let parameters = ["uid":"\(uid)"]
        
        DFNetwokrManager.shared.tokenRequest(URLString: urlString, parameters: parameters as [String : AnyObject]?) { (json, isSuccess) in
            print(json ?? "")
            
            let dict = json as? [String: AnyObject]
            
            let unreadCount = (dict?["status"] as? Int) ?? 0
            
            complection(unreadCount)
        }
    }
    
    
    func getUid(complection:@escaping (_ uid:Int) -> ()){
        
        let urlString = "https://api.weibo.com/2/account/get_uid.json"
        
        DFNetwokrManager.shared.tokenRequest(URLString: urlString, parameters: nil as [String : AnyObject]?) { (json, isSuccess) in
            print(json ?? "")
            
            let dict = json as? [String: AnyObject]
            
            let uid = (dict?["uid"] as? Int) ?? 0
            
            complection(uid)
        }
    }
}


extension DFNetwokrManager {

    func loadAccessToken(code: String, completion:@escaping(_ isSuccess: Bool)->()){
    
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id" : WBAppKey,
                      "client_secret" : WBAppSecret,
                      "grant_type" : "authorization_code",
                      "code" : code,
                      "redirect_uri" : redirect_uri]
        
        request(method: .POST, URLString: urlString, parameters:params as [String : AnyObject]?) { (json, isSuccess) in
            
            print(json ?? "网络请求失败")
            
            //设置模型
            self.userAccount.yy_modelSet(with: (json as? [String : AnyObject]) ?? [:])
            
            print(self.userAccount)
            
            self.loadUserInfo(complection: { (dict) in
                
                // 再次//设置模型
                self.userAccount.yy_modelSet(with: dict)
                
                // 保存
                self.userAccount.saveAccount()
                
                completion(isSuccess)
            })
        }
    
    }
    
    
    /// 加载用户信息
    ///
    /// - Parameter dict: 返回
    func loadUserInfo(complection: @escaping ([String: AnyObject])->()){
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid" : uid]
        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            complection((json as? [String : AnyObject]) ?? [:])
        }
    }
    
    
}

// MARK: - 发布微博
extension DFNetwokrManager{

    /// 发布微博接口
    ///
    /// - Parameters:
    ///   - text: 文本内容
    ///   - image: 图片
    ///   - complection: 完成回调
    func postStatue(text : String, image:UIImage? = nil, complection:@escaping (_ result:[String:AnyObject]?, _ isSuccess:Bool)->()){
        
        let urlString : String
        
        if image == nil {
            
            urlString = "https://api.weibo.com/2/statuses/update.json"
        }else {
        
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        }
        
        let params = ["status":text]
        
        var data: Data?
        var name: String?
        
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        
        
        tokenRequest(method: .POST, URLString: urlString, parameters: params as [String : AnyObject]?, name: name, data: data) { (json, isSuccess) in
            complection(json as? [String : AnyObject], isSuccess)
        }
        
    }
    
}





































