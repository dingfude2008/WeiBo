//
//  DFVisitorView.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/25.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

class DFVisitorView: UIView {

    
    // MARK: 设置访客视图信息
    ///
    /// - Parameter dict: [imageName / message]
    var visitorInfo : [String: String]? {
    
        didSet{
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else{
                return
            }
            
            tipLabel.text = message
            
            // 设置头像，如果是首页不用设置
            if imageName == "" {
                
                startAnimation()
                
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            houseIconView.isHidden = true
            
            maskIconView.isHidden = true
            
        }
    
    }
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init(coder aDecoder : NSCoder){
    
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    
    
    
    /// 私用控件
    fileprivate lazy var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    // 遮罩视图
    fileprivate lazy var maskIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    
    fileprivate lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    fileprivate lazy var tipLabel : UILabel = UILabel.cz_label(
        withText: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜",
        fontSize: 14,
        color: UIColor.darkGray)

    fileprivate lazy var registerButton : UIButton = UIButton.cz_textButton(
        "注册",
        fontSize: 16,
        normalColor: UIColor.orange,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
    
    
    fileprivate lazy var loginButton : UIButton = UIButton.cz_textButton(
        "登陆",
        fontSize: 16,
        normalColor: UIColor.darkGray,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
    
    
    
    
    

}


extension DFVisitorView {

    func setupUI(){
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        // 1, 添加布局
        addSubview(iconView)
        
        addSubview(maskIconView)
        
        addSubview(houseIconView)
        
        addSubview(tipLabel)
        
        addSubview(registerButton)
        
        addSubview(loginButton)
        
        tipLabel.textAlignment = .center
        
        // 2,取消 autoresizing
        // 纯代码默认开启 autoresizing
        // xib  默认凯斯  autoLayout
        
        
        // 现在取消默纯代码默认的 autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let margin : CGFloat = 20.0
        
        // 3 自动布局
        // 图像视图
        
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -60))
        
        // 小房子
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        // 提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 236))
        
        // 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        
        // 登陆按钮
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
        
        // 遮罩头像
        
        // 定义 VFL 中控件名称与实际名称的映射关系
        let viewDict = ["maskIconView":maskIconView,
                        "registerButton":registerButton] as [String : Any];
        
        // 定义 VFL 中 （）指定的常数映射关系
        let metrics = ["spacing":20]
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDict))
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
            options: [],
            metrics: metrics,
            views: viewDict))
        
        
    }
    
    
    
    
    func startAnimation() {
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * M_PI
        
        anim.duration = 15
        
        anim.repeatCount = MAXFLOAT
        
        // 完成动画不删除， 如果 iconView被释放， 也一同销毁
        // home 切换也会接着动画
        anim.isRemovedOnCompletion = false
        
        iconView.layer.add(anim, forKey: nil)
        
    }
    
    

}
