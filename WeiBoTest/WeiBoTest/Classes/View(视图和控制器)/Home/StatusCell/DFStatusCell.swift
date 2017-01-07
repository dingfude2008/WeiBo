//
//  DFStatusCell.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/7.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

class DFStatusCell: UITableViewCell {

    var statusViewModel : DFStatesViewModel? {
        didSet{
            
            /// 设置正文
            statusLabel.text = statusViewModel?.status.text
            /// 设置昵称
            nameLabel.text = statusViewModel?.status.user?.screen_name
            /// 设置会员图标
            memberIconView.image = statusViewModel?.memberIcon
            /// 设置VIP图标
            vipIconView.image = statusViewModel?.vipIcon
            iconView.cz_setImage(urlString: statusViewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            toolBar.viewModel = statusViewModel
            
            pictureView.heigthCons.constant = 100
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
    @IBOutlet weak var statusLabel: UILabel!
    
    /// 底部视图
    @IBOutlet weak var toolBar: WBStatusToolBar!
    
    /// 配图视图
    @IBOutlet weak var pictureView: DFStatusPictureView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
