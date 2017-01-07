//
//  DFStatue.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/27.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

class DFStatue: NSObject {
    
    /// Int 类型，在 64 位是64位，在 32位机器就是32位
    /// 如果不行 Int64, 在 iPad 2, iPhone5, 5C， 4 上不能正常运行
    var id : Int64 = 0
    
    /// 微博信息内容
    var text: String? = ""
    
    /// 转发数
    var reposts_count: Int = 0
    /// 评论数
    var comments_count: Int = 0
    /// 点赞数
    var attitudes_count: Int = 0
    
    /// 微博的用户 - 注意和服务器返回的 KEY 要一致 因为 返回的这个微博JSon中含有一个 user的对象
    var user: DFUser?
    
    /// 微博配图模型数组
    var pic_urls:[DFStatusPicture]?
    
    
    /// 重写计算性属性
    override var description: String{
        return yy_modelDescription()
    }
    
    
    /// 返回 数组中的模型是什么类的
    /// NSAarray 中通常存的是 'id'类型
    /// OC 中的泛型是为了兼容 Swift 才添加的，
    /// 从运行时的角度，仍然不知道数组中存放的是什么对象
    /// - Returns: 映射字典
    class func modelContainerPropertyGenericClass() -> [String : AnyClass]{
        return ["pic_urls": DFStatusPicture.self]
    }
    
}
