//
//  CZEmoticonInputView.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/22.
//  Copyright © 2017年 DFD. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class CZEmoticonInputView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    /// 工具栏
    @IBOutlet weak var toolbar: CZEmoticonToolbar!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    /// 记录回调
    fileprivate var selectedEmoticonCallBack : ((_ emoticon: CZEmoticon?)->())?
    
    class func inputView(selectedEmoticon:((_ emoticon: CZEmoticon?)->())?)->CZEmoticonInputView{
    
        let nib = UINib(nibName: "CZEmoticonInputView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: [:])[0] as! CZEmoticonInputView
        
        v.selectedEmoticonCallBack = selectedEmoticon
        
        return v
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 使用纯代码加载
        collectionView.register(CZEmoticonCell.self, forCellWithReuseIdentifier: cellId)
        
        
        // 设置工具栏代理
        toolbar.delegate = self
        
        // 设置分页控件的图片
        let bundle = CZEmoticonManager.shared.bundle
        
        guard let normalImage = UIImage(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
            let selectedImage = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil) else {
                return
        }
        
        // 使用填充图片设置颜色 但是有缺点，会有锯齿
        //        pageControl.pageIndicatorTintColor = UIColor(patternImage: normalImage)
        //        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: selectedImage)
        
        // 使用 KVC 设置私有成员属性
        pageControl.setValue(normalImage, forKey: "_pageImage")
        pageControl.setValue(selectedImage, forKey: "_currentPageImage")
    }
    
}

// MARK: - CZEmoticonToolbarDelegate
extension CZEmoticonInputView: CZEmoticonToolbarDelegate {
    
    func emoticonToolbarDidSelectedItemIndex(toolbar: CZEmoticonToolbar, index: Int) {
        
        // 让 collectionView 发生滚动 -> 每一个分组的第0页
        let indexPath = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        // 设置分组按钮的选中状态
        toolbar.selectedIndex = index
    }
}

extension CZEmoticonInputView : UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1 获取中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        print("center:\(center.x)")
        
        // 2 获取当前显示的 cell 的 indexPath
        let paths = collectionView.indexPathsForVisibleItems
        
        // 3 判断中心点在哪一个 indexPath 上，在哪一个页面上
        var targetIndexPath : IndexPath?
        for indexPath in paths {
            
            let cell = collectionView.cellForItem(at: indexPath)
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
                break
            }
        }
        
        
        // 4 判断是否找到 目标的 indexPath
        
        guard let target = targetIndexPath else {
            return
        }
        
        // 5 设置 ToolBar. 设置分页控件
        
        print("target.section:\(target.section)")
        
        toolbar.selectedIndex = target.section
        
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: target.section)
        pageControl.currentPage = target.item
    }

}

// MARK: - UICollectionViewDataSource
extension CZEmoticonInputView : UICollectionViewDataSource {

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CZEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CZEmoticonManager.shared.packages[section].numberOfPages
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CZEmoticonCell
        
        //print("当前的item:\(indexPath.item)")
        cell.emoticons = CZEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - CZEmoticonCellDelegate
extension CZEmoticonInputView : CZEmoticonCellDelegate {
    
    func emoticonCellDidSelectedEmoticon(cell: CZEmoticonCell, em: CZEmoticon?) {
        
        selectedEmoticonCallBack?(em)
        
        // 添加最近使用表情
        guard let em = em else {
            return
        }
        
        // 如果是当前的 colloctionView 的分组是最近， 就不添加最近使用的表情
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        // 刷新最近
        CZEmoticonManager.shared.recentEmoticon(em: em)
        
        // 刷新数据 - 第 0 组
        var indexSet = IndexSet()
        indexSet.insert(0)
        
        collectionView.reloadSections(indexSet)
    }
    
}









