//
//  DFComposeTypeButton.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/17.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

class DFComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 点击按钮要展现控制器的类型
    var clsName: String?
    
    /// 使用图像名称／标题创建按钮，按钮布局从 XIB 加载
    class func composeTypeButton(imageName: String, title: String) -> DFComposeTypeButton {
        
        let nib = UINib(nibName: "DFComposeTypeButton", bundle: nil)
        
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! DFComposeTypeButton
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        
        return btn
    }

}
