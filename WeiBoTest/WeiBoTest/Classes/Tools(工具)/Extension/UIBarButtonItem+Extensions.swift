
//
//  UIBarButtonItem+Extensions.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/23.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    
    /// 创建 UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize 默认 16
    ///   - target: target
    ///   - action: action
    ///   - isBack: 是否是返回按钮，是的话，加上箭头
    convenience init(title:String, fontSize:CGFloat = 16, target:AnyObject?, action:Selector, isBack:Bool = false) {
    
        let btn : UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.gray, highlightedColor: UIColor.orange)
        
        if isBack {
            let imageName = "navigationbar_back_withtext"
            
            btn.setImage(UIImage(named: imageName), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView:btn)
    }
    
}
