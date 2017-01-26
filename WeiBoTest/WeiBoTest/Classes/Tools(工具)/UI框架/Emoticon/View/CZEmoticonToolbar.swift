//
//  CZEmoticonToolbar.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/22.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit

@objc protocol CZEmoticonToolbarDelegate: NSObjectProtocol {
    
    /// 表情工具栏选中分组项索引
    ///
    /// - parameter toolbar: 工具栏
    /// - parameter index:   索引
    func emoticonToolbarDidSelectedItemIndex(toolbar: CZEmoticonToolbar, index: Int)
}

class CZEmoticonToolbar: UIView {

    /// 代理对象
    var delegate : CZEmoticonToolbarDelegate?
    
    
    
    /// 选中分组索引
    var selectedIndex : Int = 0 {
    
        didSet {
            // 1. 取消所有的选中状态
            for btn in subviews as! [UIButton] {
                btn.isSelected = false
            }
            
            // 2. 设置 index 对应的选中状态
            (subviews[selectedIndex] as! UIButton).isSelected = true
        }
    }
    
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
    
    /// 点击分组按钮的方法
    @objc fileprivate func clickItem(btn : UIButton){
        
        // 通知代理执行协议方法
        delegate?.emoticonToolbarDidSelectedItemIndex(toolbar: self, index: btn.tag)
    }

}

fileprivate extension CZEmoticonToolbar {

    func setupUI(){
        
        let manager = CZEmoticonManager.shared
        
        for (i, p) in manager.packages.enumerated() {
        
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
            
            btn.tag = i
            
            btn.addTarget(self, action: #selector(clickItem), for: .touchUpInside)
        }
    
        (subviews[0] as! UIButton).isSelected = true
        
    }
    
}
