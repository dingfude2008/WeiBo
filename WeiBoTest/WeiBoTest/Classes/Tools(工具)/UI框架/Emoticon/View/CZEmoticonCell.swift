//
//  CZEmoticonCell.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/22.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit

/// 表情 Cell 的协议
@objc protocol CZEmoticonCellDelegate : NSObjectProtocol {
    
    /// 表情 cell 选中表情模型
    ///
    /// - parameter em: 表情模型／nil 表示删除
    func emoticonCellDidSelectedEmoticon(cell: CZEmoticonCell, em: CZEmoticon?)
    
}


/// 表情的页面 Cell
/// - 每一个 cell 就是和 collectionView 一样大小
/// - 每一个 cell 中用九宫格的算法，自行添加 20 个表情
/// - 最后一个位置放置删除按钮
class CZEmoticonCell: UICollectionViewCell {

    
    /// 代理对象
    weak var delegate : CZEmoticonCellDelegate?
    
    // 当前页面的表情模型数组， 最多 20 个表情
    var emoticons : [CZEmoticon]? {
       didSet{
            //print("表情包的数量为\(emoticons?.count)")
        
            for btn in contentView.subviews {
                btn.isHidden = true
            }
        
            contentView.subviews.last?.isHidden = false
        
            for (i, emo) in (emoticons ?? []).enumerated() {
                
                let btn = contentView.subviews[i] as! UIButton
                
                // 这里 emo.image  emo.emoji 都是可选的，但是因为重写的原因，为nil的时候需要清除复用
                btn.setImage(emo.image, for: [])
                
                btn.setTitle(emo.emoji, for: [])
                
                btn.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 点击事件
    @objc func selectedEmoticonButton(button:UIButton){
    
        let tag = button.tag
        
        // nil 对应得是删除按钮
        var emo : CZEmoticon? = nil
        if tag < (emoticons ?? []).count {
            emo = emoticons?[tag]
        }
        
        delegate?.emoticonCellDidSelectedEmoticon(cell: self, em: emo)

    }
    
}

// MARK: - 设置界面
private extension CZEmoticonCell {

    // - 从 XIB 加载，bounds 是 XIB 中定义的大小，不是 size 的大小
    // - 从纯代码创建，bounds 是就是布局属性中设置的 itemSize
    func setupUI() {
        let rowCount = 3
        let colCount = 7
    
        // 左右间距
        let leftMargin: CGFloat = 8
        // 底部间距，为分页控件预留空间
        let bottomMargin: CGFloat = 16
        
        
        let w = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let h = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        // 连续创建 21 个按钮
        for i in 0..<21 {
            
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton()
            
            // 设置按钮的大小
            let x = leftMargin + CGFloat(col) * w
            let y = CGFloat(row) * h
            
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            
            // 添加到 contentView 中
            contentView.addSubview(btn)
            
            // 设置按钮的字体大小，lineHeight 基本上和图片的大小差不多！ 查看图片来设置这个大小
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            // 设置按钮的 tag
            btn.tag = i
            // 添加监听方法
            btn.addTarget(self, action: #selector(selectedEmoticonButton), for: .touchUpInside)
        }
        
        
        // 取出末尾的删除按钮
        let removeButton = contentView.subviews.last as! UIButton
        
        // 设置图像
        let image = UIImage(named: "compose_emotion_delete_highlighted", in: CZEmoticonManager.shared.bundle, compatibleWith: nil)
        removeButton.setImage(image, for: [])
    }
}
