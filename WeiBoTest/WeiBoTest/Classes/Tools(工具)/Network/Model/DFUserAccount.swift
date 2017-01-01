//
//  DFUserAccount.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/1.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

class DFUserAccount: NSObject {

    // 网络令牌
    var access_token : String?
    
    // 用户id
    var uid : String?
    
    // 过期时间
    var expires_in : TimeInterval = 0 {
    
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    
    // 过期时间
    var expiresDate : Date?
    
    override var description: String {
    
        return yy_modelDescription()
    }
    
    
    
    
    /*
     1, 编好设置  UserDefaults
     2, 沙盒   归档/plist/json
     3, 数据库 （FMDB/CoreData）
     4, 钥匙串/自动加密 需要使用框架  SSkeyChain
     
     */
    
    // 保存
    func saveAccount() {
    
        // 比下面的多了个 ？  返回的就是可选的了
//        var dictA = (self.yy_modelToJSONObject() as? [String: AnyObject]? ) ?? [:]
        
        var dict = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        
        
        
        
        // 这里移除的是返回不变的值。
        // 这个时间如果是距离1970年的时间，就不用删除了
        dict.removeValue(forKey: "expires_in")
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let filePath = ("useraccount.json" as NSString).cz_appendDocumentDir()
        else {
            return
        }
        
        
        
//        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        
        
        
        let isOK = (data as NSData).write(toFile: filePath, atomically: true)
        
        print((isOK ? "保存成功" : "保存失败") + "地址： \(filePath)")
        
        
    }
    
    
    
}
