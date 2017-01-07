//
//  DFUser.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/7.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

class DFUser: NSObject {

    // 基本数据类型一定要设置默认值0,  
    // 所有属性都必须不能是 private
    var id : Int64 = 0
    
    // 用户昵称
    var screen_name : String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    /// 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = 0
    
    /// 会员等级 0-6
    var mbrank: Int = 0
    
    // 重写只读属性
    override var description: String{
        return yy_modelDescription()
    }
    
}
