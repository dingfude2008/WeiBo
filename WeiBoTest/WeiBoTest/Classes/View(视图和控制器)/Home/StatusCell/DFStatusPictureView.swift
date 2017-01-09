//
//  DFStatusPicture.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/7.
//  Copyright © 2017年 dfd. All rights reserved.
//

import Foundation

class DFStatusPictureView: UIView {
    
    var viewModel : DFStatesViewModel? {
        didSet {
            calcViewSize()
        }
    }
    
    /// 根据视图模型的配图视图大小，调整显示内容
    fileprivate func calcViewSize() {
        
        // 处理宽度
        // 1> 单图，根据配图视图的大小，修改 subviews[0] 的宽高
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            
            // a) 获取第0个图像视图
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: DFStatusPictureViewOutterMargin,
                             width: viewSize.width,
                             height: viewSize.height - DFStatusPictureViewOutterMargin)
            // 这里 - WBStatusPictureViewOutterMargin 是因为缓存之前 pictureViewSize加过的，现在减去
        } else {
            // 2> 多图(无图)，回复 subview[0] 的宽高，保证九宫格布局的完整
            
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: DFStatusPictureViewOutterMargin,
                             width: DFStatusPictureItemWidth,
                             height: DFStatusPictureItemWidth)
        }
        
        // 修改高度约束
        heigthCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    var urls:[DFStatusPicture]? {
        didSet{
            
            // 这里因为重用的关系，即使设置为nil 也会显示另一个图像的图片，所以必须全部隐藏
            
            for v in subviews {
                v.isHidden = true
            }
        
            var index = 0
            for statusPicModel in urls ?? [] {
                
                let iv = subviews[index] as! UIImageView
                
                iv.contentMode = .scaleAspectFill
                
                // 4 张图的处理， 跳过 第三张图
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                
                iv.cz_setImage(urlString: statusPicModel.thumbnail_pic, placeholderImage: nil)
                
                iv.isHidden = false
                
                index += 1
            }
            
            
        }
    }
    
    /// 配图视图的高度
    @IBOutlet weak var heigthCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
    }
    
}

extension DFStatusPictureView {

    /*
        1, Cell中所有的空间都是提前准备好
        2, 设置的时候根据数据决定是否显示
        3, 不要动态创建控件
     */
    ///
    fileprivate func setupUI(){
        
        backgroundColor = superview?.backgroundColor
        
        // 裁切掉多余的
        clipsToBounds = true
        
        let count = 3
        
        let rect = CGRect(x: 0,
                          y: DFStatusPictureViewOutterMargin,
                          width: DFStatusPictureItemWidth,
                          height: DFStatusPictureItemWidth)
        
        for i in 0..<count * count {
            
            let iv = UIImageView()
            
            iv.backgroundColor = UIColor.red
            
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            // 行  - > y
            let row = CGFloat(i / count)
            
            // 列  - > x
            let col = CGFloat(i % count)
            
            let xOffest = col * (DFStatusPictureItemWidth + DFStatusPictureViewInnerMargin)
            
            let yOffest = row * (DFStatusPictureItemWidth + DFStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffest, dy: yOffest)
            
            addSubview(iv)
        }
        
        
        
        
        
        
        
        
    }
}
