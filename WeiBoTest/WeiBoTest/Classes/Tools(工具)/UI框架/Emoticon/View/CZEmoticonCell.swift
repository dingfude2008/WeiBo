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
    
    fileprivate lazy var tipView : CZEmoticonTipView = CZEmoticonTipView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard let w = newWindow else {
            return
        }
        
        w.addSubview(tipView)
        
        tipView.isHidden = true
        
    }
    
    // 点击事件
    @objc func selectedEmoticonButton(_ button:UIButton){
    
        let tag = button.tag
        
        // nil 对应得是删除按钮
        var emo : CZEmoticon? = nil
        if tag < (emoticons ?? []).count {
            emo = emoticons?[tag]
        }
        
        delegate?.emoticonCellDidSelectedEmoticon(cell: self, em: emo)
    }
    
    
    /// 长按手势
    /// 可以保证一个对象监听两种点击手势，而且不用考虑手势冲突
    @objc func longGesture(gesture:UILongPressGestureRecognizer){
    
        print("长按手势")
        
        // 1 获取触摸位置
        let location = gesture.location(in: self)
        
        // 2 获取触摸位置的按钮
        guard let button = buttonWithLocation(location) else {
            
            tipView.isHidden = true
            return
        }
        // 3 处理手势状态
        
        switch gesture.state {
            case .began, .changed:
            
                tipView.isHidden = false
            
                /// 坐标系转换，将参照 cell 的坐标系，转换为参照 window 的坐标
                let center = self.convert(button.center, to: window)
            
                // 设置 tipView 的位置
                tipView.center = center
                
                if button.tag < (emoticons?.count ?? 0) {
                    tipView.emoticon = emoticons?[button.tag]
                }
            break
            case .ended:
            
                tipView.isHidden = true
                selectedEmoticonButton(button)
            break
            case .cancelled, .failed:
                tipView.isHidden = true
            break
            default:
            break
                
            }
    }
    
    // 根据在Cell中的位置，获取这个位置的按钮
    fileprivate func buttonWithLocation(_ location:CGPoint) -> UIButton?{
    
        for btn in contentView.subviews {
            
            if btn.frame.contains(location) && !btn.isHidden && btn != contentView.subviews.last {
                return (btn as? UIButton)
            }
        }
        
        return nil
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
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longGesture))
        
        longPress.minimumPressDuration = 0.1
        
        self.addGestureRecognizer(longPress)
        
    }
}
