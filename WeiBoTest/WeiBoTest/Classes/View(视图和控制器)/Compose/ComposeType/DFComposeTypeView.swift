//
//  DFComposeTypeView.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/16.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit
import pop

class DFComposeTypeView: UIView {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 返回前一页按钮
    @IBOutlet weak var returnButton: UIButton!
    
    /// 关闭按钮约束
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    /// 返回前一页按钮约束
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    
    /// 按钮数据数组
    fileprivate let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "DFComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]
    
    // 完成的回调
    fileprivate var completionBlock : ((_ clsName:String?)->())?
    
    // 实例化方法
    class func composeTypeView() -> DFComposeTypeView {
        
        let nib = UINib.init(nibName: "DFComposeTypeView", bundle: nil)
        
        // 这里代码就会调用 awakeFromNib
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! DFComposeTypeView
        
        v.frame = UIScreen.main.bounds
        
        // 这里需要在 setupUI中添加子控件，要参照父视图的高度，所以要在这句之前设置父视图大小
        v.setupUI()
        
        return v
    }
    
    func show(completion:((_ clsName : String?)->())?){
    
        // oc 中如果一个block 当前方法用不到，通常会使用属性记录它，在需要的时候使用
        // 记录闭包
        
        
        completionBlock = completion
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        self.alpha = 0
        
        vc.view.addSubview(self)
        
        showCurrentView()
        
        
        
    }
    
    /// 关闭视图
    @IBAction func close() {
        hideButtons()
    }
    
    
    /// 点击更多按钮
    @objc private func clickMore() {
        print("点击更多")
        // 1> 将 scrollView 滚动到第二页
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        // 2> 处理底部按钮，让两个按钮分开
        returnButton.isHidden = false
        
        //  两个按钮位于 1/3  2/3 的位置正好， 所以需要 1/2 - 1/6
        let margin = scrollView.bounds.width / 6
        
        closeButtonCenterXCons.constant += margin
        returnButtonCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

    // 返回上一页
    @IBAction func clickReturn() {
        
        // 1. 将滚动视图滚动到第 1 页
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        // 2. 让两个按钮合并
        closeButtonCenterXCons.constant = 0
        returnButtonCenterXCons.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }) { _ in
            self.returnButton.isHidden = true
            self.returnButton.alpha = 1
        }
    }
    
    @objc func clickButton(button : DFComposeTypeButton){
    
        let index = scrollView.contentOffset.x / scrollView.bounds.width
        
        let v = scrollView.subviews[Int(index)]

        for (i, btn) in v.subviews.enumerated().reversed() {
        
            // 缩放动画
            let scaleAnim : POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            //
            let scale = (button == btn) ? 2 : 0.2
            
            // 封装 CGPoint CGRect 等使用 NSValue
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            
            scaleAnim.duration = 0.5
            
            btn.pop_add(scaleAnim, forKey: nil)
            
            
            let alphaAnim : POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            alphaAnim.toValue = 0.2
            
            scaleAnim.duration = 0.5
            
            btn.pop_add(alphaAnim, forKey: nil)
            
            if i == 0 {
                
                print("11")
                
                alphaAnim.completionBlock = { _,_ in
                
                    print("完成回调")
                    // 使用闭包，如果闭包为nil, 就什么也不做
                    self.completionBlock?(button.clsName)
                }
            }
        }
        
    }
}


// MARK: - 动画相关
fileprivate extension DFComposeTypeView {

    /// 隐藏按钮
    func hideButtons(){
    
        // 注意，有两个视图，首先要判断是哪个视图
        let index = scrollView.contentOffset.x / scrollView.bounds.width
        let v = scrollView.subviews[Int(index)]
        
        for (i, btn) in v.subviews.enumerated().reversed() {
        
            let anim : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = btn.center.y
            
            anim.toValue = btn.center.y + 400
            
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            
            btn.pop_add(anim, forKey: nil)
            
            if i == 0 {
                // ((POPAnimation?, Bool) -> Swift.Void)!
                anim.completionBlock = { _, _ in
                    
                    self.hideCurrentView()
                    
                }
            }
        }
    }
    
    /// 隐藏视图
    func hideCurrentView(){
        
        let anim : POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 1
        
        anim.toValue = 0
        
        anim.duration = 0.25
        
        self.pop_add(anim, forKey: nil)
        
        anim.completionBlock = { _, _ in
        
            self.removeFromSuperview()
        }
        
    }
    
    /// 动画显示视图
    func showCurrentView(){
        
        // kPOPViewAlpha  这个是view上面的， 要添加到view上
        let anim : POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 0
        anim.toValue = 1
        
        anim.duration = 0.5
        
        self.pop_add(anim, forKey: nil)
        
        showButtons()
    }
    
    /// 动画显示按钮
    func showButtons(){
    
        // 第一个视图
        let v = scrollView.subviews[0]
        
        for (i, btn) in v.subviews.enumerated() {
        
            let anim : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = btn.center.y + 400
            
            anim.toValue = btn.center.y
            
            // 弹力系数，取值范围 0 - 20 ，数值越大，弹性越大，默认数值 4
            anim.springBounciness = 8
            
            // 弹力速度，取值范围 0 - 20 ，数值越大，速度越快，默认数值 12
            anim.springSpeed = 8
            
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            btn.pop_add(anim, forKey: nil)
        }
        
    }
    
}



// MARK: - UI布局
fileprivate extension DFComposeTypeView {

    func  setupUI() {
        
        // 强制更新布局
        layoutIfNeeded()
        
        // 1. 向 scrollView 添加视图
        let rect = scrollView.bounds
        
        let width = scrollView.bounds.width
        for i in 0..<2 {
            
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            
            // 2. 向视图添加按钮
            addButtons(v: v, idx: i * 6)
            
            // 3. 将视图添加到 scrollView
            scrollView.addSubview(v)
        }
        
        // 4. 设置 scrollView
        // 这里的内容高度为 0 不会影响，只要小于bound.height 就不会滚动，
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        // 禁用滚动
        scrollView.isScrollEnabled = false
        
    }
    
    // 向v添加按钮，按钮在数组中的索引从idx开始
    func addButtons(v: UIView, idx: Int){
        
        // 一个视图最多6个
        let count = 6
        
        for i in idx..<(idx+count){
        
            if i >= buttonsInfo.count {
                break
            }
            
            let dict = buttonsInfo[i]
            
            guard let imageName = dict["imageName"],
                let title = dict["title"] else {
                continue
            }
            
            let btn = DFComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            
            v.addSubview(btn)
            
            // 添加监听方法
            if let actionName = dict["actionName"] {
                // OC 中使用 NSSelectorFromString(@"clickMore")
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            }
            
            // 4> 设置要展现的类名 - 注意不需要任何的判断，有了就设置，没有就不设置
            btn.clsName = dict["clsName"]
        }
        
        // 准备常量
        
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        
        for (i, button) in v.subviews.enumerated() {
        
            // 一排三个，第二排换行
            let y : CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            
            let col = i % 3
            
            // x 与 列有关
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            
            button.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
            
        }
        
        
    }
    

}
