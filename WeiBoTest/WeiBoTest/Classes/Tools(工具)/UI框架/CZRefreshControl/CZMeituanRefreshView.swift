//
//  CZMeituanRefreshView.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/16.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit

class CZMeituanRefreshView: CZRefreshView {

    override var parentViewHeight : CGFloat {
        didSet{
            //print("父视图的高度为：\(parentViewHeight)")
            
            // 最小到 23
            if parentViewHeight < 23 {
                return
            }
            
            var scale : CGFloat
            
            if parentViewHeight > 126 {
                scale = 1
            }else {
                scale = 1 - ((126 - parentViewHeight) / (126 - 23))
            }
            
            kangarooIconView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }
    }
    
    @IBOutlet weak var buildingIconView: UIImageView!

    @IBOutlet weak var earthIconView: UIImageView!

    @IBOutlet weak var kangarooIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1 房子
        //let bImage1 = UIImage(named: "icon_building_loading_1")
        let bImage1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bImage2 = #imageLiteral(resourceName: "icon_building_loading_2")
        
        buildingIconView.image = UIImage.animatedImage(with: [bImage1, bImage2], duration: 0.5)
        
        // 地球
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = -2 * M_PI
        
        anim.duration = 3
        
        anim.repeatCount = MAXFLOAT
        
        anim.isRemovedOnCompletion = false
        
        earthIconView.layer.add(anim, forKey: nil)
        
        
        let kImage1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let kImage2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        
        kangarooIconView.image = UIImage.animatedImage(with: [kImage1, kImage2], duration: 0.5)
        
        // 袋鼠  下拉的时候，袋鼠会变大，并且变大到一定比例就不再变大了。并且一直站在地球上
        
        //  1 设置锚点  锚点的总宽高是1， 从上到下，  0.5代表着中间
        kangarooIconView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        //  2 设置frame / center 必须设置这个，不然锚点不会生效
        
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 23
        kangarooIconView.center = CGPoint(x: x, y: y)
        
        //  3 改动大小
        kangarooIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        
    }
}
