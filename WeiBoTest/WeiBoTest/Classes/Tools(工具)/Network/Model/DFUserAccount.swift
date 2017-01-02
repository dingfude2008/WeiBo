//
//  DFUserAccount.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/1.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

fileprivate let accountFile : NSString = "useraccount.json"


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
    
    
    override init() {
    
        super.init()
        
        // 从磁盘中加载json -> 字典
        guard let path = accountFile.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) else {
            return
        }
        
        
        // 字典转模型 设置属性值
        self.yy_modelSet(withJSON: dict)
        
        
        // token 过期的处理
        
//        expiresDate = Date(timeIntervalSinceNow: -3600 * 24)
        
        if expiresDate?.compare(Date()) != .orderedDescending {
            // token 过期
            
            
            access_token = nil
            
            uid = nil
            
            // 删除 本地文件
            try? FileManager.default.removeItem(atPath: path)
            
        }
    
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
            let filePath = accountFile.cz_appendDocumentDir()
        else {
            return
        }
        
        let isOK = (data as NSData).write(toFile: filePath, atomically: true)
        
        print((isOK ? "保存成功" : "保存失败") + "地址： \(filePath)")
        
        
    }
    
    
    
}
