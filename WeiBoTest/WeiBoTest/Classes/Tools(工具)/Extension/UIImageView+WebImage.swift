//
//  UIImageView+WebImage.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/7.
//  Copyright © 2017年 dfd. All rights reserved.
//

import SDWebImage

extension UIImageView {

    /// 隔离 SDWebImage 设置图像函数
    ///
    /// - Parameters:
    ///   - urlString: 图像地址
    ///   - placeholderImage: 站位图片
    ///   - isAvatar: 是否头像
    func cz_setImage(urlString: String?, placeholderImage:UIImage?, isAvatar: Bool = false) {
        
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        
        // 这里要求传入的 placeholderImage 参数是必选类型的，但是因为这个方法是oc实现的，传入可选也是可以的
        // 即使不在回调里设置头像，这个方法也会设置图片
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) {[weak self] (image, _, _, _) in
            
            // 这里进来的 image 一定有值，如果没有值，就不会调用这个方法
            if isAvatar {
                
                self?.image = image?.cz_avatarImage(size: self?.bounds.size)
            }
        }
        
    }
    
}
