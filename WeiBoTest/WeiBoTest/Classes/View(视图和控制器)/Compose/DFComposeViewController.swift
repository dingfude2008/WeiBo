//
//  DFComposeViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/18.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        
        guard let text = textView.text else {
            return
        }
        
//        DFNetwokrManager.shared.postStatues(text: text) { (result, isSuccess) in
//            print(result ?? "")
//        }
        // 2. 发布微博
        // FIXME: - 临时测试发布带图片的微博
//        let image: UIImage? = nil
        let image: UIImage? = UIImage(named: "icon_small_kangaroo_loading_1")
        DFNetwokrManager.shared.postStatue(text: text, image: image) { (result, isSuccess) in
            // print(result)
            
            // 修改指示器样式
            SVProgressHUD.setDefaultStyle(.dark)
            
            let message = isSuccess ? "发布成功" : "网络不给力"
            
            SVProgressHUD.showInfo(withStatus: message)
            
            // 如果成功，延迟一段时间关闭当前窗口
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                    // 恢复样式
                    SVProgressHUD.setDefaultStyle(.light)

                    self.close()
                })
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UITextViewDelegate
/**
 通知：一对多，只要有注册的监听者，在注销监听之前，都可以接收到通知！
 代理：一对一，最后设置的代理对象有效！
 
 苹果日常开发中，代理的监听方式是最多的！
 
 - 代理是发生事件时，直接让代理执行协议方法！
 代理的效率更高
 直接的反向传值
 - 通知是发生事件时，将通知发送给通知中心，通知中心再`广播`通知！
 通知相对要低一些
 如果层次嵌套的非常深，可以使用通知传值
 */
extension DFComposeViewController :  UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
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

