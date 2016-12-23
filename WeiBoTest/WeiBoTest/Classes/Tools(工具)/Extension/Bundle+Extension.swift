//
//  Bundle+Extension.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/22.
//  Copyright © 2016年 dfd. All rights reserved.
//

import Foundation

extension Bundle {
    
    
    // 返回命名空间
    var namespace : String {
    
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
