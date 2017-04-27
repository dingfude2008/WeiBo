//
//  DFAlamofireManager.swift
//  WeiBoTest
//
//  Created by DFD on 2017/2/6.
//  Copyright © 2017年 dfd. All rights reserved.
//

import Foundation
import Alamofire

class DFAlamofireManager {
    
    lazy var userAccount = DFUserAccount()
    
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    
    
}
