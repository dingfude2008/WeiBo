//
//  Date+Extensions.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/25.
//  Copyright © 2017年 dfd. All rights reserved.
//

import Foundation

/// 日期格式化器， 不要频繁创建和释放，会影响性能
fileprivate let dataFormatter = DateFormatter()

/// 当前的日历对象
fileprivate let calender = Calendar.current

// Data 是个结构体
extension Date {

    
    /// 计算与当前系统偏差 delta 秒数的日期字符串
    /// 在 swift 中， 定义结构体的'类方法'，需要使用 static 代替 class 方法  -> 静态函数
    static func cz_dateString(delta : TimeInterval) -> String{
    
        let date = Date(timeIntervalSinceNow: delta)
        
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dataFormatter.string(from: date)
    }

}
