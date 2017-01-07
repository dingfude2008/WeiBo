//
//  UIImage+Extensions.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/7.
//  Copyright © 2017年 dfd. All rights reserved.
//

import Foundation

extension UIImage {
    
    
    /// 创建头像图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景颜色
    ///   - lineColor: 外环线的颜色
    /// - Returns: 裁剪后的图像
    func cz_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        // 这里是为了区别 image 的属性 size 和参数 size
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        
        
        // 1,开始上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        
        // 2,填充背景色
        backColor.setFill()
        UIRectFill(rect)
        
        
        // 3,声明路线，裁切
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        // 4,绘制
        draw(in: rect)
        
        // 5,绘制边线
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        // 6,获得图片
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 7,关闭上下文
        UIGraphicsEndImageContext()
        
        
        // 8,返回图片
        return result
    }
    
    
    
    
    /// 生成指定大小的不透明的图像
    ///
    /// - Parameters:
    ///   - size: 大小
    ///   - backColor: 背景色
    /// - Returns: 结果
    func cz_image(size: CGSize? = nil, backColor: UIColor = UIColor.white) -> UIImage? {
    
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        
        // yes: 不透明， no: 透明
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        backColor.setFill()

        UIRectFill(rect)
        
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        
        draw(in: rect)
        
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
}
