//
//  WBComposeTextView.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/22.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

class DFComposeTextView: UITextView {

    fileprivate lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textChanged(){
        placeholderLabel.isHidden = self.hasText
    }
}

fileprivate extension DFComposeTextView{
    
    func setupUI() {
        
        /// 监听变化 self 只管自己的变化，别的不管
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChanged),
                                               name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        placeholderLabel.font = self.font
        
        placeholderLabel.text = "说的什么吧"
        
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        
        placeholderLabel.textColor = UIColor.lightGray
        
        placeholderLabel.sizeToFit()
        
        addSubview(placeholderLabel)
    }
}
