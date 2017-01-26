//
//  CZEmoticonTipView.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/25.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit
import pop

class CZEmoticonTipView: UIImageView {

    /// 之前选择的表情
    private var preEmoticon: CZEmoticon?
    
    
    /// 提示视图的表情模型
    var emoticon: CZEmoticon? {
        didSet {
        
            // 判断表情是否变化
            if preEmoticon == emoticon {
                return
            }
            
            // 记录当前表情
            preEmoticon = emoticon
            
            // 设置表情数据
            tipButton.setTitle(emoticon?.emoji, for: [])
            tipButton.setImage(emoticon?.image, for: [])
            
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = 30
            anim.toValue = 8
            
            anim.springBounciness = 20
            anim.springSpeed = 20
            
            tipButton.layer.pop_add(anim, forKey: nil)
        }
    
    }
    
    
    
    
    
    /// 私有控件
    fileprivate lazy var tipButton = UIButton()
    
    
    /// UIImageView 的构造函数
    init() {
        
        let bundle = CZEmoticonManager.shared.bundle
        
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        // [[UIImage alloc] init] 这个方法会根据图片的大小自动调整 UIImageView 的大小
        
        super.init(image: image)
        
        
        // 设置锚点（定位点） 有了锚点，设置center 就会收到影响，1.2倍的高度，刚好是0.5个表情按钮的高度
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        // 设置锚点的好处是，不用知道大小就能定位
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        // 设置大小，比按钮稍微大一点
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        
        tipButton.center.x = bounds.width * 0.5
        
        tipButton.setTitle("😄", for: [])
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
