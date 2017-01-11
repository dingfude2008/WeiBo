//
//  DFStatuesViewModel.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/7.
//  Copyright © 2017年 dfd. All rights reserved.
//

import Foundation

/*
 
 一个类没有任何父类，如果想要进行开发调试，
 1，需要实现 CustomStringConvertible 协议，
 2，实现 description 属性
 
 
 关于表格的优化，
 
 1， 尽量少计算 （ 尽量少在cell中计算，所有的素材都提前准备好 ）
 2， 控件不要设置圆角半径，所有图像渲染的属性，都要注意
 3， 不用动态创建控件，都要提前创建好，在显示的时候，根据数据显示/隐藏
 4， Cell 中层次越少越好，控件的数量越少越好。  
    有人把一个Cell全部封装进一个UIImageView中，根据点击的位置来进行交互。这种虽说繁琐，但是速度很快
 5， 要测量，不要猜测
 
 */

/// 单条微博的视图模型
class DFStatesViewModel : CustomStringConvertible {
    
    /// 微博模型
    var status : DFStatue
    
    /// 会员图标  -- 存储性属性，用内存换CPU
    var memberIcon : UIImage?
    
    /// VIP图标 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var vipIcon : UIImage?
    
    /// 转发文字
    var retweetedStr: String?
    /// 评论文字
    var commentStr: String?
    /// 点赞文字
    var likeStr: String?
    
    /// 被转发的文字
    var retweetedAttrText: String?
    
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    /// 微博的最终配图。 如果是原创微博，就显示原创微博的图片。如果是转发的微博就显示被转发的图片
    /// 也可能是空
    var picURLs : [DFStatusPicture]? {
        // 计算性属性
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    
    /// 行高
    var rowHeight: CGFloat = 0
    
    /// 构造函数
    ///
    /// - Parameter model: 视图模型
    init(model : DFStatue) {
        self.status = model
        
        if let mbrank = model.user?.mbrank {
            print("------------ > \(mbrank)")
            if mbrank > 0 && mbrank < 7 {
                let imageName = "common_icon_membership_level\(mbrank)"
                memberIcon = UIImage(named: imageName)
            }
        }
        
        switch model.user?.verified_type ?? -1 {
            case 0:
                vipIcon = UIImage(named: "avatar_vip")
            case 2, 3, 5:
                vipIcon = UIImage(named: "avatar_enterprise_vip")
            case 220:
                vipIcon = UIImage(named: "avatar_grassroot")
            default:
                break
        }
        
        // 测试
        // model.reposts_count = Int(arc4random_uniform(100000))
        
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.reposts_count, defaultStr: "赞")
        
        
//        pictureViewSize = calcPictureViewSize(count: model.pic_urls?.count)
        // 使用最终的结果
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        retweetedAttrText = "@"
            + (status.retweeted_status?.user?.screen_name ?? "")
            + ":"
            + (status.retweeted_status?.text ?? "")
        
        // 计算行高
        updateRowHeight()
    }
    
    
    /// 使用单个图像，更新配图视图的大小
    ///
    /// 新浪针对单张图片，都是缩略图，但是偶尔会有一张特别大的图 7000 * 9000 多
    /// 新浪微博，为了鼓励原创，支持`长微博`，但是有的时候，有特别长的微博，长到宽度只有1个点
    ///
    /// - parameter image: 网路缓存的单张图像
    func updateSingleImageSize(image: UIImage){
        
        var size = image.size
        
        size.height += DFStatusPictureViewOutterMargin
        
        pictureViewSize = size
        
        // 更新行高
        updateRowHeight()
    }
    
    var description : String {
        
        return status.description
    }
    
    
    /// 根据当前的视图模型计算行高
    func updateRowHeight(){
        
        // 原创微博：顶部分隔视图(12) + 间距(12) + 图像的高度(34) + 间距(12) + 正文高度(需要计算, 字体15， 总宽 - 2 * margin) + 配图视图高度(计算) + 间距(>=12) ＋ 底部视图高度(35)
        // 被转发微博：顶部分隔视图(12) + 间距(12) + 图像的高度(34) + 间距(12) + 正文高度(需要计算 字体15, 总宽 - 2 * margin) + 间距(12)+间距(12)+转发文本高度(需要计算，字体14,总宽 - 2 * margin) + 配图视图高度(计算) + 间距(12) ＋ 底部视图高度(35)
        
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        // 显示尺寸
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        let originalFont  = UIFont.systemFont(ofSize: 15)
        let retweetedFont  = UIFont.systemFont(ofSize: 14)
        
        
        
        var height: CGFloat = 0
        
        
        height += 2 * margin + iconHeight + margin
        
        // 2. 正文属性文本的高度
        /*
         1,预期尺寸，宽度固定，高度尽量大
         2,选项， 换行文本， 统一使用 userLineFrameOrign
         3,attributes 指定字体字典
         
         */
    
        if let text = status.text {
        
            height += (text as NSString).boundingRect(with: viewSize,
                                                      options: [.usesLineFragmentOrigin],
                                                      attributes: [NSFontAttributeName :  originalFont],
                                                      context: nil).height
        }
        
        if status.retweeted_status != nil {
        
            height += 2 * margin
            
            // 转发文本的高度 - 一定用 retweetedAttrText，拼接了 @用户名:微博文字
            if let text = retweetedAttrText {
            
                height += (text as NSString).boundingRect(with: viewSize,
                                                          options: [.usesLineFragmentOrigin],
                                                          attributes: [NSFontAttributeName :  retweetedFont],
                                                          context: nil).height
            }
        }
        
        height += pictureViewSize.height
        
        height += margin
        
        height += toolbarHeight
        
        // 使用属性记录
        rowHeight = height
    }
    
    
    /// 给定义一个数字，返回对应的描述结果
    ///
    /// - parameter count:      数字
    /// - parameter defaultStr: 默认字符串，转发／评论／赞
    ///
    /// - returns: 描述结果
    /**
     如果数量 == 0，显示默认标题
     如果数量超过 10000，显示 x.xx 万
     如果数量 < 10000，显示实际数字
     */
    fileprivate func countString(count: Int, defaultStr: String) -> String {
        
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            
            return count.description
        }
        
        return String(format: "%.02f 万", Double(count) / 10000)
    }
    
    
    /// 根据视图配图的数量计算配置视图的大小
    ///
    /// - Parameter count: 数量
    /// - Returns: 大小
    fileprivate func calcPictureViewSize(count : Int?) -> CGSize{
        
        if count == nil || count == 0 {
            return CGSize()
        }
        
        
        let row = (count! - 1) / 3 + 1
        
        
        // 计算行高
        var height = DFStatusPictureViewOutterMargin
        height += CGFloat(row) * DFStatusPictureItemWidth
        height += CGFloat(row - 1) * DFStatusPictureViewInnerMargin
        
        return CGSize(width: DFStatusPictureItemWidth, height: height)
    }
    
    
    
    
    
    
    
    
    
    
    
}
