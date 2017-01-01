//
//  DFOAuthViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/28.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

let client_id = "1027304610"

let redirect_uri = "http://www.sz-hema.com/"

let secret = "c0733c56ed9f6a670301b975d7b6faeb"


class DFOAuthViewController: UIViewController {

    fileprivate lazy var webView = UIWebView()
    
    // 把view设置webView
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
//        let urlString = "https://www.baidu.com"
        
        guard let url = URL(string: urlString) else {
            return
        }
//
        
        
//        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
        
    }

    @objc fileprivate func close(){
    
        dismiss(animated: true, completion: nil)
    
    }
}
