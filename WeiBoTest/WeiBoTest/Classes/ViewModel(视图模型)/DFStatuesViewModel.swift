//
//  DFStatuesViewModel.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/7.
//  Copyright © 2017年 dfd. All rights reserved.
//

import Foundation

/*
 
 一个类没有任何父类，如果想要进行开发调试，
 1，需要实现 CustomStringConvertible 协议，
 2，实现 description 属性
 
 
 关于表格的优化，
 
 1， 尽量少计算 （ 尽量少在cell中计算，所有的素材都提前准备好 ）
 2， 控件不要设置圆角半径，所有图像渲染的属性，都要注意
 3， 不用动态创建控件，都要提前创建好，在显示的时候，根据数据显示/隐藏
 4， Cell 中层次越少越好，控件的数量越少越好。  
    有人把一个Cell全部封装进一个UIImageView中，根据点击的位置来进行交互。这种虽说繁琐，但是速度很快
 5， 要测量，不要猜测
 
 */

/// 单条微博的视图模型
class DFStatesViewModel : CustomStringConvertible {
    
    /// 微博模型
    var status : DFStatue
    
    /// 会员图标  -- 存储性属性，用内存换CPU
    var memberIcon : UIImage?
    
    /// VIP图标 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var vipIcon : UIImage?
    
    
    /// 构造函数
    ///
    /// - Parameter model: 视图模型
    init(model : DFStatue) {
        self.status = model
        
        if let mbrank = model.user?.mbrank {
            print("------------ > \(mbrank)")
            if mbrank > 0 && mbrank < 7 {
                let imageName = "common_icon_membership_level\(mbrank)"
                memberIcon = UIImage(named: imageName)
            }
        }
        
        switch model.user?.verified_type ?? -1 {
            case 0:
                vipIcon = UIImage(named: "avatar_vip")
            case 2, 3, 5:
                vipIcon = UIImage(named: "avatar_enterprise_vip")
            case 220:
                vipIcon = UIImage(named: "avatar_grassroot")
            default:
                break
        }
        
    }
    
    var description : String {
        
        return status.description
    }
    
}
