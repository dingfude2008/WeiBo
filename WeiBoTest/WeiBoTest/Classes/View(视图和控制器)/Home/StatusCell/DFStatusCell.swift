//
//  DFStatusCell.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/7.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

/// 微博 Cell 的协议
/// 如果需要设置可选的协议
/// - 需要遵守 NSObjectProtocol 协议
/// - 协议需要 @objc
/// - 方法需要 @objc optional

@objc protocol DFStatusCellDelegate : NSObjectProtocol {
    
    // 微博 Cell 中选中  URL 字符串
    @objc optional func statusCellDidSelectedURLString(cell: DFStatusCell, urlString: String)
}

class DFStatusCell: UITableViewCell {

    /// 可选代理
    weak var delegate : DFStatusCellDelegate?
    
    var statusViewModel : DFStatesViewModel? {
        didSet{
            
            /// 设置正文的属性文本
            statusLabel.attributedText = statusViewModel?.statuesAttrText
            
            //  设置转发微博的文字的属性文本
            retweetedLabel?.attributedText = statusViewModel?.retweetedAttrText
            
            /// 设置昵称
            nameLabel.text = statusViewModel?.status.user?.screen_name
            /// 设置会员图标
            memberIconView.image = statusViewModel?.memberIcon
            /// 设置VIP图标
            vipIconView.image = statusViewModel?.vipIcon
            // 设置头像
            iconView.cz_setImage(urlString: statusViewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            /// 设置工具条
            toolBar.viewModel = statusViewModel
            
            
            /// 设置配图视图的视图模型
            pictureView.viewModel = statusViewModel
            
            
            
            sourceLabel.text = statusViewModel?.status.source
        }
    }
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    /// 微博正文
    @IBOutlet weak var statusLabel: FFLabel!
    
    /// 被转发微博的正文 --- 注意：这里是可选的，因为有一个xib中这个控件
    @IBOutlet weak var retweetedLabel: FFLabel?
    
    
    /// 底部视图
    @IBOutlet weak var toolBar: WBStatusToolBar!
    
    /// 配图视图
    @IBOutlet weak var pictureView: DFStatusPictureView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 离屛渲染，异步绘制
        self.layer.drawsAsynchronously = true
        
        // 栅格化，异步绘制之后，会生成一张独立的图像，cell在屏幕滚动的时候，本质上是滚动的这张图片，
        // cell 优化就是要尽可能的较少图层的数量，栅格化成图片就相当于只有一层
        // 停止滚动后，可以接受监听
        self.layer.shouldRasterize = true
        
        // 使用栅格化必须指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}

// MARK: - 实现label的点击协议
extension DFStatusCell : FFLabelDelegate {
    
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        
        // 判断是否是URL
        if !text.hasPrefix("http://") {
            return
        }
        
        // 智能提示建议我们插入 ！ 但是如果插入了 ！ 代理对象没有实现可选的方法就会崩溃
        // 这里插入 ？ 如果代理对象没有实现方法，就什么也不做
        delegate?.statusCellDidSelectedURLString?(cell: self, urlString: text)
        
        
        
    }
    
}


