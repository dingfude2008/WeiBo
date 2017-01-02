//
//  DFNetwokrManager.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/26.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit
import AFNetworking

enum DFHTTPMethod {
    case GET
    case POST
}

class DFNetwokrManager: AFHTTPSessionManager {

    // 分布在静态去， 常量，闭包
    // 等于
    //static let shared = DFNetwokrManager()
    
    static let shared : DFNetwokrManager = {
        
        let instance = DFNetwokrManager()
        
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    

    
    lazy var userAccount = DFUserAccount()
    
    // 网络令牌
//    var accessToken : String? //  = "2.0055AFfCxR3neD64a0a1e2b7qMS3WE" // 默认值
//    
//    
//    // 用户id
//    var uid : String?  = "2439288592"
    
    
    /// 计算性属性（只读属性，省略了 get）
    var userLogon : Bool {
        
//        get {
//           return DFNetwokrManager.shared.accessToken != nil
//        }
        
        return userAccount.access_token != nil
    }
    
    
    
    
    func tokenRequest(method : DFHTTPMethod = .GET, URLString : String, parameters:[String: AnyObject]?, complection:@escaping (_ json : Any?, _ isSuccess: Bool)->()){
        
        
        guard let token = userAccount.access_token  else {
            
            //  toke 过期
            //  发送通知登陆，下次请求的时候检查发现就直接跳转登陆界面
            print("token 为 nil")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeiBoTestUserShouldLoginNotification), object: nil)
            
            complection(nil, false)
            
            return
            
        }
        
        var parameters = parameters
        
        if parameters == nil {
            
            parameters = [String : AnyObject]()
        }
        
        parameters!["access_token"] = token as AnyObject
        
        request(URLString: URLString, parameters: parameters, complection: complection)
        
    }
    
    func request(method : DFHTTPMethod = .GET, URLString : String, parameters:[String: AnyObject]?, complection:@escaping (_ json : Any?, _ isSuccess: Bool)->()) {
        
        let success = { (task : URLSessionDataTask, json: Any?)->() in
            complection(json, true)
        }
        
        
        let failure = { (task : URLSessionDataTask?, error: Error)->() in
            
            // token 过期
            if (task?.response as? HTTPURLResponse)?.statusCode == 400 {
                // print(error)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeiBoTestUserShouldLoginNotification), object: "bad token")
            }
            
            print(error)
            complection(nil, false)
        }
        
        
        if method == .GET {
            
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
            
        }else {
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
   
    }
    
}
