//
//  CZEmoticon.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/20.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit
import YYModel


/// 表情模型
class CZEmoticon: NSObject {
    
    /// 类型。  false:图片表情  true:emoji
    var type:Bool = false
    
    /// 表情字符串，发送给服务器的（节约流量）
    var chs : String?
    
    /// 表情图片的名称，用于本地的图文混排
    var png : String?
    
    /// emoji的十六进制编码
    var code : String?
    
    /// 表情模型所在的目录  这个属性是为了，让图片加载的更方便，因为只有加上目录，才能加载图片
    var directory: String?
    
    var image: UIImage? {
        
        // emoji 就返回nil
        if type {
           return nil
        }
        
        guard let png = png,
            let directory = directory,
            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path)
            else {
            return nil
        }
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    /// 将当前的图像转换生成图片的属性文本
    ///
    /// - Parameter font: 字体
    /// - Returns: 属性文本
    func imageText(font : UIFont) -> NSAttributedString {
        
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        let attachment = NSTextAttachment()
        
        attachment.image = image
        
        let height = font.lineHeight
        
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        return NSAttributedString(attachment: attachment)
    }
    
    
    
    
    

    /// 重写属性
    override var description: String{
        return yy_modelDescription()
    }
    
}
