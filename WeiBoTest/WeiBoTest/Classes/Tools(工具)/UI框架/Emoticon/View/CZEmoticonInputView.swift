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
        
//        let nib = UINib(nibName: "CZEmoticonCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
        
        // 使用纯代码加载
        collectionView.register(CZEmoticonCell.self, forCellWithReuseIdentifier: cellId)
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
    }
    
}









