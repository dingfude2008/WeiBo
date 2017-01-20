//
//  CZEmoticonPackage.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/20.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit
import YYModel

/// 表情包模型
class CZEmoticonPackage: NSObject {

    /// 表情包的分组名
    var groupName : String?
    
    /// 背景图片名称
    var bgImageName : String?
    
    /// 表情包的目录名，从目录下 info.plist 创建表情模型数组
    /// 设置目录的时候就开始加载 表情数组数据
    var directory : String? {
        didSet{
            
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath) as? [[String : String]],
                let models = NSArray.yy_modelArray(with: CZEmoticon.self, json: array) as? [CZEmoticon]
            else {
                return
            }
            
            for m in models {
                m.directory = directory
            }
            
            emoticons += models
            
            print(emoticons)
            
        }
    }
    
    /// 懒加载的表情模型的空数组
    /// 使用懒加载可以避免后续的解包
    lazy var emoticons = [CZEmoticon]()
    
    override var description: String {
        return yy_modelDescription()
    }
    
}
