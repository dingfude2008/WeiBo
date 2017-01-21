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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        
        setupUI()
        
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
        //setupToolbar()
    }
    
    /// 设置导航栏
    func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        // 设置发送按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        // 设置标题视图
        //navigationItem.titleView = titleLabel
        
//        sendButton.isEnabled = false
    }
}

