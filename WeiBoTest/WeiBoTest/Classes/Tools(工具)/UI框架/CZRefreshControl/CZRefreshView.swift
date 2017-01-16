//
//  CZRefreshView.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/13.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit

/// 刷新视图，负责刷新相关的 ‘UI’动画
class CZRefreshView: UIView {

    
    
    /*
     iOS 系统中 UIView 封装的东湖
     - 默认是顺时针旋转
     - 就近原则
     - 要实现同方向旋转（比如顺时针转180， 然后再按照原路返回）， 旋转的角度需要减去一个很小的数值，这样就近原则就原路返回了
     - 如果像旋转360度，需要使用 CABaseAnimation 核心动画
     */
    
    
    /// 当前状态
    var refreshState : CZRefreshState = .Normal {
        didSet{
            switch refreshState {
            case .Normal:
                
                tipIcon.isHidden = false
                
                indicator.stopAnimating()
                
                tipLabel.text = "继续使劲拉"
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform.identity
                })
            case .Pulling:
                tipLabel.text = "放手就刷新"
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.0001))
                })
                
//                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//                animation.fromValue = 0
//                animation.toValue = 2 * M_PI
//                animation.duration = 0.25
//                animation.isRemovedOnCompletion = false
//                animation.fillMode = kCAFillModeForwards
//
//                tipIcon.layer.add(animation, forKey: nil)
//                
                
            case .WillRefresh:
                tipLabel.text = "正在刷新中..."
                
                tipIcon.isHidden = true
                
                indicator.startAnimating()
                
                
                
            }
        }
    
    }
    
    /// 提示图片
    @IBOutlet weak var tipIcon: UIImageView!

    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel!
    
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    class func refreshView() -> CZRefreshView{
        
        let nib = UINib(nibName: "CZRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! CZRefreshView
    
    }
    
}
