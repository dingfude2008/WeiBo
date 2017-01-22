//
//  CZEmoticonToolbar.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/22.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit

class CZEmoticonToolbar: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
        
    }
    
    
    /// 重写，用来设置自定义控件里面的子视图的布局， 写在这个方法里，可以在手机横竖屏切换的时候再次调用
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = subviews.count
        let w = bounds.width / CGFloat(count)
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        
        for (i, btn) in subviews.enumerated(){
            
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
        
    }

}

fileprivate extension CZEmoticonToolbar {

    func setupUI(){
        
        let manager = CZEmoticonManager.shared
        
        for p in manager.packages {
        
            let btn = UIButton()
            
            btn.setTitle(p.groupName, for: [])
            
            btn.setTitleColor(UIColor.white, for: [])
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            
            // 设置按钮的背景图片
            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            
            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            var imageHL = UIImage(named: imageNameHL, in: manager.bundle, compatibleWith: nil)
            
            // 拉伸图像
            let size = image?.size ?? CGSize()
            let inset = UIEdgeInsets(top: size.height * 0.5,
                                     left: size.width * 0.5,
                                     bottom: size.height * 0.5,
                                     right: size.width * 0.5)
            
            image = image?.resizableImage(withCapInsets: inset)
            imageHL = imageHL?.resizableImage(withCapInsets: inset)
            
            btn.setBackgroundImage(image, for: [])
            btn.setBackgroundImage(imageHL, for: .highlighted)
            btn.setBackgroundImage(imageHL, for: .selected)
            
            
            btn.sizeToFit()
            
            addSubview(btn)
            
        }
    
    }
    
}
