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
    
    /// 表情使用次数
    var times : Int = 0
    
    /// emoji的十六进制编码
    var code : String? {
        didSet{
            
            guard let code = code else{
                return
            }
            
            let scanner = Scanner(string: code)
            
            // 无符号16进制整数
            var result : UInt32 = 0
            scanner.scanHexInt32(&result)
            
            guard let unicodeScalar = UnicodeScalar(result)
                else {
                return
            }
            
            emoji = String(Character(unicodeScalar))
        }
    }
    
    /// emoji字符串
    var emoji:String?
    
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
        
        let attachment = CZEmoticonAttachment()
        
        // 在这里记住 chs, 可以在获取的时候获得
        attachment.chs = chs
        
        attachment.image = image
        
        let height = font.lineHeight
        
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        // 插入的字符的显示，跟随前一个字符的属性，但是本身没有属性，所以，这里需要把前一个字符的属性赋值给自己
        let attrStrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        // 因为只输入一个字符，所以使用 NSMakeRange(0, 1)  这是使用 addAttributes 不能使用setAttributes
        attrStrM.addAttributes([NSFontAttributeName:font], range: NSMakeRange(0, 1))
        
        return attrStrM
    }
    
    
    
    
    

    /// 重写属性
    override var description: String{
        return yy_modelDescription()
    }
    
}
