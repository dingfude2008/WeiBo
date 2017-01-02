//
//  DFTitleButton.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/2.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

class DFTitleButton: UIButton {

    
    /// 重载构造函数
    ///
    /// - Parameter title: 标题
    init(title: String?){
    
        super.init(frame: CGRect())

        if title == nil {
        
            setTitle("首页", for: [])
        }else {
        
            setTitle(title! + " ", for: [])
            
            setImage(UIImage(named:"navigationbar_arrow_down"), for: [])
            setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        }
        
        /// 粗体
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        setTitleColor(UIColor.gray, for: [])
        
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    /// 重写
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 判断同时存在，如果是首页，就不需要了
        guard let titleLabel = titleLabel,
            let imageView = imageView else {
            return
        }
        
        titleLabel.frame.origin.x = 0
        
        imageView.frame.origin.x = titleLabel.frame.size.width
        
    }
    
}
