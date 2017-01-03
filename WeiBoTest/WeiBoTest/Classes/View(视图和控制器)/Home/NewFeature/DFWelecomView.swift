//
//  DFWelecomView.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/2.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit
import SDWebImage



class DFWelecomView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    @IBOutlet weak var iconWidthCons: NSLayoutConstraint!
    
    
    /// 类方法
    class func welecomView() -> DFWelecomView{
        
        let nib = UINib(nibName: "DFWelecomView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! DFWelecomView
        
        v.frame = UIScreen.main.bounds
        
        return v
    }

    
    
    /// xib 加载 ， 更改UI
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let icon = DFNetwokrManager.shared.userAccount.avatar_large,
            let url = URL(string: icon) else {
            return
        }
        
        iconView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "avatar_default_big"))
        
        /// FIXME
        // 因为在 awakeFromNib 中， 布局还没有生效所以没有 iconView.bounds.width * 0.5 不生效
        iconView.layer.cornerRadius = iconWidthCons.constant * 0.5
        iconView.layer.masksToBounds = true
    }
    
    
    /// 重写声明周期
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
    
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: { 
                        
                        self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: { 
                self.tipLabel.alpha = 1.0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
    
}
