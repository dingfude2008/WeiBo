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
    var expires_in : TimeInterval = 0
    
    
    override var description: String {
    
        return yy_modelDescription()
    }
    
    
    
    
}
