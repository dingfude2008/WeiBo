//
//  CZRefreshControl.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/12.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit


/// 刷新控件 - 负责刷新相关的`逻辑`处理
class CZRefreshControl: UIControl {

    /// 开始刷新
    func beginRefreshing() {
        print("开始刷新")
    }
    
    
    /// 结束刷新
    func endRefreshing() {
        print("结束刷新")
    }
    
    
    /// MARK: 属性
    /// 父视图，弱应用。  因为父视图会对子视图强引用。
    /// 下拉刷新框架，使用过于  UIScrollView,  UIColloctionView
    fileprivate weak var sv : UIScrollView?
    
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    
    /// 这个方法触发的两个点  1，被添加到父视图中， newSuperview 是父视图
    ///                   2，父视图被销毁的时候， newSuperview 是 nil
    /// - Parameter newSuperview:
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let svv = newSuperview as? UIScrollView else {
            return
        }
        
        sv = svv
        
        sv?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        //  contenOffest 的 y 值 与  contentInset 的 y 只有关
        
        // 初始值为 0
        let  height = -(sv!.contentInset.top + sv!.contentOffset.y)
        
        print(height)
        
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv!.bounds.width,
                            height: height)
        
    }

}

extension CZRefreshControl {

    
    fileprivate func setupUI(){
    
        backgroundColor = UIColor.orange
        
//        backgroundColor = superview?.backgroundColor
        
//        self.addSubview(<#T##view: UIView##UIView#>)
    }
}
