//
//  DFComposeViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/18.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

class DFComposeViewController: UIViewController {

    /// 文本编辑视图
    @IBOutlet weak var textView: UITextView!
    /// 底部工具栏
    @IBOutlet weak var toolbar: UIToolbar!
    
    /// 发布按钮
    @IBOutlet var sendButton: UIButton!
    
    /// 工具栏底部约束  监听键盘输入更改这个属性来实现工具栏联动
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    
    /// 标题标签 - 换行的热键 option + 回车
    /// 逐行选中文本并且设置属性
    /// 如果要想调整行间距，可以增加一个空行，设置空行的字体，从而影响到lineHeight, 字体大小约等于字体大小
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    
    
    @objc fileprivate func keyboardChanged(n:NSNotification){
        
        //print("键盘变化 : \(n)")
        guard let rect = (n.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue,
            let duration = (n.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? NSNumber)?.doubleValue
            else {
            return
        }
        
        let offest = view.bounds.height - rect.origin.y
        
        toolbarBottomCons.constant = offest
        
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc fileprivate func close(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
    /// 发布微博
    @IBAction func postStatus() {
        print("发布微博")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


private extension DFComposeViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        setupToolbar()
    }
    
    /// 设置导航栏
    func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        // 设置发送按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        // 设置标题视图
        navigationItem.titleView = titleLabel
        
        sendButton.isEnabled = false
    }
    
    /// 设置工具栏
    func setupToolbar() {
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
    
        var items = [UIBarButtonItem]()
        for s in itemSettings{
        
            guard let imageName = s["imageName"] else {
                continue
            }
            
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            
            btn.sizeToFit()
            
            // 追加按钮
            items.append(UIBarButtonItem(customView: btn))
            
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        
        toolbar.items = items
    }
}

