//
//  CZEmoticonManager.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/19.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit
//import Foundation

class CZEmoticonManager {

    // swift 单例
    //
    
    static let shared = CZEmoticonManager()
    
    /// 表情包的懒加载数组  使用懒加载后，第一次加载就会初始化为空数组
    /// 第一组为最近表情
    lazy var packages = [CZEmoticonPackage]()

    /// 构造函数， 如果在init 之前增加 private 可以让调用在必须走shared调用对象
    /// oc 要重写 allocWithZone 方法
    private init(){
        loadPackages()
    }
}

// MARK: - 表情字符串的处理
extension CZEmoticonManager {

    
    /// 将给定的文本转换为属性稳步
    ///  注意，替换的时候应该倒叙遍历，因为替换的时候，Range在不断的变化，从后向前遍历就可以避免
    /// - Parameters:
    ///   - string: 字符串
    ///   - font: 字体大小
    /// - Returns: 属性文本
    func emoticonString(string: String, font:UIFont) -> NSAttributedString {
    
        let attrString = NSMutableAttributedString(string: string)
        
        let pattern = "\\[.*?\\]"
        
        guard let reg = try? NSRegularExpression(pattern: pattern, options: [])
            else {
            return attrString
        }
        
        let matchs = reg.matches(in: string, options: [], range: NSMakeRange(0, attrString.length))
        
        for m in matchs.reversed() {
        
            let r = m.rangeAt(0)
            
            let subStr = (attrString.string as NSString).substring(with: r)
            
            if let em = findEmoticon(string: subStr) {
                
                attrString.replaceCharacters(in: r, with: em.imageText(font: font))
            }
            
            print(subStr)
        }
        
        
        return attrString
    }
    
    
    /// 根据 string `[爱你]` 在所有的表情符号中查找对应的表情模型对象
    /// 如果找到就返回表情模型， 否则返回nil
    func findEmoticon(string : String) -> CZEmoticon? {
        
        // 1，遍历表情包
        // 2，OC中过滤数组使用 [谓词]
        // 3，swift 直接使用 filter
        for p in packages {
        
            // 方法1
//            let result = p.emoticons.filter({ (em) -> Bool in
//                em.chs == string
//            })
            
            // 方法2 尾随闭包
//            let result = p.emoticons.filter(){ (em) -> Bool in
//                return em.chs == string
//            }
            
            // 方法3 尾随闭包
            // 如果闭包中只有一句，并且是返回
            // 1>闭包的格式可以省略
            // 2>格式省略后，参数使用 $0, $1... 代替
//            let result = p.emoticons.filter(){
//                return $0.chs == string
//            }
            
            
            // 方法4 尾随闭包
            // 如果闭包中只有一句，并且是返回
            // 1>闭包的格式可以省略
            // 2>格式省略后，参数使用 $0, $1... 代替
            // return 也可以省略
            let result = p.emoticons.filter() { $0.chs == string }
            
            if result.count == 1 {
                return result[0]
            }
        }
        
        return nil
    }
    
}



fileprivate extension CZEmoticonManager {
    
    func loadPackages(){
    
        // 获取bundle的路径
        // 获取bundle
        // 获取 emticons.plist
        //
        //
        //
        
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
            let models = NSArray.yy_modelArray(with: CZEmoticonPackage.self, json: array) as? [CZEmoticonPackage]
            else {
                return
        }
        /// 设置表情包数据
        /// 使用 += 不会给懒加载 packages 重新分配空间，直接追加数据
        packages += models
        
        print(packages)
    }
}
