//
//  CZRefreshControl.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/12.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit



// 这个高度是应该刷新视图的高度
private let CZRefreshOffset : CGFloat = 126

/// 刷新状态
///
/// - Normal:      普通状态，什么都不做
/// - Pulling:     超过临界点，如果放手，开始刷新
/// - WillRefresh: 用户超过临界点，并且放手
enum CZRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}



/// 刷新控件 - 负责刷新相关的`逻辑`处理
class CZRefreshControl: UIControl {

    /// 开始刷新
    func beginRefreshing() {
        print("开始刷新")
        
        guard let sv = scrollView else {
            return
        }
        
        // 如果是将要刷新 就返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
        refreshView.refreshState = .WillRefresh
        
        // 通过调整 父控制器的contentInset的大小，来让刷新视图显示
        var inset = sv.contentInset
        
        inset.top += CZRefreshOffset
        
        sv.contentInset = inset
        
        // 设置刷新视图的父视图高度 让其从一开始就有高度，根据这个高度可以计算出袋鼠的高度
        refreshView.parentViewHeight = CZRefreshOffset
        
    }
    
    
    /// 结束刷新
    func endRefreshing() {
        print("结束刷新")
        
        guard let sv = scrollView else {
            return
        }
        
        // 如果是正在刷新 就返回
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        refreshView.refreshState = .Normal
        
        var insert = sv.contentInset
        
        insert.top -= CZRefreshOffset
        
        sv.contentInset = insert
    }
    
    
    /// MARK: 属性
    /// 父视图，弱应用。  因为父视图会对子视图强引用。
    /// 下拉刷新框架，使用过于  UIScrollView,  UIColloctionView
    fileprivate weak var scrollView : UIScrollView?
    
    fileprivate lazy var refreshView = CZRefreshView.refreshView()
    
    
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
        
        scrollView = svv
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        
    }
    
    /// 本视图从父视图中移除的方法
    /// 所有下拉框架都是监听父类的 contentOffset 实现的
    /// 移除的时候都是用的这个方法移除的
    override func removeFromSuperview() {
        
        // 这里的时候，superview 还有值， scrollView 应为是 weak 类型，现在已经释放了
        print("\(superview)  \(scrollView)")
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        
        // 到这里的时候， superview 也已经等于 nil 了
        
        print("\(superview)  \(scrollView)")
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView  else {
        
            return
        }
        
        
        //  contenOffest 的 y 值 与  contentInset 的 y 只有关
        
        // 初始值为 0
        let  height = -(sv.contentInset.top + sv.contentOffset.y)
        
        // 高度 < 0 就在往上推
        if height < 0 {
            return
        }
        
        
        //print(height)
        
        // 给刷新视图传递高度，让其根据高度更新UI
        
        
        // --- 传递父视图高度，如果正在刷新中，不传递
        // --- 把代码放在`最合适`的位置！
        if refreshView.refreshState != .WillRefresh {
            refreshView.parentViewHeight = height
        }
//        refreshView.parentViewHeight = height
        
        
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        
        
        
        if sv.isDragging {
         
            if height > CZRefreshOffset && refreshView.refreshState == .Normal {
                //print("放手刷新")
                refreshView.refreshState = .Pulling
            } else if height <= CZRefreshOffset && refreshView.refreshState == .Pulling {
                //print("加把劲")
                refreshView.refreshState = .Normal
            }
        } else {
            
            //print("放手")
            
            if refreshView.refreshState == .Pulling {
                //print("准备刷新")
                
                self.beginRefreshing()
                
                // 发送刷新命令
                sendActions(for: .valueChanged)
            }
        }
    }

}

extension CZRefreshControl {

    
    fileprivate func setupUI(){
    
        backgroundColor = superview?.backgroundColor
        
        //
        // 裁切，默认的是 false
        // 这里需要是否用 fase， 也就是默认的， 因为需要在进入刷新的时候，通过调整 tableView 的 contentInset 让刷新视图显示。但是调整了contentInset 会导致，刷新controll的高度变为0，从而导致刷新视图被裁切掉，所以这是使用默认的
        // clipsToBounds = true
        
        // 从xib中加载出来默认的宽高就是 xib里面的宽高
        //
        addSubview(refreshView)
        
        // 自动布局
        
        // 手动添加自动布局的话，必须先禁用这个属性
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        // 这里禁用了自动布局，宽高也就没了
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        // 宽高的对象设置为 nil
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
        
        
        
    }
}







